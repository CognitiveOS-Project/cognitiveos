#!/usr/bin/env sh
# Bootstrap script for ephemeral dev container.
# Run after container rebuild to restore tooling config.

set -e

# ── 1. ~/.profile ──────────────────────────────────────────────────────────────

if [ ! -f "$HOME/.profile" ] || ! grep -q GH_TOKEN "$HOME/.profile" 2>/dev/null; then
  echo ">>> Creating ~/.profile with GH_TOKEN and SSH workaround..."
  cat << 'EOF' >> "$HOME/.profile"

# Export GH_TOKEN from gh hosts.yml for API auth
if [ -f "$HOME/.config/gh/hosts.yml" ]; then
  export GH_TOKEN=$(grep oauth_token "$HOME/.config/gh/hosts.yml" | head -1 | awk '{print $2}')
fi

# SSH config workaround (Linux container, macOS host with UseKeychain)
if [ -f "$HOME/.ssh/config" ] && grep -q UseKeychain "$HOME/.ssh/config" 2>/dev/null; then
  export GIT_SSH_COMMAND="ssh -F <(sed '/UseKeychain/d' "$HOME/.ssh/config")"
fi
EOF
fi

# Source it so it takes effect immediately
. "$HOME/.profile"

# ── 2. gh auth ─────────────────────────────────────────────────────────────────

if ! gh auth status >/dev/null 2>&1; then
  echo ""
  echo ">>> gh is not authenticated."
  echo ">>> Starting device-code login flow..."
  echo ""
  printf '\n' | gh auth login --git-protocol ssh --web
  echo ""
  echo ">>> Re-sourcing profile to pick up GH_TOKEN..."
  . "$HOME/.profile"
  echo ">>> GH_TOKEN: ${GH_TOKEN:+set} (${#GH_TOKEN} chars)"
fi

echo ""
echo "=== Setup complete ==="
echo "GH_TOKEN: ${GH_TOKEN:+set}"
echo "GIT_SSH_COMMAND: ${GIT_SSH_COMMAND:+set}"
