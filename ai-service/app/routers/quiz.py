import logging
from fastapi import APIRouter, HTTPException

from app.schemas.quiz import QuizGenerationRequest, QuizGenerationResponse
from app.services.gemini_service import generate_quiz

logger = logging.getLogger(__name__)
router = APIRouter()


@router.post("/generate-quiz", response_model=QuizGenerationResponse)
async def generate_quiz_endpoint(request: QuizGenerationRequest):
    """Generate English quiz questions using Gemini AI."""
    if len(request.topic.strip()) < 2:
        raise HTTPException(status_code=400, detail="Topic must be at least 2 characters")

    try:
        result = generate_quiz(
            topic=request.topic,
            quiz_type=request.type,
            count=request.count,
            difficulty=request.difficulty,
        )
        return QuizGenerationResponse(**result)
    except ValueError as e:
        raise HTTPException(status_code=503, detail=str(e))
    except Exception as e:
        logger.error(f"Quiz generation error: {e}")
        raise HTTPException(status_code=500, detail="Quiz generation failed")
