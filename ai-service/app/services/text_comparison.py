import re
from difflib import SequenceMatcher
from typing import List, Tuple


def normalize_text(text: str) -> str:
    """Normalize text: lowercase, strip punctuation, collapse whitespace."""
    text = text.lower().strip()
    text = re.sub(r'[^\w\s]', '', text)
    text = re.sub(r'\s+', ' ', text)
    return text


def compare_texts(transcript: str, target: str) -> dict:
    """Compare transcribed text with target text and return scoring details."""
    norm_transcript = normalize_text(transcript)
    norm_target = normalize_text(target)

    if not norm_target:
        return {
            "score": 0.0,
            "transcript": transcript,
            "target_text": target,
            "wrong_words": [],
            "word_count": 0,
            "correct_count": 0,
        }

    target_words = norm_target.split()
    transcript_words = norm_transcript.split()

    if not transcript_words:
        wrong_words = [
            {"index": i, "expected": w, "actual": ""}
            for i, w in enumerate(target_words)
        ]
        return {
            "score": 0.0,
            "transcript": transcript,
            "target_text": target,
            "wrong_words": wrong_words,
            "word_count": len(target_words),
            "correct_count": 0,
        }

    # Use SequenceMatcher to align words
    matcher = SequenceMatcher(None, target_words, transcript_words)
    wrong_words = []
    correct_count = 0

    for tag, i1, i2, j1, j2 in matcher.get_opcodes():
        if tag == 'equal':
            correct_count += (i2 - i1)
        elif tag == 'replace':
            for k in range(i2 - i1):
                target_idx = i1 + k
                trans_idx = j1 + k if (j1 + k) < j2 else j2 - 1
                wrong_words.append({
                    "index": target_idx,
                    "expected": target_words[target_idx],
                    "actual": transcript_words[trans_idx] if trans_idx < len(transcript_words) else "",
                })
        elif tag == 'delete':
            for k in range(i1, i2):
                wrong_words.append({
                    "index": k,
                    "expected": target_words[k],
                    "actual": "",
                })
        elif tag == 'insert':
            pass  # Extra words in transcript, not counted against score

    word_count = len(target_words)
    score = (correct_count / word_count * 100) if word_count > 0 else 0.0

    return {
        "score": round(score, 1),
        "transcript": transcript,
        "target_text": target,
        "wrong_words": wrong_words,
        "word_count": word_count,
        "correct_count": correct_count,
    }
