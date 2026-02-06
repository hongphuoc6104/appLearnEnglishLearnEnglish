import json
import logging
import re
from typing import Optional

from google import genai
from google.genai import types

from app.config import settings
from app.utils.prompts import WRITING_CORRECTION_PROMPT, QUIZ_GENERATION_PROMPT

logger = logging.getLogger(__name__)

_client = None


def get_client():
    """Lazy-load Gemini client."""
    global _client
    if _client is None:
        if not settings.GEMINI_API_KEY:
            raise ValueError("GEMINI_API_KEY is not set")
        _client = genai.Client(api_key=settings.GEMINI_API_KEY)
    return _client


def _extract_json(text: str) -> dict:
    """Extract JSON from text that may contain markdown code blocks."""
    # Try to find JSON in code blocks first
    json_match = re.search(r'```(?:json)?\s*\n?(.*?)\n?```', text, re.DOTALL)
    if json_match:
        text = json_match.group(1)

    # Clean up common issues
    text = text.strip()

    return json.loads(text)


def correct_writing(text: str, context: str = "") -> dict:
    """Use Gemini to correct English writing."""
    client = get_client()

    context_line = f'Context: "{context}"' if context else ""
    prompt = WRITING_CORRECTION_PROMPT.format(text=text, context_line=context_line)

    response = client.models.generate_content(
        model=settings.GEMINI_MODEL,
        contents=prompt,
    )

    try:
        result = _extract_json(response.text)
        return {
            "original_text": text,
            "corrected_text": result.get("corrected_text", text),
            "corrections": result.get("corrections", []),
            "overall_score": float(result.get("overall_score", 0)),
            "feedback": result.get("feedback", ""),
        }
    except (json.JSONDecodeError, KeyError) as e:
        logger.error(f"Failed to parse Gemini response: {e}\nResponse: {response.text}")
        return {
            "original_text": text,
            "corrected_text": text,
            "corrections": [],
            "overall_score": 0,
            "feedback": "Unable to analyze text at this time.",
        }


def generate_quiz(topic: str, quiz_type: str = "mcq", count: int = 5, difficulty: str = "intermediate") -> dict:
    """Use Gemini to generate quiz questions."""
    client = get_client()

    prompt = QUIZ_GENERATION_PROMPT.format(
        count=count,
        type=quiz_type,
        topic=topic,
        difficulty=difficulty,
    )

    response = client.models.generate_content(
        model=settings.GEMINI_MODEL,
        contents=prompt,
    )

    try:
        result = _extract_json(response.text)
        return {
            "topic": topic,
            "difficulty": difficulty,
            "questions": result.get("questions", []),
        }
    except (json.JSONDecodeError, KeyError) as e:
        logger.error(f"Failed to parse Gemini response: {e}\nResponse: {response.text}")
        return {
            "topic": topic,
            "difficulty": difficulty,
            "questions": [],
        }
