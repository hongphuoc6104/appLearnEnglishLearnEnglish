import logging
import tempfile
import os

logger = logging.getLogger(__name__)

_model = None


def get_model(model_name: str = "base"):
    """Lazy-load Whisper model."""
    global _model
    if _model is None:
        try:
            import whisper
            logger.info(f"Loading Whisper model: {model_name}")
            _model = whisper.load_model(model_name)
            logger.info("Whisper model loaded successfully")
        except Exception as e:
            logger.error(f"Failed to load Whisper model: {e}")
            raise
    return _model


def transcribe_audio(audio_bytes: bytes, model_name: str = "base") -> str:
    """Transcribe audio bytes to text using Whisper."""
    model = get_model(model_name)

    with tempfile.NamedTemporaryFile(suffix=".wav", delete=False) as tmp:
        tmp.write(audio_bytes)
        tmp_path = tmp.name

    try:
        result = model.transcribe(tmp_path, language="en")
        return result["text"].strip()
    finally:
        os.unlink(tmp_path)
