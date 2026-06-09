from urllib import request

from fastapi import (
    APIRouter,
    Depends,
    HTTPException
)

from typing import Optional
from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from sqlalchemy import desc

from sqlalchemy import func
from sqlalchemy.orm import Session

from app.database import get_db

from app.dependencies import get_current_user

from app.models import recipe
from app.models.user import User
from app.models.recipe import Recipe
from app.models.ingredient_group import IngredientGroup
from app.models.ingredient import Ingredient
from app.models.recipe_step import RecipeStep
from app.models.recipe_step_image import RecipeStepImage
from sqlalchemy import delete
import os

from app.routers import users
from app.schemas.recipe import RecipeCreate

from app.dependencies import (
    get_current_user,
    admin_only
)

router = APIRouter(
    prefix="/recipes",
    tags=["Recipes"]
)

@router.post("/")
def create_recipe(
    request: RecipeCreate,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):

    recipe = Recipe(
        user_id=current_user.id,
        category_id=request.category_id,

        title=request.title,
        description=request.description,

        cook_time=request.cook_time,
        servings=request.servings,
        estimated_cost=request.estimated_cost,

        contains_pork=request.contains_pork,
        contains_alcohol=request.contains_alcohol,

        cover_image=request.cover_image,

        status=request.status
    )

    db.add(recipe)
    db.commit()
    db.refresh(recipe)

    for group_data in request.ingredient_groups:

        group = IngredientGroup(
            recipe_id=recipe.id,
            name=group_data.name,
            sort_order=group_data.sort_order
        )

        db.add(group)
        db.commit()
        db.refresh(group)

        for ingredient_data in group_data.ingredients:

            ingredient = Ingredient(
                group_id=group.id,

                name=ingredient_data.name,
                quantity=ingredient_data.quantity,
                unit=ingredient_data.unit,

                sort_order=ingredient_data.sort_order
            )

            db.add(ingredient)

    for step_data in request.steps:

        step = RecipeStep(
            recipe_id=recipe.id,

            step_number=step_data.step_number,
            instruction=step_data.instruction
        )

        db.add(step)
        db.commit()
        db.refresh(step)

        for image_data in step_data.images:

            image = RecipeStepImage(
                step_id=step.id,
                image_url=image_data.image_url,
                sort_order=image_data.sort_order
            )

            db.add(image)

    db.commit()

    return {
        "message": "Recipe created",
        "recipe_id": recipe.id
    }

@router.get("/my-recipes")
def my_recipes(
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):

    recipes = db.query(Recipe).filter(
        Recipe.user_id == current_user.id
    ).all()

    result = []

    for recipe in recipes:

        result.append({
            "id": recipe.id,
            "title": recipe.title,
            "status": recipe.status,
            "cook_time": recipe.cook_time,
            "servings": recipe.servings,
            "cover_image": recipe.cover_image
        })

    return result

@router.get("/my-recipes/{recipe_id}")
def my_recipe_detail(
    recipe_id: int,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):

    recipe = db.query(Recipe).filter(
        Recipe.id == recipe_id,
        Recipe.user_id == current_user.id
    ).first()

    if not recipe:
        raise HTTPException(
            status_code=404,
            detail="Recipe not found"
        )
    
    groups = db.query(
        IngredientGroup
    ).filter(
        IngredientGroup.recipe_id == recipe.id
    ).order_by(
        IngredientGroup.sort_order
    ).all()

    ingredient_groups = []

    for group in groups:

        ingredients = db.query(
            Ingredient
        ).filter(
            Ingredient.group_id == group.id
        ).order_by(
            Ingredient.sort_order
        ).all()

        ingredient_groups.append({
            "id": group.id,
            "name": group.name,
            "ingredients": [
                {
                    "id": ingredient.id,
                    "name": ingredient.name,
                    "quantity": ingredient.quantity,
                    "unit": ingredient.unit
                }
                for ingredient in ingredients
            ]
        })

    steps_db = db.query(RecipeStep).filter(
        RecipeStep.recipe_id == recipe.id
    ).all()

    steps = []

    for step in steps_db:

        images = db.query(
            RecipeStepImage
        ).filter(
            RecipeStepImage.step_id == step.id
        ).order_by(
            RecipeStepImage.sort_order
        ).all()

        steps.append({
            "id": step.id,
            "step_number": step.step_number,
            "instruction": step.instruction,
            "images": [
                {
                    "id": image.id,
                    "image_url": image.image_url
                }
                for image in images
            ]
        })

    return {
        "id": recipe.id,
        "user_id": recipe.user_id,
        "category_id":
            recipe.category_id,
        "title": recipe.title,
        "description":
            recipe.description,
        "cook_time":
            recipe.cook_time,
        "servings":
            recipe.servings,
        "estimated_cost":
            recipe.estimated_cost,
        "contains_pork":
            recipe.contains_pork,
        "contains_alcohol":
            recipe.contains_alcohol,
        "cover_image":
            recipe.cover_image,
        "status":
            recipe.status,
        "ingredient_groups":
            ingredient_groups,
        "steps":
            steps
    }

