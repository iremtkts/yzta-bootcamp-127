from pydantic import BaseModel

class ImageBase(BaseModel):
    url: str

class ImageCreate(BaseModel):
    pass  # Dosya upload ile alınacak

class ImageOut(ImageBase):
    id: int
    class Config:
        from_attributes = True
