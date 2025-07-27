from sqlalchemy import Column, Integer, String, Boolean
from core.database import Base

class User(Base):
    __tablename__ = "users"
    id = Column(Integer, primary_key=True, index=True)
    email = Column(String, unique=True, index=True, nullable=False)
    password_hash = Column(String, nullable=False)
    full_name = Column(String)
    city = Column(String)
    age = Column(Integer)
    gender = Column(String)
    is_verified = Column(Boolean, default=False)
    verification_code = Column(String, nullable=True)
