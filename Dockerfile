FROM nvidia/cuda:12.4.1-devel-ubuntu22.04

ENV DEBIAN_FRONTEND=noninteractive \
    PYTHONUNBUFFERED=1 \
    HF_HUB_ENABLE_HF_TRANSFER=1

WORKDIR /workspace

RUN apt-get update && apt-get install -y --no-install-recommends \
    python3-pip python3-dev git wget ffmpeg ninja-build \
    && rm -rf /var/lib/apt/lists/*

# Instalar PyTorch
RUN pip install --no-cache-dir torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu124

RUN git clone https://github.com/comfyanonymous/ComfyUI.git /workspace/ComfyUI
WORKDIR /workspace/ComfyUI

# Instalar requisitos y forzar la actualización de comfy-kitchen
RUN pip install --no-cache-dir -r requirements.txt && \
    pip install --no-cache-dir --upgrade comfy-kitchen && \
    pip install --no-cache-dir accelerate transformers sentencepiece safetensors hf-transfer

EXPOSE 8188

CMD ["python3", "main.py", "--listen", "0.0.0.0", "--port", "8188"]
