import logging
from typing import Optional

import numpy as np
import torch
import torchvision.transforms as T
from PIL import Image
from torchvision.transforms.functional import InterpolationMode
from transformers import AutoModel, AutoTokenizer

from config import settings
from providers.base import AIProvider

logger = logging.getLogger(__name__)

IMAGENET_MEAN = (0.485, 0.456, 0.406)
IMAGENET_STD = (0.229, 0.224, 0.225)


def build_transform(input_size):
    return T.Compose([
        T.Lambda(lambda img: img.convert("RGB") if img.mode != "RGB" else img),
        T.Resize(
            (input_size, input_size), interpolation=InterpolationMode.BICUBIC
        ),
        T.ToTensor(),
        T.Normalize(mean=IMAGENET_MEAN, std=IMAGENET_STD),
    ])


def find_closest_aspect_ratio(aspect_ratio, target_ratios, width, height, image_size):
    best_ratio_diff = float("inf")
    best_ratio = (1, 1)
    area = width * height
    for ratio in target_ratios:
        target_aspect_ratio = ratio[0] / ratio[1]
        ratio_diff = abs(aspect_ratio - target_aspect_ratio)
        if ratio_diff < best_ratio_diff:
            best_ratio_diff = ratio_diff
            best_ratio = ratio
        elif ratio_diff == best_ratio_diff:
            if area > 0.5 * image_size * image_size * ratio[0] * ratio[1]:
                best_ratio = ratio
    return best_ratio


def dynamic_preprocess(image, min_num=1, max_num=12, image_size=448, use_thumbnail=False):
    orig_width, orig_height = image.size
    aspect_ratio = orig_width / orig_height

    target_ratios = set(
        (i, j)
        for n in range(min_num, max_num + 1)
        for i in range(1, n + 1)
        for j in range(1, n + 1)
        if min_num <= i * j <= max_num
    )
    target_ratios = sorted(target_ratios, key=lambda x: x[0] * x[1])

    target_aspect_ratio = find_closest_aspect_ratio(
        aspect_ratio, target_ratios, orig_width, orig_height, image_size
    )

    target_width = image_size * target_aspect_ratio[0]
    target_height = image_size * target_aspect_ratio[1]
    blocks = target_aspect_ratio[0] * target_aspect_ratio[1]

    resized_img = image.resize((target_width, target_height))
    processed_images = []
    for i in range(blocks):
        box = (
            (i % (target_width // image_size)) * image_size,
            (i // (target_width // image_size)) * image_size,
            ((i % (target_width // image_size)) + 1) * image_size,
            ((i // (target_width // image_size)) + 1) * image_size,
        )
        processed_images.append(resized_img.crop(box))

    if use_thumbnail and len(processed_images) != 1:
        thumbnail_img = image.resize((image_size, image_size))
        processed_images.append(thumbnail_img)

    return processed_images


def preprocess_image(image: Image.Image, max_num=6) -> torch.Tensor:
    """Convert a PIL Image to pixel_values tensor for the model."""
    image = image.convert("RGB")
    transform = build_transform(input_size=448)
    images = dynamic_preprocess(
        image, image_size=448, use_thumbnail=True, max_num=max_num
    )
    pixel_values = torch.stack([transform(img) for img in images])
    return pixel_values


class LocalProvider(AIProvider):
    def __init__(self):
        self._model = None
        self._tokenizer = None
        self._device = "cuda" if torch.cuda.is_available() else "cpu"
        logger.info(
            "LocalProvider created (model will load on first request, device=%s)",
            self._device,
        )

    def _load_model(self):
        """Lazy-load the model only when first needed."""
        if self._model is not None:
            return

        model_name = settings.LOCAL_MODEL_NAME
        logger.info("Loading local model: %s (this may take a while)...", model_name)

        self._tokenizer = AutoTokenizer.from_pretrained(
            model_name,
            trust_remote_code=True,
            use_fast=False,
        )

        dtype = torch.bfloat16 if self._device == "cuda" else torch.float32
        self._model = AutoModel.from_pretrained(
            model_name,
            torch_dtype=dtype,
            low_cpu_mem_usage=True,
            trust_remote_code=True,
            use_flash_attn=False,
        ).eval()

        if self._device == "cuda":
            self._model = self._model.cuda()

        logger.info("Local model loaded successfully.")

    def generate(self, prompt: str, image: Optional[Image.Image] = None) -> str:
        self._load_model()

        generation_config = dict(
            max_new_tokens=1024,
            do_sample=False,
            num_beams=3,
            repetition_penalty=2.5,
        )

        pixel_values = None
        if image is not None:
            pixel_values = preprocess_image(image, max_num=6)
            dtype = torch.bfloat16 if self._device == "cuda" else torch.float32
            pixel_values = pixel_values.to(dtype)
            if self._device == "cuda":
                pixel_values = pixel_values.cuda()
            if "<image>" not in prompt:
                prompt = "<image>\n" + prompt

        response, _ = self._model.chat(
            self._tokenizer,
            pixel_values,
            prompt,
            generation_config,
            history=None,
            return_history=True,
        )
        return response
