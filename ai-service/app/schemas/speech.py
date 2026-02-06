from pydantic import BaseModel
from typing import List, Optional


class WrongWord(BaseModel):
    index: int
    expected: str
    actual: str


class SpeechAnalysisResponse(BaseModel):
    score: float
    transcript: str
    target_text: str
    wrong_words: List[WrongWord]
    word_count: int
    correct_count: int