@router.get("/")
def get_recipes(
    q: Optional[str] = None,
    max_time: Optional[int] = None,
    servings: Optional[int] = None,
    sort: Optional[str] = "desc",
    db: Session = Depends(get_db)
):

    query = db.query(Recipe).filter(Recipe.status == 'public')

    # Filter berdasarkan keyword
    if q:
        query = query.filter(Recipe.title.ilike(f"%{q}%"))
    
    # Filter berdasarkan waktu maksimal
    if max_time:
        query = query.filter(Recipe.cook_time <= max_time)
        
    # Filter berdasarkan porsi
    if servings:
        query = query.filter(Recipe.servings == servings)
        
    # Sorting
    if sort == "asc":
        query = query.order_by(Recipe.created_at.asc())
    else:
        query = query.order_by(Recipe.created_at.desc())

    return query.all()

    recipes = db.query(Recipe).filter(
        Recipe.status == "public"
    ).all()

    result = []

    for recipe in recipes:

        result.append({
            "id": recipe.id,
            "title": recipe.title,
            "description": recipe.description,
            "cover_image": recipe.cover_image,
            "cook_time": recipe.cook_time,
            "servings": recipe.servings
        })

    return result

@router.get("/{recipe_id}")
def recipe_detail(
    recipe_id: int,
    db: Session = Depends(get_db)
):

    recipe = db.query(Recipe).filter(
        Recipe.id == recipe_id
    ).first()

    if not recipe:
        raise HTTPException(
            status_code=404,
            detail="Recipe not found"
        )
    
    if recipe.status != "public":
        raise HTTPException(
            status_code=403,
            detail="Recipe is private"
        )

    groups = db.query(IngredientGroup).filter(
        IngredientGroup.recipe_id == recipe.id
    ).all()

    ingredient_groups = []

    for group in groups:

        ingredients = db.query(
            Ingredient
        ).filter(
            Ingredient.group_id == group.id
        ).order_by(
            Ingredient.sort_order
        ).all()

        ingredient_groups.append({
            "id": group.id,
            "name": group.name,
            "ingredients": [
                {
                    "id": ingredient.id,
                    "name": ingredient.name,
                    "quantity": ingredient.quantity,
                    "unit": ingredient.unit
                }
                for ingredient in ingredients
            ]
        })

    steps_db = db.query(
        RecipeStep
    ).filter(
        RecipeStep.recipe_id == recipe.id
    ).order_by(
        RecipeStep.step_number
    ).all()

    steps = []

    for step in steps_db:

        images = db.query(
            RecipeStepImage
        ).filter(
            RecipeStepImage.step_id == step.id
        ).order_by(
            RecipeStepImage.sort_order
        ).all()

        steps.append({
            "id": step.id,
            "step_number": step.step_number,
            "instruction": step.instruction,
            "images": [
                {
                    "id": image.id,
                    "image_url": image.image_url
                }
                for image in images
            ]
        })

    return {
        "id": recipe.id,
        "user_id": recipe.user_id,
        "category_id":
            recipe.category_id,
        "title": recipe.title,
        "description":
            recipe.description,
        "cook_time":
            recipe.cook_time,
        "servings":
            recipe.servings,
        "estimated_cost":
            recipe.estimated_cost,
        "contains_pork":
            recipe.contains_pork,
        "contains_alcohol":
            recipe.contains_alcohol,
        "cover_image":
            recipe.cover_image,
        "status":
            recipe.status,
        "ingredient_groups":
            ingredient_groups,
        "steps":
            steps
    }

