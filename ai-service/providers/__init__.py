from config import settings
from providers.base import AIProvider


def get_provider() -> AIProvider:
    """Create the AI provider based on the AI_PROVIDER setting.

    Imports are deferred so that torch/transformers are never loaded
    when using the Gemini provider.
    """
    if settings.AI_PROVIDER == "LOCAL":
        from providers.local import LocalProvider
        return LocalProvider()
    else:
        from providers.gemini import GeminiProvider
        return GeminiProvider()
