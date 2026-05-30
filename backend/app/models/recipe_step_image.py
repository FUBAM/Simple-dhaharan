from sqlalchemy import (
    Column,
    Integer,
    String,
    ForeignKey
)

from app.database import Base


class RecipeStepImage(Base):
    __tablename__ = "recipe_step_images"

    id = Column(Integer, primary_key=True)

    step_id = Column(Integer)

    image_url = Column(String(255))

    sort_order = Column(Integer)