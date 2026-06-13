# AI Workspace

**Root is scaffolding, not code.** Workspace-level tooling for creating independent projects.

## Structure

- Each subfolder is a standalone git repo with its own `AGENTS.md`, language, framework, CI
- `.gitignore` uses `/*/`; only `/.github/` and `/.opencode/` are tracked at root
- Root config (`opencode.json`, `.pre-commit-config.yaml`, `.github/`) is scaffolding — do not apply to subfolder repos; they own their own tooling
- Root commands: `pre-commit install` and `./setup.sh` only. Subfolder projects define their own.

## Always-loaded instruction files

These are wired via `opencode.json` `instructions` array or YAML frontmatter `alwaysApply: true`:
- `AGENTS.md` (this file) — workspace structure
- `.opencode/instructions/git-workflow.md` — branching, PR flow, no rebase, sync, auth setup

## Container is ephemeral

`gh` auth, `~/.profile` (GH_TOKEN, GIT_SSH_COMMAND) vanish on rebuild. Bootstrap:

```bash
./setup.sh
```

## CI workflows (`.github/workflows/`)

- `CI` and `publish.yml` — TODO: each project fills in their own
- `open-pr-to-development.yml` — functional: auto-opens PR on `feature/*`, `fix/*`, `bugfix/*` push
- `main-pr-source.yml` — functional: enforces PRs to `main` originate from `development`

## Default model

`opencode.json` defaults to local inference at `http://api:8000/v1` (model.gguf). Cloud model aliases (`big-pickle`, `deepseek-v4-flash-free`, etc.) — switch with `/model`.
