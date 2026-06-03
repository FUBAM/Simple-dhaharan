from fastapi import APIRouter, Depends

from sqlalchemy.orm import Session

from app.database import get_db

from app.dependencies import get_current_user

from app.models.user import User

from app.schemas.user import UpdateProfileRequest

from fastapi import (
    APIRouter,
    Depends,
    HTTPException
)

from app.schemas.user import (
    UpdateAccountRequest
)

from app.utils.security import (
    verify_password,
    hash_password
)

router = APIRouter(
    prefix="/users",
    tags=["Users"]
)

@router.put("/profile")
def update_profile(
    request: UpdateProfileRequest,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):

    current_user.name = request.name
    current_user.bio = request.bio
    current_user.phone = request.phone

    db.commit()

    return {
        "message": "Profile updated"
    }

@router.get("/profile")
def my_profile(
    current_user: User = Depends(get_current_user)
):

    return {
        "id": current_user.id,
        "name": current_user.name,
        "email": current_user.email,
        "role": current_user.role,
        "bio": current_user.bio,
        "phone": current_user.phone
    }

@router.put("/account")
def update_account(
    request: UpdateAccountRequest,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):

    valid_password = verify_password(
        request.current_password,
        current_user.password_hash
    )

    if not valid_password:
        raise HTTPException(
            status_code=400,
            detail="Current password is incorrect"
        )

    existing_user = db.query(User).filter(
        User.email == request.email,
        User.id != current_user.id
    ).first()

    if existing_user:
        raise HTTPException(
            status_code=400,
            detail="Email already exists"
        )

    current_user.email = request.email
    current_user.phone = request.phone

    if (
        request.new_password
        and request.new_password.strip() != ""
    ):
        current_user.password_hash = hash_password(
            request.new_password
        )

    db.commit()

    return {
        "message": "Account updated"
    }