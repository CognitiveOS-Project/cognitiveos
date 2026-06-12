# AI Workspace

This workspace root is a **scaffold** for creating independent projects. Each subfolder is its own git repo with its own GitHub remote. Nothing at root level is shared code — it's all workspace-level tooling config.

## Structure

- Each subfolder = standalone git repo, independent language/framework, its own CI, its own `AGENTS.md`. Enforced by `.gitignore` (`/*/` ignores all subdirectories at root level)
- Root config files (this file, `opencode.json`, `.pre-commit-config.yaml`, `.github/`) are **workspace scaffolding**, not project-specific — do not apply them to subfolder repos
- `.opencode/instructions/git-workflow.md` — workspace-wide git convention (topic branches, no rebase, SemVer). Referenced via `opencode.json` `instructions`. Apply per-repo when creating new projects.

## What's ready

- `opencode.json` — configured with local inference server at `http://api:8000/v1` and several cloud model aliases
- `.pre-commit-config.yaml` — only generic hooks (trailing-whitespace, end-of-file-fixer, check-yaml, check-added-large-files)
- `dev-requirements.txt` — only `pre-commit` installed; language-specific tools (ruff, mypy, pytest) are **placeholders** — each project must install its own
- CI workflows (`.github/workflows/`) — all **placeholder/TODO** scaffolding; every project needs its own CI

## Creating a new project

1. `mkdir <project-name>`
2. `cd <project-name> && git init`
3. Add project-specific `AGENTS.md`, CI, tooling config, dependencies
4. Create on GitHub, `git remote add origin <url>`
5. Push initial commit per the git workflow (topic branch → PR)

## Container is ephemeral — nothing survives a rebuild

The dev container has no persistent home directory. After a rebuild:
- `gh` auth is lost
- `~/.profile` (with `GH_TOKEN` and `GIT_SSH_COMMAND`) is lost

### Bootstrap after rebuild

```bash
./setup.sh
```

This will:
1. Append `~/.profile` with `GH_TOKEN` extraction and `UseKeychain` workaround
2. Run `gh auth login --git-protocol ssh --web` (device-code flow) if needed
3. Source the profile so vars are available immediately

### Manual steps (if `setup.sh` can't be used)

1. **`~/.profile`** — create it with:
   ```sh
   # Export GH_TOKEN from gh hosts.yml for API auth
   if [ -f "$HOME/.config/gh/hosts.yml" ]; then
     export GH_TOKEN=$(grep oauth_token "$HOME/.config/gh/hosts.yml" | head -1 | awk '{print $2}')
   fi

   # SSH config workaround (Linux container, macOS host with UseKeychain)
   if [ -f "$HOME/.ssh/config" ] && grep -q UseKeychain "$HOME/.ssh/config" 2>/dev/null; then
     export GIT_SSH_COMMAND="ssh -F <(sed '/UseKeychain/d' "$HOME/.ssh/config")"
   fi
   ```
2. **`gh auth login --git-protocol ssh --web`** — authenticate with the device code
3. Source the profile: `. ~/.profile`

## Commands (workspace root only)

| Action | Command |
|--------|---------|
| Install workspace pre-commit hooks | `pre-commit install` |
| Bootstrap after container rebuild | `./setup.sh` |

Subfolder projects define their own commands.

## Git workflow

Follow `.opencode/instructions/git-workflow.md` for each project repo: topic branches from `development`, PRs, no rebase, annotated SemVer tags.

SSH workaround (Linux container, macOS host) is documented in the same file.
