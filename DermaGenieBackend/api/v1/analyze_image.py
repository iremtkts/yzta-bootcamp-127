from fastapi import APIRouter, Depends, UploadFile, File, HTTPException
from sqlalchemy.orm import Session
import requests
import uuid
from core.database import SessionLocal
from api.v1.auth import get_current_user
from services.image import (
    upload_image_to_cloudinary,
    upload_annotated_to_cloudinary,
    save_image_record,
    delete_from_cloudinary
)
from services.bbox_drawer import draw_bboxes
from services.gemini_service import get_skin_care_advice
import core.cloudinary_config
from models.image import Image

router = APIRouter(prefix="/ai", tags=["AI Analysis"])

MODEL_API_URL = "https://yzta-bootcamp-127-production.up.railway.app/detect"

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()


@router.post("/analyze-image")
def analyze_image(file: UploadFile = File(...), db: Session = Depends(get_db), current_user=Depends(get_current_user)):
    analysis_id = str(uuid.uuid4())


    original_url, pid_original = upload_image_to_cloudinary(file.file, current_user.id)

   
    payload = {"image_url": original_url}
    response = requests.post(MODEL_API_URL, json=payload)
    response.raise_for_status()
    model_result = response.json()

    detections = []
    detected_classes = set()
    for model_data in model_result.get("model_outputs", {}).values():
        for det in model_data.get("detections", []):
            detections.append(det)
            detected_classes.add(det["class_name"])

    skin_care_advice = get_skin_care_advice(list(detected_classes), current_user.gender)


    annotated_file = draw_bboxes(original_url, detections)
    annotated_url, pid_annotated = upload_annotated_to_cloudinary(annotated_file, current_user.id)


    save_image_record(
        db,
        user_id=current_user.id,
        analysis_id=analysis_id,
        original_url=original_url,
        annotated_url=annotated_url,
        public_id_original=pid_original,
        public_id_annotated=pid_annotated,
        detected_classes=list(detected_classes),
        genai_response=skin_care_advice
    )

    return {
        "analysis_id": analysis_id,
        "original_url": original_url,
        "annotated_url": annotated_url,
        "model_result": model_result,
        "skin_care_advice": skin_care_advice
    }


@router.get("/list")
def list_analyses(db: Session = Depends(get_db), current_user=Depends(get_current_user)):
    analyses = (
        db.query(Image)
        .filter(Image.user_id == current_user.id)
        .order_by(Image.created_at.desc())
        .all()
    )

    return [
        {
            "analysis_id": img.analysis_id,
            "original_url": img.original_url,
            "annotated_url": img.annotated_url,
            "detected_classes": img.detected_classes.split(",") if img.detected_classes else [],
            "genai_response": img.genai_response,
            "created_at": img.created_at
        }
        for img in analyses
    ]



@router.delete("/delete/{analysis_id}")
def delete_analysis(
    analysis_id: str,
    db: Session = Depends(get_db),
    current_user=Depends(get_current_user)
):
    related_images = db.query(Image).filter(
        Image.analysis_id == analysis_id,
        Image.user_id == current_user.id
    ).all()

    if not related_images:
        raise HTTPException(status_code=404, detail="Analysis not found")

    for img in related_images:
      
        if img.public_id_original:
            delete_from_cloudinary(img.public_id_original)

       
        if img.public_id_annotated:
            delete_from_cloudinary(img.public_id_annotated)

        
        db.delete(img)

    db.commit()
    return {"message": "Analysis deleted successfully"}
