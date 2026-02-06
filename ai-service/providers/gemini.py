import io
import logging
from typing import Optional

from PIL import Image
from google import genai
from google.genai import types

from config import settings
from providers.base import AIProvider

logger = logging.getLogger(__name__)


class GeminiProvider(AIProvider):
    def __init__(self):
        if not settings.GEMINI_API_KEY:
            raise ValueError(
                "GEMINI_API_KEY is not set. "
                "Please set it in your .env file or environment variables."
            )
        self.client = genai.Client(api_key=settings.GEMINI_API_KEY)
        self.model = settings.GEMINI_MODEL
        logger.info("GeminiProvider initialized with model: %s", self.model)

    def generate(self, prompt: str, image: Optional[Image.Image] = None) -> str:
        contents = []

        if image is not None:
            buf = io.BytesIO()
            image.save(buf, format="PNG")
            image_bytes = buf.getvalue()
            contents.append(
                types.Part.from_bytes(data=image_bytes, mime_type="image/png")
            )

        contents.append(prompt)

        response = self.client.models.generate_content(
            model=self.model,
            contents=contents,
        )
        return response.text
