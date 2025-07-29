from fastapi import FastAPI
from core.database import Base, engine
from api.v1.auth import router as auth_router
from api.v1 import image

Base.metadata.create_all(bind=engine)

app = FastAPI()
app.include_router(auth_router)
app.include_router(image.router, prefix="/images", tags=["images"])
