from app.services.text_comparison import compare_texts


class TestCompareTexts:
    def test_perfect_match(self):
        result = compare_texts(
            "Hello how are you today",
            "Hello how are you today"
        )
        assert result["score"] == 100.0
        assert result["correct_count"] == 5
        assert result["wrong_words"] == []

    def test_partial_match(self):
        result = compare_texts(
            "Hello how is you today",
            "Hello how are you today"
        )
        assert result["score"] == 80.0
        assert result["correct_count"] == 4
        assert len(result["wrong_words"]) == 1
        assert result["wrong_words"][0]["expected"] == "are"
        assert result["wrong_words"][0]["actual"] == "is"

    def test_empty_transcript(self):
        result = compare_texts("", "Hello world")
        assert result["score"] == 0.0
        assert result["correct_count"] == 0
        assert len(result["wrong_words"]) == 2

    def test_empty_target(self):
        result = compare_texts("Hello", "")
        assert result["score"] == 0.0
        assert result["word_count"] == 0

    def test_case_insensitive(self):
        result = compare_texts(
            "HELLO HOW ARE YOU",
            "hello how are you"
        )
        assert result["score"] == 100.0

    def test_punctuation_ignored(self):
        result = compare_texts(
            "Hello, how are you?",
            "Hello how are you"
        )
        assert result["score"] == 100.0

    def test_completely_wrong(self):
        result = compare_texts(
            "cat dog bird",
            "the quick brown fox"
        )
        assert result["score"] < 50

    def test_extra_words_in_transcript(self):
        result = compare_texts(
            "Hello there how are you",
            "Hello how are you"
        )
        # Extra words should not reduce score much
        assert result["score"] >= 50
