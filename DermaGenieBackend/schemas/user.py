from pydantic import BaseModel, EmailStr

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