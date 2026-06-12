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

## Commands (workspace root only)

| Action | Command |
|--------|---------|
| Install workspace pre-commit hooks | `pre-commit install` |

Subfolder projects define their own commands.

## Git workflow

Follow `.opencode/instructions/git-workflow.md` for each project repo: topic branches from `development`, PRs, no rebase, annotated SemVer tags.

SSH workaround (Linux container, macOS host) is documented in the same file.
