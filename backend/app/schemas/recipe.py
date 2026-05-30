from pydantic import BaseModel
from typing import List, Optional


class IngredientCreate(BaseModel):
    name: str
    quantity: Optional[str] = None
    unit: Optional[str] = None
    sort_order: int = 0


class IngredientGroupCreate(BaseModel):
    name: str
    sort_order: int = 0
    ingredients: List[IngredientCreate]


class StepImageCreate(BaseModel):
    image_url: str
    sort_order: int = 0


class RecipeStepCreate(BaseModel):
    step_number: int
    instruction: str
    images: List[StepImageCreate] = []


class RecipeCreate(BaseModel):
    category_id: Optional[int] = None

    title: str
    description: Optional[str] = None

    cook_time: Optional[int] = None
    servings: Optional[int] = None
    estimated_cost: Optional[int] = None

    contains_pork: bool = False
    contains_alcohol: bool = False

    cover_image: Optional[str] = None

    status: str = "private"

    ingredient_groups: List[IngredientGroupCreate]

    steps: List[RecipeStepCreate]