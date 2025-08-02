from fastapi import APIRouter, Depends, HTTPException, status, Form
from fastapi.security import OAuth2PasswordBearer
from jose import JWTError, jwt
from sqlalchemy.orm import Session
from core.database import SessionLocal
from models.user import User
from schemas.user import UserCreate, UserLogin
from services.auth import hash_password, verify_password
from services.jwt import create_access_token
import random
from core.config import SECRET_KEY, ALGORITHM
from utils.normalization import normalize_gender

router = APIRouter(prefix="/auth", tags=["auth"])

oauth2_scheme = OAuth2PasswordBearer(tokenUrl="/auth/login")

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

def get_current_user(
    token: str = Depends(oauth2_scheme),
    db: Session = Depends(get_db)
):
    credentials_exception = HTTPException(
        status_code=status.HTTP_401_UNAUTHORIZED,
        detail="Could not validate credentials",
        headers={"WWW-Authenticate": "Bearer"},
    )

    try:
        payload = jwt.decode(token, SECRET_KEY, algorithms=[ALGORITHM])
        sub = payload.get("sub")
        if sub is None:
            raise credentials_exception

        
        user_id = int(sub)

    except (JWTError, ValueError):
        raise credentials_exception

    user = db.query(User).filter(User.id == user_id).first()
    if not user:
        raise credentials_exception

    return user


@router.post("/signup")
def signup(user: UserCreate, db: Session = Depends(get_db)):

    if db.query(User).filter(User.email == user.email).first():
        raise HTTPException(status_code=400, detail="Email already registered")
    normalized_gender = normalize_gender(user.gender)
    db_user = User(
        email=user.email,
        password_hash=hash_password(user.password),
        full_name=user.full_name,
        city=user.city,
        age=user.age,
        gender=normalized_gender,
    )
    db.add(db_user)
    db.commit()
    return {"message": "Kayıt başarılı."}


from fastapi.security import OAuth2PasswordRequestForm

@router.post("/login")
def login(form_data: OAuth2PasswordRequestForm = Depends(), db: Session = Depends(get_db)):

    db_user = db.query(User).filter(User.email == form_data.username).first()
    if not db_user or not verify_password(form_data.password, db_user.password_hash):
        raise HTTPException(status_code=400, detail="Geçersiz email veya şifre")

    access_token = create_access_token(data={"sub": str(db_user.id)})    
    return {"access_token": access_token, "token_type": "bearer"}
