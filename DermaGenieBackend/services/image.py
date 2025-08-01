import cloudinary.uploader
from models.image import Image
from sqlalchemy.orm import Session


def upload_image_to_cloudinary(file, user_id: int):
    result = cloudinary.uploader.upload(
        file,
        folder=f"user_{user_id}",
        resource_type="image"
    )
    return result["secure_url"], result["public_id"]


def upload_annotated_to_cloudinary(file_obj, user_id: int):
    result = cloudinary.uploader.upload(
        file_obj,
        folder=f"user_{user_id}",
        public_id=f"yolo_{user_id}",
        resource_type="image"
    )
    return result["secure_url"], result["public_id"]

def save_image_record(db: Session, user_id: int, url: str, public_id: str, is_annotated: bool = False):
    db_image = Image(
        user_id=user_id,
        url=url,
        public_id=public_id,
        is_annotated=is_annotated
    )
    db.add(db_image)
    db.commit()
    db.refresh(db_image)
    return db_image

def save_image_record(db: Session, user_id: int, url: str, public_id: str):
    db_image = Image(user_id=user_id, url=url, public_id=public_id)
    db.add(db_image)
    db.commit()
    db.refresh(db_image)
    return db_image
