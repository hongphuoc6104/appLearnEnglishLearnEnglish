import os
from dotenv import load_dotenv

load_dotenv()


class Settings:
    AI_PROVIDER: str = os.getenv("AI_PROVIDER", "GEMINI").upper()
    GEMINI_API_KEY: str = os.getenv("GEMINI_API_KEY", "")
    GEMINI_MODEL: str = os.getenv("GEMINI_MODEL", "gemini-2.5-flash")
    LOCAL_MODEL_NAME: str = os.getenv("LOCAL_MODEL_NAME", "5CD-AI/Vintern-1B-v3_5")


settings = Settings()