@router.delete("/{recipe_id}")
def delete_recipe(
    recipe_id: int,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):

    recipe = db.query(Recipe).filter(
        Recipe.id == recipe_id
    ).first()

    if not recipe:
        raise HTTPException(
            status_code=404,
            detail="Recipe not found"
        )

    if recipe.user_id != current_user.id:
        raise HTTPException(
            status_code=403,
            detail="Not allowed"
        )
    
    if recipe.cover_image:

        cover_path = recipe.cover_image.lstrip("/")

        if os.path.exists(cover_path):
            os.remove(cover_path)

    steps = db.query(
        RecipeStep
    ).filter(
        RecipeStep.recipe_id == recipe.id
    ).all()

    for step in steps:

        images = db.query(
            RecipeStepImage
        ).filter(
            RecipeStepImage.step_id == step.id
        ).order_by(
            RecipeStepImage.sort_order
        ).all()

        for image in images:

            if image.image_url:

                image_path = image.image_url.lstrip("/")

                if os.path.exists(image_path):
                    os.remove(image_path)

    db.delete(recipe)
    db.commit()

    return {
        "message": "Recipe deleted"
    }

@router.put("/{recipe_id}")
def update_recipe(
    recipe_id: int,
    request: RecipeCreate,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):

    recipe = db.query(Recipe).filter(
        Recipe.id == recipe_id
    ).first()

    if not recipe:
        raise HTTPException(
            status_code=404,
            detail="Recipe not found"
        )

    if recipe.user_id != current_user.id:
        raise HTTPException(
            status_code=403,
            detail="Not allowed"
        )

    recipe.category_id = request.category_id
    recipe.title = request.title
    recipe.description = request.description

    recipe.cook_time = request.cook_time
    recipe.servings = request.servings
    recipe.estimated_cost = request.estimated_cost

    recipe.contains_pork = request.contains_pork
    recipe.contains_alcohol = request.contains_alcohol

    old_cover = recipe.cover_image
    new_cover = request.cover_image
    if (
        old_cover
        and old_cover != new_cover
    ):
        old_path = old_cover.lstrip("/")

        if os.path.exists(old_path):
            os.remove(old_path)
    recipe.cover_image = request.cover_image
    
    recipe.status = request.status

    db.commit()

    old_steps = db.query(
        RecipeStep
    ).filter(
        RecipeStep.recipe_id == recipe.id
    ).all()

    for step in old_steps:

        old_images = db.query(
            RecipeStepImage
        ).filter(
            RecipeStepImage.step_id == step.id
        ).all()

        for image in old_images:

            if image.image_url:

                image_path = image.image_url.lstrip("/")

                if os.path.exists(image_path):
                    os.remove(image_path)

    for step in old_steps:

        db.query(
            RecipeStepImage
        ).filter(
            RecipeStepImage.step_id == step.id
        ).delete()

    db.query(
        RecipeStep
    ).filter(
        RecipeStep.recipe_id == recipe.id
    ).delete()

    old_groups = db.query(
        IngredientGroup
    ).filter(
        IngredientGroup.recipe_id == recipe.id
    ).all()

    for group in old_groups:

        db.query(
            Ingredient
        ).filter(
            Ingredient.group_id == group.id
        ).delete()

    db.query(
        IngredientGroup
    ).filter(
        IngredientGroup.recipe_id == recipe.id
    ).delete()

    db.commit()

    for group_data in request.ingredient_groups:

        group = IngredientGroup(
            recipe_id=recipe.id,
            name=group_data.name,
            sort_order=group_data.sort_order
        )

        db.add(group)
        db.commit()
        db.refresh(group)

        for ingredient_data in group_data.ingredients:

            ingredient = Ingredient(
                group_id=group.id,
                name=ingredient_data.name,
                quantity=ingredient_data.quantity,
                unit=ingredient_data.unit,
                sort_order=ingredient_data.sort_order
            )

            db.add(ingredient)

    db.commit()


    for step_data in request.steps:

        step = RecipeStep(
            recipe_id=recipe.id,
            step_number=step_data.step_number,
            instruction=step_data.instruction
        )

        db.add(step)
        db.commit()
        db.refresh(step)

        for image_data in step_data.images:

            image = RecipeStepImage(
                step_id=step.id,
                image_url=image_data.image_url,
                sort_order=image_data.sort_order
            )

            db.add(image)

        db.commit()


    return {
        "message": "Recipe updated"
    }

