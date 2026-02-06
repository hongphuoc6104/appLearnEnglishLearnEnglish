WRITING_CORRECTION_PROMPT = """You are an expert English language tutor. Analyze the following text written by an English learner and provide corrections.

Input text: "{text}"
{context_line}

You MUST respond with ONLY valid JSON in this exact format (no markdown, no extra text):
{{
  "corrected_text": "the fully corrected version of the text",
  "corrections": [
    {{
      "original": "the incorrect word or phrase",
      "corrected": "the correct version",
      "explanation": "brief explanation of the error"
    }}
  ],
  "overall_score": 85,
  "feedback": "Overall feedback about the writing quality and areas to improve"
}}

Rules:
- Score from 0-100 based on grammar, spelling, and clarity
- If text is perfect, return empty corrections array and score 100
- Keep explanations concise and educational
- Focus on grammar, spelling, punctuation, and word choice errors
"""

QUIZ_GENERATION_PROMPT = """You are an English language quiz creator. Generate {count} {type} questions about the topic: "{topic}" at {difficulty} level.

You MUST respond with ONLY valid JSON in this exact format (no markdown, no extra text):
{{
  "questions": [
    {{
      "question": "The question text",
      "options": ["Option A", "Option B", "Option C", "Option D"],
      "correct_answer": "Option A",
      "explanation": "Why this is the correct answer"
    }}
  ]
}}

Rules:
- Each question must have exactly 4 options
- The correct_answer must be one of the options
- Questions should test English grammar, vocabulary, or comprehension
- Difficulty levels: beginner (simple vocabulary), intermediate (moderate), advanced (complex)
- Make questions educational and relevant to the topic
- Vary question types: grammar, vocabulary, reading comprehension, fill in the blank
"""
