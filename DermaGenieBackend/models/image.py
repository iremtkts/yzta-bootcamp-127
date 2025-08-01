from sqlalchemy import Column, Integer, String, ForeignKey, Boolean
from sqlalchemy.orm import relationship
from core.database import Base
from typing import TYPE_CHECKING

if TYPE_CHECKING:
    from models.user import User

class Image(Base):
    __tablename__ = "images"
    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(Integer, ForeignKey("users.id"))
    url = Column(String, nullable=False)
    public_id = Column(String, nullable=False)  
    is_annotated = Column(Boolean, default=False) 

    user = relationship("User", back_populates="images")
