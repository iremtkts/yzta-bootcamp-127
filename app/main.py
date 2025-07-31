import os
import io
import json
import math
import asyncio
import pathlib
from typing import Dict, List, Optional, Any, Union
import re, base64

from dotenv import load_dotenv
from fastapi import FastAPI, HTTPException, Query
from pydantic import BaseModel, HttpUrl
from fastapi.middleware.cors import CORSMiddleware
from PIL import Image, UnidentifiedImageError

import httpx
import torch


# ----------------------------------------------------
# ENV & PATHS
# ----------------------------------------------------
load_dotenv()  

BASE_DIR = pathlib.Path(__file__).resolve().parent


YOLO_CONFIG_DIR = os.getenv("YOLO_CONFIG_DIR", "/app/.ultralytics")
os.environ["YOLO_CONFIG_DIR"] = YOLO_CONFIG_DIR
pathlib.Path(YOLO_CONFIG_DIR).mkdir(parents=True, exist_ok=True)


MODELS_DIR = pathlib.Path(os.getenv("MODELS_DIR", str(BASE_DIR / "models")))
MODELS_DIR.mkdir(parents=True, exist_ok=True)

DEFAULT_MODEL_A_PATH = MODELS_DIR / "best_a.pt"
DEFAULT_MODEL_B_PATH = MODELS_DIR / "best_b.pt"

env_model_a = os.getenv("MODEL_A_PATH", str(DEFAULT_MODEL_A_PATH))
env_model_b = os.getenv("MODEL_B_PATH", str(DEFAULT_MODEL_B_PATH))

MIN_MODEL_BYTES = int(os.getenv("MIN_MODEL_BYTES", "5000000"))  


MODEL_A_PATH = pathlib.Path(env_model_a)
if not MODEL_A_PATH.is_absolute():
    MODEL_A_PATH = (BASE_DIR / MODEL_A_PATH).resolve()

MODEL_B_PATH = pathlib.Path(env_model_b)
if not MODEL_B_PATH.is_absolute():
    MODEL_B_PATH = (BASE_DIR / MODEL_B_PATH).resolve()

# URL env'leri (opsiyonel)
MODEL_A_URL = os.getenv("MODEL_A_URL")
MODEL_B_URL = os.getenv("MODEL_B_URL")

# ----------------------------------------------------
# Inference ayarları
# ----------------------------------------------------
MODEL_A_CONF_DEFAULT = float(os.getenv("MODEL_A_CONF_DEFAULT", "0.35"))
MODEL_A_SUPPRESS_THR = float(os.getenv("MODEL_A_SUPPRESS_THR", "0.60"))
MODEL_B_MIN_CONF = float(os.getenv("MODEL_B_MIN_CONF", "0.01"))
IOU_DEFAULT = float(os.getenv("IOU_DEFAULT", "0.45"))

DEFAULT_B_THRESHOLDS = {
    "Acne": 0.15, "Dry-Skin": 0.12, "Englarged-Pores": 0.18,
    "Eyebags": 0.25, "Oily-Skin": 0.12, "Skin-Redness": 0.12, "Wrinkles": 0.25
}
MODEL_B_THRESHOLDS_JSON = os.getenv("MODEL_B_THRESHOLDS_JSON", "")
try:
    RAW_B_THRESHOLDS = json.loads(MODEL_B_THRESHOLDS_JSON) if MODEL_B_THRESHOLDS_JSON else DEFAULT_B_THRESHOLDS
except Exception:
    RAW_B_THRESHOLDS = DEFAULT_B_THRESHOLDS

DEVICE = "cuda:0" if torch.cuda.is_available() else "cpu"

torch.backends.cudnn.benchmark = torch.cuda.is_available()

DEFAULT_HEADERS = {
    "User-Agent": "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124 Safari/537.36",
    "Accept": "image/avif,image/webp,image/*;q=0.8,*/*;q=0.5",
}

# ----------------------------------------------------
# MODELS: indirme & çözümleme
# ----------------------------------------------------

def _is_lfs_pointer_bytes(b: bytes) -> bool:
    
    return b.startswith(b"version https://git-lfs.github.com/spec/v1") or b"git-lfs" in b

def _validate_model_file(path: pathlib.Path, name: str):
    if not path.exists():
        raise RuntimeError(f"{name}: dosya yok: {path}")
    size = path.stat().st_size
    with open(path, "rb") as f:
        head = f.read(256)
    if size < MIN_MODEL_BYTES or _is_lfs_pointer_bytes(head) or head.lstrip().startswith(b"<"):
       
        raise RuntimeError(
            f"{name}: indirilen/okunan dosya geçersiz görünüyor: {path} "
            f"(size={size}B). HF'de **Raw** linki kullandığından ve dosyanın "
            f"gerçek .pt olduğundan emin ol."
        )

