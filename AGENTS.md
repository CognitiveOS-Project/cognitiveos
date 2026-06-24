# AI Workspace

**Root is scaffolding, not code.** Workspace-level tooling for creating independent projects.

## Structure

- Each subfolder is a standalone git repo with its own `AGENTS.md`, language, framework, CI
- `.gitignore` uses `/*/`; only `/.github/` and `/.opencode/` are tracked at root
- Root config (`opencode.json`, `.pre-commit-config.yaml`, `.github/`) is scaffolding — do not apply to subfolder repos; they own their own tooling
- Root commands: `pre-commit install` only. Subfolder projects define their own.

## Directory usage

- **Workspace root** (where `opencode.json` and this file live) — Use for all git operations, project files, and cloned repos. This is the persistent working directory.
- **`/tmp/opencode`** — For temporary/throwaway files only. May be root-owned and unwritable; if so, use a temp subdirectory under the workspace root instead.
- When cloning repos for editing, clone them into subdirectories under the workspace root, e.g. `gh repo clone owner/repo ./repo`. Each subfolder is a standalone git repo (`.gitignore` pattern `/*/` keeps them independent from the root).
- **Org meta-repos** (e.g., `CognitiveOS-Project/.github`) — avoid name collisions with the root's `/.github/` directory. Clone into a descriptive name like `org-repo` instead: `gh repo clone CognitiveOS-Project/.github ./org-repo`.

## Dev tooling

- `pre-commit` (install via `pip install -r dev-requirements.txt && pre-commit install`) — the only root-level dev tool. Subfolder projects manage their own.

## Always-loaded instruction files

These are wired via `opencode.json` `instructions` array or YAML frontmatter `alwaysApply: true`:
- `AGENTS.md` (this file) — workspace structure
- `.opencode/instructions/git-workflow.md` — branching, PR flow, no rebase, sync, auth setup

**Subfolder repos chain their own `AGENTS.md`** — when opencode operates inside a subfolder project, it loads that repo's `AGENTS.md` in addition to the root instructions. Subfolder rules add to (not replace) the workspace rules.

**Git workflow applies to all repos.** The root `git-workflow.md` instructions (branching, PR flow, no rebase, sync, auth) remain in effect when working inside subfolder projects. Subfolder repos should not override git workflow rules.

## start.sh

`start.sh` installs and launches a local code-inference server. Run it manually — it needs Docker and git, plus an interactive TTY.

## CI workflows (`.github/workflows/`)

- `CI` and `publish.yml` — TODO: each project fills in their own
- `open-pr-to-development.yml` — functional: auto-opens PR on `feature/*`, `fix/*`, `bugfix/*` push
- `main-pr-source.yml` — functional: enforces PRs to `main` originate from `development`

## Auth

**SSH only — never HTTPS.** This instance is pre-configured with SSH keys for `gh` and `git`. HTTPS with token-based auth is fragile and must not be used.

- Remote URLs must use `git@github.com:` (SSH), never `https://github.com/`.
- Do not set or rely on `GH_TOKEN` for git operations. The env var may contain stale credentials.
- If `GH_TOKEN` is set and invalid, unset it before running `gh` commands.

## Default model

`opencode.json` defaults to local inference at `http://api:8000/v1` (model.gguf). Cloud model aliases (`big-pickle`, `deepseek-v4-flash-free`, etc.) — switch with `/model`.
