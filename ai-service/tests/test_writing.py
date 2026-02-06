import pytest
from fastapi.testclient import TestClient
from main import app


@pytest.fixture
def client():
    return TestClient(app)


class TestWritingEndpoint:
    def test_health_check(self, client):
        response = client.get("/health")
        assert response.status_code == 200
        assert response.json()["status"] == "ok"

    def test_empty_text_rejected(self, client):
        response = client.post("/correct-writing", json={"text": ""})
        assert response.status_code == 422

    def test_short_text_rejected(self, client):
        response = client.post("/correct-writing", json={"text": "ab"})
        assert response.status_code == 400

    def test_valid_request_format(self, client):
        """Test that valid requests are accepted (actual AI response may vary)."""
        # This test verifies the endpoint accepts valid input
        # It may fail if GEMINI_API_KEY is not set, which is expected in CI
        response = client.post(
            "/correct-writing",
            json={"text": "I is a good student and I goes to school everyday."}
        )
        # Either 200 (with API key) or 503 (without API key) is acceptable
        assert response.status_code in [200, 503]