async def http_download(url: str, out_path: pathlib.Path, timeout: float = 600.0):
    out_path.parent.mkdir(parents=True, exist_ok=True)

    if out_path.exists() and out_path.stat().st_size >= MIN_MODEL_BYTES:
        return
    async with httpx.AsyncClient(follow_redirects=True, timeout=httpx.Timeout(timeout)) as client:
        async with client.stream("GET", url, headers=DEFAULT_HEADERS) as r:
            r.raise_for_status()
            with open(out_path, "wb") as f:
                async for chunk in r.aiter_bytes(chunk_size=1 << 20):
                    if chunk:
                        f.write(chunk)

    _validate_model_file(out_path, f"DOWNLOAD[{url}]")

def _normalize_google_drive(url: str) -> str:
    m = re.search(r"drive\.google\.com/file/d/([^/]+)/", url)
    if m:
        file_id = m.group(1)
        return f"https://drive.google.com/uc?export=download&id={file_id}"
    return url

def _looks_like_image_url(url: str) -> bool:
    return url.lower().split("?")[0].endswith(
        (".jpg",".jpeg",".png",".webp",".bmp",".gif",".tif",".tiff",".heic",".heif")
    )

# ----------------------------------------------------
# IMAGE helpers
# ----------------------------------------------------
def pil_from_bytes(data: bytes, ctype: str = "") -> Image.Image:
    if ("heic" in ctype) or ("heif" in ctype):
        try:
            import pillow_heif
            heif = pillow_heif.read_heif(data)
            img = Image.frombytes(heif.mode, heif.size, heif.data, "raw")
            if img.mode not in ("RGB","RGBA"):
                img = img.convert("RGB")
            return img
        except Exception as e:
            raise HTTPException(400, f"HEIC/HEIF dosyası okunamadı: {e}")
    try:
        img = Image.open(io.BytesIO(data)); img.load()
        if img.mode not in ("RGB","RGBA"):
            img = img.convert("RGB")
        return img
    except UnidentifiedImageError:
        raise HTTPException(400, "URL’den gelen içerik görüntü değil ya da bozuk (Pillow açamadı).")

async def fetch_image(url: str, timeout: float = 20.0) -> Image.Image:
    if url.startswith("data:image/"):
        header, b64 = url.split(",", 1)
        ctype = header.split(";")[0].split(":")[1]
        try:
            raw = base64.b64decode(b64, validate=True)
        except Exception:
            raise HTTPException(400, "Geçersiz data URL (base64) verisi.")
    else:
        url = _normalize_google_drive(url)
        async with httpx.AsyncClient(follow_redirects=True, timeout=httpx.Timeout(timeout)) as client:
            r = await client.get(url, headers=DEFAULT_HEADERS)
        if r.status_code != 200 or r.content is None:
            raise HTTPException(400, f"Görüntü indirilemedi (HTTP {r.status_code}).")
        ctype = r.headers.get("content-type","").lower()
        if not ctype.startswith("image/") and not _looks_like_image_url(url):
            snippet = r.text[:120].replace("\n"," ") if r.text else ""
            raise HTTPException(400, f"URL görüntü gibi değil. content-type='{ctype}', body='{snippet}...'")
        raw = r.content
    return pil_from_bytes(raw, ctype if 'ctype' in locals() else "")

# ----------------------------------------------------
# INFERENCE helpers
# ----------------------------------------------------
class BBox(BaseModel):
    x1: float; y1: float; x2: float; y2: float

class Detection(BaseModel):
    class_id: int
    class_name: str
    confidence: float
    bbox: BBox

def to_detections(result, names: Dict[int,str]) -> List[Detection]:
    boxes = result.boxes
    xyxy = boxes.xyxy.detach().cpu().numpy().tolist() if boxes.xyxy is not None else []
    confs = boxes.conf.detach().cpu().numpy().tolist() if boxes.conf is not None else []
    clss = boxes.cls.detach().cpu().numpy().astype(int).tolist() if boxes.cls is not None else []
    out: List[Detection] = []
    for (x1,y1,x2,y2),conf,cid in zip(xyxy,confs,clss):
        out.append(Detection(
            class_id=int(cid),
            class_name=names.get(int(cid), str(cid)),
            confidence=float(conf),
            bbox=BBox(x1=float(x1), y1=float(y1), x2=float(x2), y2=float(y2))
        ))
    return out

