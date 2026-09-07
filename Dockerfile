FROM nvidia/cuda:12.4.1-devel-ubuntu22.04

ENV DEBIAN_FRONTEND=noninteractive \
    PYTHONUNBUFFERED=1 \
    HF_XET_HIGH_PERFORMANCE=1

WORKDIR /workspace

RUN apt-get update && apt-get install -y --no-install-recommends \
    python3-pip python3-dev git wget ffmpeg ninja-build \
    && rm -rf /var/lib/apt/lists/*

# CRÍTICO: Actualizar pip primero. Sin esto, Ubuntu instala un PyTorch viejo que causa el error.
RUN pip install --no-cache-dir --upgrade pip setuptools wheel

RUN git clone https://github.com/comfyanonymous/ComfyUI.git /workspace/ComfyUI
WORKDIR /workspace/ComfyUI

# CRÍTICO: Forzar PyTorch 2.5.1 o superior (que soporta 'list[int]')
RUN pip install --no-cache-dir "torch>=2.5.1" torchvision torchaudio --extra-index-url https://download.pytorch.org/whl/cu124

# Instalar los requirements de ComfyUI y las dependencias extra
RUN pip install --no-cache-dir -r requirements.txt && \
    pip install --no-cache-dir accelerate transformers sentencepiece safetensors hf-transfer comfy-kitchen

EXPOSE 8188

CMD ["python3", "main.py", "--listen", "0.0.0.0", "--port", "8188"]
