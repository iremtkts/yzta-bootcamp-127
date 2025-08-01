from fastapi import APIRouter, Depends, UploadFile, File, HTTPException
from sqlalchemy.orm import Session
import requests
from core.database import SessionLocal
from api.v1.auth import get_current_user
from services.gemini_service import get_skin_care_advice
from services.image import (
    upload_image_to_cloudinary,
    upload_annotated_to_cloudinary,
    save_image_record
)
from services.bbox_drawer import draw_bboxes
import core.cloudinary_config

router = APIRouter(prefix="/ai", tags=["AI Analysis"])

MODEL_API_URL = "https://yzta-bootcamp-127-production.up.railway.app/detect"

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()



@router.post("/analyze-image")
def analyze_image(
    file: UploadFile = File(...),
    db: Session = Depends(get_db),
    current_user=Depends(get_current_user)
):
   
    original_url, original_pid = upload_image_to_cloudinary(file.file, current_user.id)
    save_image_record(db, current_user.id, original_url, original_pid, is_annotated=False)


    payload = {"image_url": original_url}
    response = requests.post(MODEL_API_URL, json=payload)
    if response.status_code != 200:
        raise HTTPException(status_code=response.status_code, detail="YOLO API request failed")
    model_result = response.json()

  
    detections = []
    detected_classes = []
    for model_data in model_result.get("model_outputs", {}).values():
        for det in model_data.get("detections", []):
            detections.append(det)
            detected_classes.append(det["class_name"])

 
    annotated_file = draw_bboxes(original_url, detections)

 
    annotated_url, annotated_pid = upload_annotated_to_cloudinary(annotated_file, current_user.id)
    save_image_record(db, current_user.id, annotated_url, annotated_pid, is_annotated=True)

 
    skin_care_advice = get_skin_care_advice(detected_classes)

    return {
        "original_url": original_url,
        "annotated_url": annotated_url,
        "model_result": model_result,
        "skin_care_advice": skin_care_advice
    }