def iou_xyxy(a: BBox, b: BBox) -> float:
    ix1, iy1 = max(a.x1,b.x1), max(a.y1,b.y1)
    ix2, iy2 = min(a.x2,b.x2), min(a.y2,b.y2)
    iw, ih = max(0.0, ix2-ix1), max(0.0, iy2-iy1)
    inter = iw*ih
    if inter <= 0.0: return 0.0
    area_a = max(0.0, a.x2-a.x1) * max(0.0, a.y2-a.y1)
    area_b = max(0.0, b.x2-b.x1) * max(0.0, b.y2-b.y1)
    union = area_a + area_b - inter
    return inter/union if union>0 else 0.0

def merge_union_iou(dets_a: List[Detection], dets_b: List[Detection], iou_thr: float=0.5) -> List[Detection]:
    merged: List[Detection] = []
    used_b = set()
    for da in dets_a:
        best_j, best_iou = None, 0.0
        for j, db in enumerate(dets_b):
            if j in used_b or db.class_id != da.class_id: continue
            iou = iou_xyxy(da.bbox, db.bbox)
            if iou > best_iou:
                best_iou, best_j = iou, j
        if best_j is not None and best_iou >= iou_thr:
            db = dets_b[best_j]; used_b.add(best_j)
            conf = 1.0 - (1.0 - da.confidence) * (1.0 - db.confidence)
            box = BBox(
                x1=(da.bbox.x1+db.bbox.x1)/2.0, y1=(da.bbox.y1+db.bbox.y1)/2.0,
                x2=(da.bbox.x2+db.bbox.x2)/2.0, y2=(da.bbox.y2+db.bbox.y2)/2.0
            )
            merged.append(Detection(class_id=da.class_id, class_name=da.class_name, confidence=float(conf), bbox=box))
        else:
            merged.append(da)
    for j, db in enumerate(dets_b):
        if j not in used_b:
            merged.append(db)
    return merged

def total_ms(result) -> float:
    try:
        spd = result.speed
        return float(sum(spd.values()))
    except Exception:
        return math.nan

async def run_model(model: YOLO, image: Image.Image, conf: float, iou: float, max_det: int, imgsz: int) -> Any:
    def _predict():
        return model.predict(source=image, conf=conf, iou=iou, max_det=max_det, device=DEVICE, verbose=False, imgsz=imgsz)
    return await asyncio.to_thread(_predict)

# ----------------------------------------------------
# FASTAPI app & schemas
# ----------------------------------------------------
class DetectRequest(BaseModel):
    image_url: Union[HttpUrl, str]

class ModelOutput(BaseModel):
    model_name: str
    time_ms: float
    detections: List[Detection]
    suppressed: Optional[bool] = None

class EnsembleOutput(BaseModel):
    strategy: str
    detections: List[Detection]

class DetectResponse(BaseModel):
    device: str
    image_size: List[int]
    model_outputs: Dict[str, ModelOutput]
    ensemble: Optional[EnsembleOutput] = None

app = FastAPI(title="Dual YOLO Inference API", version="1.2.0")
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"], allow_credentials=True, allow_methods=["*"], allow_headers=["*"]
)

model_a: Optional[YOLO] = None
model_b: Optional[YOLO] = None
model_b_class_thresholds: Dict[int, float] = {}

# ----------------------------------------------------
# STARTUP
# ----------------------------------------------------
@app.on_event("startup")
@app.on_event("startup")
async def startup():
    global model_a, model_b, model_b_class_thresholds

    # 0) OpenCV mevcut mu? Yoksa anlaşılır mesajla fail et
    try:
        import cv2
        print("OpenCV (cv2) version:", cv2.__version__)
    except Exception as e:
        raise RuntimeError(
            f"OpenCV (cv2) import edilemedi: {e}. "
            f"Build sırasında opencv-python-headless kurulumunu kontrol edin."
        )

    if MODEL_A_URL:
        await http_download(MODEL_A_URL, MODEL_A_PATH, timeout=600.0)
    if MODEL_B_URL:
        await http_download(MODEL_B_URL, MODEL_B_PATH, timeout=600.0)

    if not MODEL_A_PATH.exists():
        raise RuntimeError(f"Model A bulunamadı: {MODEL_A_PATH}")
    if not MODEL_B_PATH.exists():
        raise RuntimeError(f"Model B bulunamadı: {MODEL_B_PATH}")

    from ultralytics import YOLO

    model_a = YOLO(str(MODEL_A_PATH)).to(DEVICE)
    model_b = YOLO(str(MODEL_B_PATH)).to(DEVICE)

    name2id = {str(v).lower(): k for k, v in model_b.names.items()}
    model_b_class_thresholds.clear()
    for key, thr in (RAW_B_THRESHOLDS or {}).items():
        key_str = str(key)
        cid = int(key_str) if key_str.isdigit() else name2id.get(key_str.lower())
        if cid is None:
            continue
        try:
            model_b_class_thresholds[int(cid)] = float(thr)
        except Exception:
            continue

