from fastapi import FastAPI

from app.routers.auth import router as auth_router
from app.routers.recipe import router as recipe_router
from app.routers.category import router as category_router
from fastapi.staticfiles import StaticFiles
from app.routers.upload import (
    router as upload_router
)

from app.dependencies import admin_only
from app.models.user import User

from fastapi import Depends

app = FastAPI()

app.mount(
    "/uploads",
    StaticFiles(directory="uploads"),
    name="uploads"
)
app.include_router(auth_router)
app.include_router(recipe_router)
app.include_router(upload_router)
app.include_router(category_router)

@app.get("/")
def root():
    return {
        "message": "Dhaharan API Running"
    }

@app.get("/admin-test")
def admin_test(
    current_user: User = Depends(admin_only)
):
    return {
        "message": "Welcome admin"
    }