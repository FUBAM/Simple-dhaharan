from fastapi import (
    APIRouter,
    Depends,
    HTTPException
)

from sqlalchemy.orm import Session

from app.database import get_db

from app.models.category import Category

from app.dependencies import (
    get_current_user,
    admin_only
)

from app.models.recipe import Recipe
from app.schemas.category import CategoryCreate
from app.models.user import User


router = APIRouter(
    prefix="/categories",
    tags=["Categories"]
)

@router.get("/")
def get_categories(
    db: Session = Depends(get_db)
):

    categories = db.query(Category).all()

    result = []

    for category in categories:

        result.append({
            "id": category.id,
            "name": category.name
        })

    return result

@router.post("/categories")
def create_category(
    request: CategoryCreate,
    db: Session = Depends(get_db),
    current_user: User = Depends(admin_only)
):

    category = Category(
        name=request.name
    )

    db.add(category)
    db.commit()

    return {
        "message": "Category created"
    }

@router.put("/categories/{category_id}")
def update_category(
    category_id: int,
    request: CategoryCreate,
    db: Session = Depends(get_db),
    current_user: User = Depends(admin_only)
):

    category = db.query(Category).filter(
        Category.id == category_id
    ).first()

    if not category:
        raise HTTPException(
            status_code=404,
            detail="Category not found"
        )

    category.name = request.name

    db.commit()

    return {
        "message": "Category updated"
    }

@router.delete("/categories/{category_id}")
def delete_category(
    category_id: int,
    db: Session = Depends(get_db),
    current_user: User = Depends(admin_only)
):

    category = db.query(Category).filter(
        Category.id == category_id
    ).first()

    if not category:
        raise HTTPException(
            status_code=404,
            detail="Category not found"
        )
    
    recipe = db.query(Recipe).filter(
    Recipe.category_id == category.id
    ).first()

    if recipe:
        raise HTTPException(
            status_code=400,
            detail="Category still used by recipes"
        )

    db.delete(category)
    db.commit()

    return {
        "message": "Category deleted"
    }