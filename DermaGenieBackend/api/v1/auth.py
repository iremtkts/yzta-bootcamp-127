from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from core.database import SessionLocal
from models.user import User
from schemas.user import UserCreate, UserVerify, UserLogin
from services.auth import hash_password, verify_password
from services.jwt import create_access_token
import random

router = APIRouter(prefix="/auth", tags=["auth"])

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

@router.post("/signup")
def signup(user: UserCreate, db: Session = Depends(get_db)):
    if db.query(User).filter(User.email == user.email).first():
        raise HTTPException(status_code=400, detail="Email already registered")
    verification_code = str(random.randint(100000, 999999))
    db_user = User(
        email=user.email,
        password_hash=hash_password(user.password),
        full_name=user.full_name,
        city=user.city,
        age=user.age,
        gender=user.gender,
        is_verified=False,
        verification_code=verification_code
    )
    db.add(db_user)
    db.commit()
    print(f"Verification code for {user.email}: {verification_code}")
    return {"message": "Kayıt başarılı. Lütfen e-postanızı kontrol ederek hesabınızı doğrulayın."}

@router.post("/verify")
def verify(user: UserVerify, db: Session = Depends(get_db)):
    db_user = db.query(User).filter(User.email == user.email).first()
    if not db_user or db_user.verification_code != user.code:
        raise HTTPException(status_code=400, detail="Kod yanlış veya kullanıcı bulunamadı")
    db_user.is_verified = True
    db_user.verification_code = None
    db.commit()
    return {"message": "Hesabınız başarıyla doğrulandı."}

@router.post("/login")
def login(user: UserLogin, db: Session = Depends(get_db)):
    db_user = db.query(User).filter(User.email == user.email).first()
    if not db_user or not verify_password(user.password, db_user.password_hash):
        raise HTTPException(status_code=400, detail="Geçersiz e-posta veya şifre")
    if not db_user.is_verified:
        raise HTTPException(status_code=400, detail="Hesabınız doğrulanmamış")
    access_token = create_access_token(data={"sub": db_user.email})
    return {"access_token": access_token, "token_type": "bearer"}
