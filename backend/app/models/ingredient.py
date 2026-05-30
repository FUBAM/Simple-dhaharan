from sqlalchemy import (
    Column,
    Integer,
    String,
    ForeignKey
)

from app.database import Base


class Ingredient(Base):
    __tablename__ = "ingredients"

    id = Column(Integer, primary_key=True)

    group_id = Column(Integer)

    name = Column(String(255))

    quantity = Column(String(50))

    unit = Column(String(50))

    sort_order = Column(Integer)