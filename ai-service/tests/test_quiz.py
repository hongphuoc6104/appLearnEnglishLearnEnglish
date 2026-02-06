import pytest
from fastapi.testclient import TestClient
from main import app


@pytest.fixture
def client():
    return TestClient(app)


class TestQuizEndpoint:
    def test_empty_topic_rejected(self, client):
        response = client.post("/generate-quiz", json={"topic": ""})
        assert response.status_code == 422

    def test_short_topic_rejected(self, client):
        response = client.post("/generate-quiz", json={"topic": "a"})
        assert response.status_code == 400

    def test_invalid_count(self, client):
        response = client.post(
            "/generate-quiz",
            json={"topic": "grammar", "count": 100}
        )
        assert response.status_code == 422

    def test_valid_request_format(self, client):
        """Test that valid requests are accepted."""
        response = client.post(
            "/generate-quiz",
            json={
                "topic": "English greetings",
                "type": "mcq",
                "count": 3,
                "difficulty": "beginner"
            }
        )
        # Either 200 (with API key) or 503 (without API key) is acceptable
        assert response.status_code in [200, 503]
