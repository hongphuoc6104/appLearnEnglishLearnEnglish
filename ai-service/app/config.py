import os
from dotenv import load_dotenv

load_dotenv()


class Settings:
    GEMINI_API_KEY: str = os.getenv("GEMINI_API_KEY", "")
    GEMINI_MODEL: str = os.getenv("GEMINI_MODEL", "gemini-2.5-flash")
    WHISPER_MODEL: str = os.getenv("WHISPER_MODEL", "base")
    AI_SERVICE_PORT: int = int(os.getenv("AI_SERVICE_PORT", "8000"))


settings = Settings()
