#!/usr/bin/env bash
set -e

echo "🚀 Launching code-inference..."

# Install code-inference if not already present
if [ ! -f "/home/codespace/.code-inference/start.sh" ]; then
  echo "📦 Installing code-inference..."
  curl -s https://raw.githubusercontent.com/jeanmachuca/code-inference/main/install.sh | sh 2>/dev/null || echo "⚠️ code-inference install skipped (no permission in this environment)"
fi

# Launch code-inference (captures terminal) — fail silently if not installed
if [ -f "/home/codespace/.code-inference/start.sh" ]; then
  exec /home/codespace/.code-inference/start.sh --full-isolation
fi
