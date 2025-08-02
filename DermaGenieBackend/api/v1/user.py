from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from core.database import SessionLocal
from models.user import User
from schemas.user import UserOut, UserUpdate, UserUpdateFull
from api.v1.auth import get_current_user

router = APIRouter(prefix="/users", tags=["Users"])

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()



@router.get("/me", response_model=UserOut)
def get_my_info(
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    return current_user



@router.put("/me", response_model=UserOut)
def update_my_info_full(
    user_update: UserUpdateFull,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    current_user.full_name = user_update.full_name
    current_user.city = user_update.city
    current_user.age = user_update.age
    current_user.gender = user_update.gender
    db.commit()
    db.refresh(current_user)
    return current_user



@router.patch("/me", response_model=UserOut)
def update_my_info_partial(
    user_update: UserUpdate,
    db: Session = Depends(get_db),
    current_user=Depends(get_current_user)
):
    user = db.query(User).filter(User.id == current_user.id).first()
    updated = False
    for field, value in user_update.dict(exclude_unset=True).items():
        setattr(user, field, value)
        updated = True

    if not updated:
        raise HTTPException(status_code=400, detail="No fields to update")

    db.commit()
    db.refresh(user)
    return user
