#!/usr/bin/env sh
# Bootstrap script for ephemeral dev container.
# Run after container rebuild to restore tooling config.

(curl -sS https://raw.githubusercontent.com/jeanmachuca/code-inference/main/install.sh | sh) || true
/home/codespace/.code-inference/start.sh --full-isolation