from pydantic import BaseModel, Field
from typing import List


class WritingCorrectionRequest(BaseModel):
    text: str = Field(..., min_length=1)
    context: str = ""


class Correction(BaseModel):
    original: str
    corrected: str
    explanation: str


class WritingCorrectionResponse(BaseModel):
    original_text: str
    corrected_text: str
    corrections: List[Correction]
    overall_score: float
    feedback: str
