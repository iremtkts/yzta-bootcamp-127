from pydantic import BaseModel

class UserCreate(BaseModel):
    username: str
    password: str
    full_name: str
    city: str
    age: int
    gender: str

class UserLogin(BaseModel):
    username: str
    password: str
