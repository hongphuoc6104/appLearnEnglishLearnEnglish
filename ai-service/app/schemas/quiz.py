from pydantic import BaseModel, Field
from typing import List


class QuizGenerationRequest(BaseModel):
    topic: str = Field(..., min_length=1)
    type: str = "mcq"
    count: int = Field(default=5, ge=1, le=20)
    difficulty: str = "intermediate"


class QuizQuestion(BaseModel):
    question: str
    options: List[str]
    correct_answer: str
    explanation: str


class QuizGenerationResponse(BaseModel):
    topic: str
    difficulty: str
    questions: List[QuizQuestion]