@router.get("/admin/detail/{recipe_id}")
def admin_recipe_detail(
    recipe_id: int,
    db: Session = Depends(get_db),
    current_user: User = Depends(admin_only)
):

    recipe = db.query(Recipe).filter(
        Recipe.id == recipe_id
    ).first()

    if not recipe:
        raise HTTPException(
            status_code=404,
            detail="Recipe not found"
        )

    groups = db.query(
        IngredientGroup
    ).filter(
        IngredientGroup.recipe_id == recipe.id
    ).order_by(
        IngredientGroup.sort_order
    ).all()

    ingredient_groups = []

    for group in groups:

        ingredients = db.query(
            Ingredient
        ).filter(
            Ingredient.group_id == group.id
        ).order_by(
            Ingredient.sort_order
        ).all()

        ingredient_groups.append({
            "id": group.id,
            "name": group.name,
            "ingredients": [
                {
                    "id": ingredient.id,
                    "name": ingredient.name,
                    "quantity": ingredient.quantity,
                    "unit": ingredient.unit
                }
                for ingredient in ingredients
            ]
        })

    steps_db = db.query(
        RecipeStep
    ).filter(
        RecipeStep.recipe_id == recipe.id
    ).order_by(
        RecipeStep.step_number
    ).all()

    steps = []

    for step in steps_db:

        images = db.query(
            RecipeStepImage
        ).filter(
            RecipeStepImage.step_id == step.id
        ).order_by(
            RecipeStepImage.sort_order
        ).all()

        steps.append({
            "id": step.id,
            "step_number": step.step_number,
            "instruction": step.instruction,
            "images": [
                {
                    "id": image.id,
                    "image_url": image.image_url
                }
                for image in images
            ]
        })

    return {
        "id": recipe.id,
        "user_id": recipe.user_id,
        "category_id": recipe.category_id,
        "title": recipe.title,
        "description": recipe.description,
        "cook_time": recipe.cook_time,
        "servings": recipe.servings,
        "estimated_cost": recipe.estimated_cost,
        "contains_pork": recipe.contains_pork,
        "contains_alcohol": recipe.contains_alcohol,
        "cover_image": recipe.cover_image,
        "status": recipe.status,
        "ingredient_groups": ingredient_groups,
        "steps": steps
    }

@router.put("/{recipe_id}/submit")
def submit_recipe(
    recipe_id: int,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):

    recipe = db.query(Recipe).filter(
        Recipe.id == recipe_id
    ).first()

    if not recipe:
        raise HTTPException(
            status_code=404,
            detail="Recipe not found"
        )

    if recipe.user_id != current_user.id:
        raise HTTPException(
            status_code=403,
            detail="Not allowed"
        )

    recipe.status = "pending"

    db.commit()

    return {
        "message": "Recipe submitted"
    }

@router.get("/admin/all")
def admin_all_recipes(
    db: Session = Depends(get_db),
    current_user: User = Depends(admin_only)
):

    recipes = db.query(Recipe).all()

    result = []

    for recipe in recipes:

        result.append({
            "id": recipe.id,
            "title": recipe.title,
            "status": recipe.status,
            "user_id": recipe.user_id,
            "cover_image": recipe.cover_image
        })

    return result

