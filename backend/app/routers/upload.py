from fastapi import (
    APIRouter,
    UploadFile,
    File
)

import os
import uuid

router = APIRouter(
    prefix="/upload",
    tags=["Upload"]
)

@router.post("/cover")
async def upload_cover(
    file: UploadFile = File(...)
):

    extension = file.filename.split(".")[-1]

    filename = (
        str(uuid.uuid4())
        + "."
        + extension
    )

    filepath = os.path.join(
        "uploads",
        "covers",
        filename
    )

    with open(filepath, "wb") as buffer:
        buffer.write(
            await file.read()
        )

    return {
        "image_url":
        f"/uploads/covers/{filename}"
    }

@router.post("/step")
async def upload_step_image(
    file: UploadFile = File(...)
):

    extension = file.filename.split(".")[-1]

    filename = (
        str(uuid.uuid4())
        + "."
        + extension
    )

    filepath = os.path.join(
        "uploads",
        "steps",
        filename
    )

    with open(filepath, "wb") as buffer:
        buffer.write(
            await file.read()
        )

    return {
        "image_url":
        f"/uploads/steps/{filename}"
    }