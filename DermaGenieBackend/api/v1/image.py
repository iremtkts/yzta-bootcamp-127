from fastapi import APIRouter, Depends, UploadFile, File
from sqlalchemy.orm import Session
from services.image import create_image, get_user_images
from core.database import SessionLocal
from api.v1.auth import get_current_user
from schemas.image import ImageOut
import core.cloudinary_config  

router = APIRouter()

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

@router.post("/upload", response_model=ImageOut)
def upload_image(file: UploadFile = File(...), db: Session = Depends(get_db), current_user=Depends(get_current_user)):
    return create_image(db, user_id=current_user.id, file=file.file)

@router.get("/", response_model=list[ImageOut])
def list_images(db: Session = Depends(get_db), current_user=Depends(get_current_user)):
    return get_user_images(db, user_id=current_user.id)
