#!/usr/bin/env bash
set -e

echo "🚀 Downloading and installing model in the volume..."

mkdir -p ./models
curl -L https://huggingface.co/Qwen/Qwen2.5-Coder-3B-Instruct-GGUF/resolve/main/qwen2.5-coder-3b-instruct-q4_k_m.gguf -o ./models/model.gguf
docker run --rm -v aiworkspace_model_data:/models -v "$PWD:/host" alpine cp /host/models/model.gguf /models/model.gguf && echo "Model installed!"
