from sqlalchemy import (
    Column,
    Integer,
    String,
    Text,
    Boolean,
    ForeignKey,
    Enum,
    TIMESTAMP
)

from sqlalchemy.sql import func

from app.database import Base


class Recipe(Base):
    __tablename__ = "recipes"

    id = Column(Integer, primary_key=True)

    user_id = Column(Integer)

    category_id = Column(Integer, nullable=True)

    title = Column(String(255))

    description = Column(Text)

    cook_time = Column(Integer)

    servings = Column(Integer)

    estimated_cost = Column(Integer)

    contains_pork = Column(Boolean)

    contains_alcohol = Column(Boolean)

    cover_image = Column(String(255))

    status = Column(
        Enum(
            "private",
            "pending",
            "public",
            "rejected"
        )
    )

    created_at = Column(
        TIMESTAMP,
        server_default=func.now()
    )

    updated_at = Column(
        TIMESTAMP,
        server_default=func.now(),
        onupdate=func.now()
    )