@router.get("/admin/pending")
def admin_pending_recipes(
    db: Session = Depends(get_db),
    current_user: User = Depends(admin_only)
):

    recipes = db.query(Recipe).filter(
        Recipe.status == "pending"
    ).all()

    result = []

    for recipe in recipes:

        result.append({
            "id": recipe.id,
            "title": recipe.title,
            "status": recipe.status,
            "user_id": recipe.user_id
        })

    return result

@router.put("/admin/{recipe_id}/approve")
def approve_recipe(
    recipe_id: int,
    db: Session = Depends(get_db),
    current_user: User = Depends(admin_only)
):

    recipe = db.query(Recipe).filter(
        Recipe.id == recipe_id
    ).first()

    if not recipe:
        raise HTTPException(
            status_code=404,
            detail="Recipe not found"
        )

    recipe.status = "public"

    db.commit()

    return {
        "message": "Recipe approved"
    }

@router.put("/admin/{recipe_id}/reject")
def reject_recipe(
    recipe_id: int,
    db: Session = Depends(get_db),
    current_user: User = Depends(admin_only)
):

    recipe = db.query(Recipe).filter(
        Recipe.id == recipe_id
    ).first()

    if not recipe:
        raise HTTPException(
            status_code=404,
            detail="Recipe not found"
        )

    recipe.status = "rejected"

    db.commit()

    return {
        "message": "Recipe rejected"
    }

@router.get("/admin/statistics")
def admin_statistics(
    db: Session = Depends(get_db),
    current_user: User = Depends(admin_only)
):

    total_users = db.query(
        User
    ).count()

    total_recipes = db.query(
        Recipe
    ).count()

    total_pending = db.query(
        Recipe
    ).filter(
        Recipe.status == "pending"
    ).count()

    total_public = db.query(
        Recipe
    ).filter(
        Recipe.status == "public"
    ).count()

    total_rejected = db.query(
        Recipe
    ).filter(
        Recipe.status == "rejected"
    ).count()

    return {
        "total_users": total_users,
        "total_recipes": total_recipes,
        "total_pending": total_pending,
        "total_public": total_public,
        "total_rejected": total_rejected
    }

@router.get("/admin/rejected")
def rejected_recipes(
    db: Session = Depends(get_db),
    current_user: User = Depends(admin_only)
):

    recipes = db.query(Recipe).filter(
        Recipe.status == "rejected"
    ).all()

    return [
        {
            "id": recipe.id,
            "title": recipe.title,
            "status": recipe.status,
            "user_id": recipe.user_id
        }
        for recipe in recipes
    ]

@router.get("/admin/users")
def admin_users(
    db: Session = Depends(get_db),
    current_user: User = Depends(admin_only)
):
    return [
        {
            "id": user.id,
            "name": user.name,
            "email": user.email,
            "role": user.role
        }
        for user in users
    ]

@router.get("/admin/users/{user_id}")
def admin_user_detail(
    user_id: int,
    db: Session = Depends(get_db),
    current_user: User = Depends(admin_only)
):
    user = db.query(User).filter(User.id == user_id).first()

    if not user:
        raise HTTPException(status_code=404, detail="User tidak ditemukan")

    {
        "id": user.id,
        "name": user.name,
        "email": user.email,

        "recipes": [
            {
                "id": recipe.id,
                "title": recipe.title,
                "status": recipe.status
            }
        ]
    }
    return {
        "id": user.id,
        "name": user.name,
        "email": user.email,
        "recipes": [ ... ]
    }

@router.put("/admin/{recipe_id}/private")
def private_recipe(
    recipe_id: int,
    db: Session = Depends(get_db),
    current_user: User = Depends(admin_only)
):

    recipe = db.query(Recipe).filter(
        Recipe.id == recipe_id
    ).first()

    if not recipe:
        raise HTTPException(
            status_code=404,
            detail="Recipe not found"
        )

    recipe.status = "private"

    db.commit()

    return {
        "message": "Recipe set to private"
    }