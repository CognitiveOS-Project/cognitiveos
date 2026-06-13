# AI Workspace

**Zero-setup scaffold for AI-assisted development with OpenCode.**

This repo is designed around a simple insight: every AI coding session can waste 30 minutes figuring out project setup, conventions, and tooling — or it can just work. This workspace is that second option.

<div align="center">
  <a href="https://codespaces.new/jeanmachuca/aiworkspace">
    <img src="https://github.com/codespaces/badge.svg" alt="Open in GitHub Codespaces" />
  </a>
  <br />
  <sub><b>One-click cloud dev environment</b> — no setup, no install</sub>
</div>

<br />

One `git clone` and you get a battle-tested structure where:

- **AI agents know how to work here** — `AGENTS.md`, `opencode.json`, and `.opencode/instructions/` pre-load agents with workspace conventions, git workflow, and tooling so they don't guess.
- **Projects are isolated** — each subfolder is its own independent git repo with its own language, framework, CI, and `AGENTS.md`. Root level is scaffolding, not code.
- **CI/CD ships free** — auto-PR on `feature/*`/`fix/*`/`bugfix/*` push, `main`-from-`development` enforcement, and publish workflow templates.
- **Container-friendly** — `./start.sh` restores `gh` auth, SSH config, and local inference server on ephemeral container rebuild.
- **Opinionated git workflow** — topic branches, no rebase, SemVer tags. Documented once, used by every agent.

## What's inside

| What | Why it matters |
|------|----------------|
| `AGENTS.md` | Tells any AI agent the workspace layout, tooling, and conventions |
| `opencode.json` | OpenCode config with local + cloud model presets |
| `.opencode/instructions/git-workflow.md` | Branch/PR/release conventions loaded automatically |
| `.github/workflows/` | Auto-PR, main protection, CI/test/publish templates |
| `.pre-commit-config.yaml` | Pre-commit hooks (trailing whitespace, YAML, large files) |
| `start.sh` | Single‑command container bootstrap |
| `dev-requirements.txt` | Dev tool deps (pre-commit) |

## Quick start

### 🌐 GitHub Codespaces (recommended)

Click the button above to launch a fully configured cloud dev environment in seconds. Codespaces comes with all tooling pre-installed — no local setup required.

### 💻 Local

```bash
git clone <repo-url>
cd <repo>
pip install -r dev-requirements.txt && pre-commit install
```

To spin up a new project, create a subfolder and give it its own `AGENTS.md`, language config, and CI. The root ignores it by default — you own it completely.

## AI agent awareness

This repo uses OpenCode's `instructions` array to load `AGENTS.md` automatically in every session. Agents start knowing:

- Root is scaffolding, subfolders are standalone repos
- Pre-commit is the only root-level dev tool
- The git workflow (topic branches, no rebase, PR flow)
- CI workflows exist and which are functional vs placeholder
- Container is ephemeral — `./start.sh` restores everything

No prompt preamble needed. Just start working.

## Git workflow

All pushed branches follow the same path:

feature/fix/bugfix branch → PR → `development` → PR → `main` → SemVer tag

The auto-PR workflow opens a PR to `development` automatically whenever a `feature/*`, `fix/*`, or `bugfix/*` branch is pushed. The `main` branch accepts PRs only from `development`.

See [`.opencode/instructions/git-workflow.md`](.opencode/instructions/git-workflow.md) for details.

## CI workflows

- **open-pr-to-development.yml** — auto‑opens PR when pushing `feature/*`, `fix/*`, `bugfix/*`
- **main-pr-source.yml** — enforces that PRs to `main` originate from `development`
- **CI** — placeholder (replace with your test/lint commands)
- **publish.yml** — commented template for GHCR Docker image publishing

## Container bootstrap

The dev container is ephemeral. After rebuild:

```bash
./start.sh
```

This installs the local code-inference server and starts it in full isolation mode.

## Making it yours

Fork or clone this repo and:

1. Replace the CI workflow placeholders with your project's test/lint commands
2. Add language-specific tooling to `dev-requirements.txt`
3. Create your first project subfolder with its own `AGENTS.md`
4. Set branch protection on `main` and `development` (GH repo settings)
5. Enable "Read and write permissions" for Actions (required for auto-PR workflow)

## Model switching

The default model is a local GGUF inference server (`http://api:8000/v1`). Cloud model aliases are pre-configured in `opencode.json`:

- `big-pickle`
- `deepseek-v4-flash-free`
- `mimo-v2.5-free`
- `nemotron-3-ultra-free`

Switch with `/model <name>` in OpenCode.

## License

[MIT](LICENSE)
