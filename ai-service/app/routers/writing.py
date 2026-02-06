import logging
from fastapi import APIRouter, HTTPException

from app.schemas.writing import WritingCorrectionRequest, WritingCorrectionResponse
from app.services.gemini_service import correct_writing

logger = logging.getLogger(__name__)
router = APIRouter()


@router.post("/correct-writing", response_model=WritingCorrectionResponse)
async def correct_writing_endpoint(request: WritingCorrectionRequest):
    """Correct English writing using Gemini AI."""
    if len(request.text.strip()) < 3:
        raise HTTPException(status_code=400, detail="Text must be at least 3 characters")

    try:
        result = correct_writing(request.text, request.context)
        return WritingCorrectionResponse(**result)
    except ValueError as e:
        raise HTTPException(status_code=503, detail=str(e))
    except Exception as e:
        logger.error(f"Writing correction error: {e}")
        raise HTTPException(status_code=500, detail="Writing correction failed")
