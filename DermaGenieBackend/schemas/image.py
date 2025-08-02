from pydantic import BaseModel
from typing import Optional, List
from datetime import datetime

class ImageBase(BaseModel):
    url: str
    is_annotated: bool
    detected_classes: Optional[List[str]] = None
    genai_response: Optional[str] = None
    analysis_id: Optional[str] = None
    created_at: Optional[datetime] = None


class ImageCreate(BaseModel):
    pass  


class ImageOut(ImageBase):
    id: int

    class Config:
        from_attributes = True
