from pydantic import BaseModel, EmailStr
from typing import Optional


class UserCreate(BaseModel):
    email: EmailStr
    password: str
    full_name: str
    city: str
    age: int
    gender: str

class UserLogin(BaseModel):
    email: EmailStr
    password: str


class UserOut(BaseModel):
    id: int
    email: EmailStr
    full_name: Optional[str]
    city: Optional[str]
    age: Optional[int]
    gender: Optional[str]

    class Config:
        from_attributes = True


class UserUpdate(BaseModel):
    full_name: Optional[str]
    city: Optional[str]
    age: Optional[int]
    gender: Optional[str]

class UserUpdateFull(BaseModel):
    full_name: str
    city: str
    age: int
    gender: str
