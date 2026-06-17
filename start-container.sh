#!/usr/bin/env bash
set -e

PROJECT_PATH="$(cd "$(dirname "$0")" && pwd)"

echo "🚀 Launching the container..."

mkdir -p "$PROJECT_PATH/models"

docker build -t aiworkspace_workspace . && docker run -it \
  --name aiworkspace_container \
  --privileged \
  -v "$PROJECT_PATH:/workspace" \
  -v /var/run/docker.sock:/var/run/docker.sock \
  aiworkspace_workspace
