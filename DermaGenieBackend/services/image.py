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


def save_image_record(
    db: Session,
    user_id: int,
    analysis_id: str,
    original_url: str,
    annotated_url: str,
    public_id_original: str,
    public_id_annotated: str,
    detected_classes: list[str] = None,
    genai_response: str = None
):
    detected_classes_str = ",".join(detected_classes) if detected_classes else None

    db_image = Image(
        user_id=user_id,
        analysis_id=analysis_id,
        original_url=original_url,
        annotated_url=annotated_url,
        public_id_original=public_id_original,
        public_id_annotated=public_id_annotated,
        detected_classes=detected_classes_str,
        genai_response=genai_response
    )
    db.add(db_image)
    db.commit()
    db.refresh(db_image)
    return db_image


def delete_from_cloudinary(public_id: str):
    cloudinary.uploader.destroy(public_id)
