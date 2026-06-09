from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session

from app.dependencies import get_current_user
from app.database import get_db
from app.models.user import User

from app.dependencies import (
    get_current_user,
    admin_only
)

from app.schemas.auth import (
    RegisterRequest,
    LoginRequest
)

from app.utils.security import (
    hash_password,
    verify_password
)

from app.utils.jwt import create_access_token

router = APIRouter(
    prefix="/auth",
    tags=["Auth"]
)

@router.post("/register")
def register(
    request: RegisterRequest,
    db: Session = Depends(get_db)
):

    existing_user = db.query(User).filter(
        User.email == request.email
    ).first()

    if existing_user:
        raise HTTPException(
            status_code=400,
            detail="Email already registered"
        )

    new_user = User(
        name=request.name,
        email=request.email,
        password_hash=hash_password(
            request.password
        )
    )

    db.add(new_user)
    db.commit()
    db.refresh(new_user)

    return {
        "message": "Register success"
    }

@router.post("/login")
def login(
    request: LoginRequest,
    db: Session = Depends(get_db)
):

    user = db.query(User).filter(
        User.email == request.email
    ).first()

    if not user:
        raise HTTPException(
            status_code=401,
            detail="Invalid credentials"
        )
    
    if not user.is_active:
        raise HTTPException(
            status_code=403,
            detail="Account deactivated"
        )


    valid_password = verify_password(
        request.password,
        user.password_hash
    )

    if not valid_password:
        raise HTTPException(
            status_code=401,
            detail="Invalid credentials"
        )

    token = create_access_token({
        "user_id": user.id,
        "role": user.role
    })

    return {
        "access_token": token,
        "token_type": "bearer",
        "user": {
            "id": user.id,
            "name": user.name,
            "email": user.email,
            "role": user.role,

            "bio": user.bio,
            "phone": user.phone
        }
    }

@router.get("/me")
def me(
    current_user: User = Depends(get_current_user)
):

    return {
        "id": current_user.id,
        "name": current_user.name,
        "email": current_user.email,
        "role": current_user.role
    }

@router.get("/admin/users")
def admin_users(
    db: Session = Depends(get_db),
    current_user: User = Depends(admin_only)
):

    users = db.query(User).all()

    return [
        {
            "id": user.id,
            "name": user.name,
            "email": user.email,
            "role": user.role,
            "is_active": user.is_active
        }
        for user in users
    ]

from app.models.recipe import Recipe
@router.get("/admin/users/{user_id}")
def admin_user_detail(
    user_id: int,
    db: Session = Depends(get_db),
    current_user: User = Depends(admin_only)
):

    user = db.query(User).filter(
        User.id == user_id
    ).first()

    if not user:
        raise HTTPException(
            status_code=404,
            detail="User not found"
        )

    recipes = db.query(Recipe).filter(
        Recipe.user_id == user.id
    ).all()

    return {
        "id": user.id,
        "name": user.name,
        "email": user.email,
        "role": user.role,
        "is_active": user.is_active,

        "recipes": [
            {
                "id": recipe.id,
                "title": recipe.title,
                "status": recipe.status
            }
            for recipe in recipes
        ]
    }

@router.put("/admin/users/{user_id}/deactivate")
def deactivate_user(
    user_id: int,
    db: Session = Depends(get_db),
    current_user: User = Depends(admin_only)
):

    user = db.query(User).filter(
        User.id == user_id
    ).first()

    if user.id == current_user.id:
        raise HTTPException(
            status_code=400,
            detail="Cannot deactivate yourself"
        )

    if not user:
        raise HTTPException(
            status_code=404,
            detail="User not found"
        )

    user.is_active = False

    db.commit()

    return {
        "message": "User deactivated"
    }