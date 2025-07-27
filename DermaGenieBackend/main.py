from fastapi import FastAPI
from core.database import Base, engine
from api.v1.auth import router as auth_router

Base.metadata.create_all(bind=engine)

app = FastAPI()
app.include_router(auth_router)
