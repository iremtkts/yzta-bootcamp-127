import cloudinary.uploader
from models.image import Image
from sqlalchemy.orm import Session

def upload_image_to_cloudinary(file):
    result = cloudinary.uploader.upload(file)
    return result["secure_url"], result["public_id"]

def create_image(db: Session, user_id: int, file):
    url, public_id = upload_image_to_cloudinary(file)
    db_image = Image(user_id=user_id, url=url, public_id=public_id)
    db.add(db_image)
    db.commit()
    db.refresh(db_image)
    return db_image

def get_user_images(db: Session, user_id: int):
    return db.query(Image).filter(Image.user_id == user_id).all()
