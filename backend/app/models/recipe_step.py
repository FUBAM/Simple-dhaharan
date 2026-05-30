from sqlalchemy import (
    Column,
    Integer,
    Text,
    ForeignKey
)

from app.database import Base


class RecipeStep(Base):
    __tablename__ = "recipe_steps"

    id = Column(Integer, primary_key=True)

    recipe_id = Column(Integer)

    step_number = Column(Integer)

    instruction = Column(Text)