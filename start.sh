#!/usr/bin/env bash
set -e

echo "🚀 Launching code-inference..."

# Install code-inference if not already present
if [ ! -f "/home/codespace/.code-inference/start.sh" ]; then
  echo "📦 Installing code-inference..."
  curl -sS https://raw.githubusercontent.com/jeanmachuca/code-inference/main/install.sh | sh || {
    echo "❌ Failed to install code-inference"
    exit 1
  }
fi

# Launch code-inference (captures terminal)
exec /home/codespace/.code-inference/start.sh --full-isolation
