from sqlalchemy import (
    Column,
    Integer,
    String,
    Boolean,
    Enum,
    Text,
    TIMESTAMP
)

from sqlalchemy.sql import func

from app.database import Base


class User(Base):
    __tablename__ = "users"

    id = Column(Integer, primary_key=True)

    name = Column(String(100))

    email = Column(String(100), unique=True)

    password_hash = Column(String(255))

    phone = Column(String(30))

    bio = Column(Text)

    role = Column(
        Enum("admin", "user"),
        default="user"
    )

    is_active = Column(
        Boolean,
        default=True
    )

    created_at = Column(
        TIMESTAMP,
        server_default=func.now()
    )