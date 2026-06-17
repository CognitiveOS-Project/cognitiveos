#!/usr/bin/env bash
set -e

echo "🚀 Launching the container..."

docker build -t aiworkspace_workspace . && docker run -it \
  --name aiworkspace_container \
   --privileged \
  -v $(pwd):/workspace \
  -v $(pwd)/models:/workspace/models \
  -v /var/run/docker.sock:/var/run/docker.sock \
  aiworkspace_workspace
