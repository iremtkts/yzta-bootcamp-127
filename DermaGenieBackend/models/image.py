from sqlalchemy import Column, Integer, String, ForeignKey, Text, DateTime
from sqlalchemy.orm import relationship
from datetime import datetime
from core.database import Base
from typing import TYPE_CHECKING

if TYPE_CHECKING:
    from models.user import User


class Image(Base):
    __tablename__ = "images"
    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(Integer, ForeignKey("users.id"))
    analysis_id = Column(String, index=True)
    original_url = Column(String, nullable=False)
    annotated_url = Column(String)
    public_id_original = Column(String, nullable=False)
    public_id_annotated = Column(String)
    detected_classes = Column(Text)
    genai_response = Column(Text)
    created_at = Column(DateTime, default=datetime.utcnow)
    user = relationship("User", back_populates="images")