# ----------------------------------------------------
# ROUTES
# ----------------------------------------------------
@app.get("/health")
def health():
    return {
        "status": "ok",
        "device": DEVICE,
        "yolo_config_dir": YOLO_CONFIG_DIR,
        "models_dir": str(MODELS_DIR),
        "model_a": str(MODEL_A_PATH),
        "model_b": str(MODEL_B_PATH),
        "model_a_conf_default": MODEL_A_CONF_DEFAULT,
        "model_a_suppress_thr": MODEL_A_SUPPRESS_THR,
        "model_b_min_conf": MODEL_B_MIN_CONF,
        "model_b_class_thresholds": model_b_class_thresholds,
    }

@app.get("/labels")
def labels():
    if model_a is None or model_b is None:
        raise HTTPException(status_code=503, detail="Models not ready.")
    return {"model_a": model_a.names, "model_b": model_b.names}

@app.post("/detect", response_model=DetectResponse)
async def detect(
    payload: DetectRequest,
    conf_a: float = Query(None, description="Model A conf (default=ENV MODEL_A_CONF_DEFAULT)"),
    conf_a_fallback: float = Query(0.30, ge=0.01, le=0.95, description="A hiç kutu vermezse ikinci deneme conf"),
    conf_b_min: float = Query(None, description="Model B min conf (default=ENV MODEL_B_MIN_CONF)"),
    iou: float = Query(IOU_DEFAULT, ge=0.05, le=0.95, description="NMS IoU"),
    max_det: int = Query(300, ge=1, le=3000, description="Max detections"),
    imgsz: int = Query(640, ge=256, le=2048, description="Genel input boyutu"),
    imgsz_a: Optional[int] = Query(None, ge=256, le=2048, description="Model A için özel imgsz"),
    imgsz_b: Optional[int] = Query(None, ge=256, le=2048, description="Model B için özel imgsz"),
    ensemble: bool = Query(False, description="(Farklı ontoloji olduğu için önerilmez)"),
):
    if model_a is None or model_b is None:
        raise HTTPException(status_code=503, detail="Models not ready.")

    img = await fetch_image(str(payload.image_url))
    w, h = img.size

    conf_a_val = float(conf_a) if conf_a is not None else MODEL_A_CONF_DEFAULT
    conf_b_min_val = float(conf_b_min) if conf_b_min is not None else MODEL_B_MIN_CONF

    # ---- A
    res_a = await run_model(model_a, img, conf=conf_a_val, iou=iou, max_det=max_det, imgsz=imgsz_a or imgsz)
    ra = res_a[0]
    dets_a = to_detections(ra, names=model_a.names)

    if len(dets_a) == 0 and conf_a_fallback < conf_a_val:
        res_a2 = await run_model(model_a, img, conf=conf_a_fallback, iou=iou, max_det=max_det, imgsz=imgsz_a or imgsz)
        ra = res_a2[0]
        dets_a = to_detections(ra, names=model_a.names)

    out_a = ModelOutput(model_name=MODEL_A_PATH.name, time_ms=total_ms(ra), detections=dets_a)

    # ---- B (gerekirse)
    a_has_strong = any(d.confidence >= MODEL_A_SUPPRESS_THR for d in dets_a)
    model_outputs: Dict[str, ModelOutput] = {"model_a": out_a}

    if a_has_strong:
        out_b = ModelOutput(model_name=MODEL_B_PATH.name, time_ms=0.0, detections=[], suppressed=True)
        model_outputs["model_b"] = out_b
        return DetectResponse(device=DEVICE, image_size=[w, h], model_outputs=model_outputs, ensemble=None)

    res_b = await run_model(model_b, img, conf=conf_b_min_val, iou=iou, max_det=max_det, imgsz=imgsz_b or imgsz)
    rb = res_b[0]
    dets_b_all = to_detections(rb, names=model_b.names)

    filtered_b: List[Detection] = []
    for d in dets_b_all:
        thr = model_b_class_thresholds.get(d.class_id, conf_b_min_val)
        if d.confidence >= thr:
            filtered_b.append(d)

    out_b = ModelOutput(model_name=MODEL_B_PATH.name, time_ms=total_ms(rb), detections=filtered_b, suppressed=False)
    model_outputs["model_b"] = out_b

    resp = DetectResponse(device=DEVICE, image_size=[w, h], model_outputs=model_outputs, ensemble=None)
    if ensemble:
        merged = merge_union_iou(dets_a, filtered_b, iou_thr=0.5)
        resp.ensemble = EnsembleOutput(strategy="union_iou>=0.5", detections=merged)
    return resp
