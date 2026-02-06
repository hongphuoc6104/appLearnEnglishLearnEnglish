import logging
from fastapi import APIRouter, File, Form, UploadFile, HTTPException

from app.config import settings
from app.services.text_comparison import compare_texts
from app.schemas.speech import SpeechAnalysisResponse

logger = logging.getLogger(__name__)
router = APIRouter()


@router.post("/analyze-speech", response_model=SpeechAnalysisResponse)
async def analyze_speech(
    audio: UploadFile = File(...),
    target_text: str = Form(...),
):
    """Analyze speech by transcribing audio and comparing with target text."""
    if not target_text.strip():
        raise HTTPException(status_code=400, detail="Target text is required")

    try:
        audio_bytes = await audio.read()

        # Try to use Whisper for transcription
        try:
            from app.services.whisper_service import transcribe_audio
            transcript = transcribe_audio(audio_bytes, settings.WHISPER_MODEL)
        except Exception as e:
            logger.warning(f"Whisper transcription failed: {e}. Using placeholder.")
            transcript = ""

        result = compare_texts(transcript, target_text)
        return SpeechAnalysisResponse(**result)

    except Exception as e:
        logger.error(f"Speech analysis error: {e}")
        raise HTTPException(status_code=500, detail=str(e))
