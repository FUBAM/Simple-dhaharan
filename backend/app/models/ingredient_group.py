from sqlalchemy import (
    Column,
    Integer,
    String,
    ForeignKey
)

from app.database import Base


class IngredientGroup(Base):
    __tablename__ = "ingredient_groups"

    id = Column(Integer, primary_key=True)

    recipe_id = Column(Integer)

    name = Column(String(255))

    sort_order = Column(Integer)