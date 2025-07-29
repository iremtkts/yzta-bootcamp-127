from sqlalchemy import Column, Integer, String, Boolean
from core.database import Base
from sqlalchemy.orm import relationship
from typing import TYPE_CHECKING

if TYPE_CHECKING:
    from models.image import Image

class User(Base):
    __tablename__ = "users"
    id = Column(Integer, primary_key=True, index=True)
    username = Column(String, unique=True, index=True, nullable=False)
    password_hash = Column(String, nullable=False)
    full_name = Column(String)
    city = Column(String)
    age = Column(Integer)
    gender = Column(String)
    images = relationship("Image", back_populates="user")
    
