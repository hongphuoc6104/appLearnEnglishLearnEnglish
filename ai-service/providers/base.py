from abc import ABC, abstractmethod
from typing import Optional
from PIL import Image


class AIProvider(ABC):
    @abstractmethod
    def generate(self, prompt: str, image: Optional[Image.Image] = None) -> str:
        """Generate a response from a prompt and optional image."""
        ...
