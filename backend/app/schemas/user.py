from pydantic import BaseModel
from pydantic import BaseModel
from typing import Optional


class UpdateProfileRequest(BaseModel):
    name: str
    bio: str | None = None
    phone: str | None = None


class UpdateAccountRequest(BaseModel):
    email: str
    phone: Optional[str] = None

    current_password: str
    new_password: Optional[str] = None