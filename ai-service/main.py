import logging

from fastapi import FastAPI
from app.routers import speech, writing, quiz

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

app = FastAPI(title="LearnEnglish AI Service", version="1.0.0")

# Include routers
app.include_router(speech.router)
app.include_router(writing.router)
app.include_router(quiz.router)


@app.get("/health")
def health_check():
    return {"status": "ok", "service": "learn-english-ai"}


if __name__ == "__main__":
    import uvicorn
    uvicorn.run("main:app", host="0.0.0.0", port=8000, reload=True)
