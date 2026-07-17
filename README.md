# CognitiveOS

**An AI-native operating system.** No apps. No browsers. No permission dialogs. Intent-centric computing.

Replace app-centric computing — find, open, learn, grant permissions, manage files — with a single interaction:

```
1. Start the device
2. Ask AI (speak or text)
3. AI does something
```

The human sets goals. The AI operates the machine.

---

## Architecture

Two-tier AI brain on Alpine Linux, controlled via Bubble Tea TUI, talking to hardware through MCP bridges:

```
┌─────────────────────────────────────────────────────┐
│                    User (Human)                      │
├─────────────────────────────────────────────────────┤
│                    Bubble Tea TUI (cli)              │
├─────────────────────────────────────────────────────┤
│         cognitiveosd (daemon — message bus)          │
├──────────────────┬──────────────────────────────────┤
│   Raw Model      │    Wide Model (inference)         │
│   (local, MCU)   │    (local or remote .gguf)       │
├──────────────────┴──────────────────────────────────┤
│  MCP Bridges: display, audio, network, gpio, serial  │
├─────────────────────────────────────────────────────┤
│              Alpine Linux + /dev/fb0                 │
└─────────────────────────────────────────────────────┘
```

## Repositories

| Repo | Language | Role | Build |
|------|----------|------|-------|
| [product-specs](https://github.com/CognitiveOS-Project/product-specs) | Markdown/JSON | Standards, schemas, .cgp format | — |
| [sdlc](https://github.com/CognitiveOS-Project/sdlc) | Markdown | Implementation plan, workflow, CI/CD | — |
| [cpm](https://github.com/CognitiveOS-Project/cpm) | Go | Cognitive Package Manager | `make build` |
| [core-mcp-bridges](https://github.com/CognitiveOS-Project/core-mcp-bridges) | Go | MCP hardware tool servers | `make build` |
| [inference](https://github.com/CognitiveOS-Project/inference) | Go/C | LLM inference engine | `make build` |
| [cognitiveosd](https://github.com/CognitiveOS-Project/cognitiveosd) | Go | System daemon | `make build` |
| [cli](https://github.com/CognitiveOS-Project/cli) | Go | Bubble Tea TUI frontend | `make build` |
| [coginit](https://github.com/CognitiveOS-Project/coginit) | Go | Boot manager / init | `make build` |
| [cognitiveos-alpine-distro](https://github.com/CognitiveOS-Project/cognitiveos-alpine-distro) | Shell/Docker | Alpine image builder (orchestrator) | `make iso` / `make rpi` |
| [cgp-template](https://github.com/CognitiveOS-Project/cgp-template) | Template | .cgp boilerplate | — |
| [registry-server](https://github.com/CognitiveOS-Project/registry-server) | Go | Package registry | `make build` |

## Design Principles

- **AI is the OS, not an app** — The AI owns hardware, resources, software lifecycle, and interaction. No fallback desktop. No settings app.
- **One user: the AI** — No user accounts, no permission groups. The AI has unfettered hardware access.
- **Self-managing** — The AI discovers, installs, and removes its own capabilities. The human never touches a package manager.
- **Ephemeral interface** — No windows, no home screen, no app grid. UI exists only for the duration of a task.
- **Universal substrate** — Same architecture from a smartwatch to a server. The only difference is where the model runs.

## Quick Start — Build a Component

Each component builds independently:

```bash
# Build cpm
git clone git@github.com:CognitiveOS-Project/cpm.git && cd cpm && make build

# Build cognitiveosd
git clone git@github.com:CognitiveOS-Project/cognitiveosd.git && cd cognitiveosd && make build
```

Standard targets across all Go repos: `make build`, `make test`, `make lint`, `make clean`.

For the full distro ISO:

```bash
git clone git@github.com:CognitiveOS-Project/cognitiveos-alpine-distro.git
cd cognitiveos-alpine-distro
make iso
```

See each sub-repo's README for component-level build instructions.

## Implementation Status

Each component is at a different maturity level. Here is the current state across all repos:

| Repo | Status | Details |
|------|--------|---------|
| [product-specs](https://github.com/CognitiveOS-Project/product-specs) | ✅ Complete | All 19 specs + 7 JSON Schemas documented |
| [sdlc](https://github.com/CognitiveOS-Project/sdlc) | ✅ Complete | Implementation plan, CI/CD workflow documented |
| [cpm](https://github.com/CognitiveOS-Project/cpm) | 🟡 Partial | 8 core commands (init/install/remove/list/info/verify/search/update) + publish implemented; Universal Protocol Router (git providers, npm/bun/deno) spec'd but not wired |
| [cli](https://github.com/CognitiveOS-Project/cli) | 🟡 Partial | 6/7 display modes (system, processes, hardware, logs, network, config) implemented; Media mode spec'd but not rendered |
| [cognitiveosd](https://github.com/CognitiveOS-Project/cognitiveosd) | 🟡 Partial | Unix socket protocol + Raw Model client integration done; cgroups/seccomp/chroot isolation per spec not yet implemented |
| [inference](https://github.com/CognitiveOS-Project/inference) | 🟡 Partial | HTTP inference API + cograw Unix socket server exist; GGUF model loading uses mock — no real CGo bindings yet |
| [core-mcp-bridges](https://github.com/CognitiveOS-Project/core-mcp-bridges) | ✅ Complete | All 5 bridges (display, audio, network, gpio, serial) implemented |
| [registry-server](https://github.com/CognitiveOS-Project/registry-server) | 🟡 Partial | Proxy/notary (302 redirect + SHA-256 ledger) + publish done; no version listing endpoint yet, still uses in-memory store |
| [coginit](https://github.com/CognitiveOS-Project/coginit) | ✅ Complete | Boot manager: engine orchestration, backdoor shell, cross-platform (Linux + stubs) |
| [cognitiveos-alpine-distro](https://github.com/CognitiveOS-Project/cognitiveos-alpine-distro) | ✅ Complete | Bootable ISO (x86_64) + RPi (aarch64) image builds with CI release workflow |
| [cgp-template](https://github.com/CognitiveOS-Project/cgp-template) | ✅ Complete | .cgp package skeleton template |
| raw-model | 📝 Spec'd | Specification in product-specs; no implementation yet |
| ephemeral-identity | 📝 Spec'd | Specification in product-specs; no implementation yet |
| hardware-spec | 📝 Spec'd | Specification in product-specs; no implementation yet |
| dependency-validation | 📝 Spec'd | Validation rules (A9-A10, B7-B9) documented; not wired into cpm |
| security-model | 📝 Spec'd | Specification in product-specs; no implementation yet |

## Git Workflow

All repos work directly on `main`:

```
topic branch → PR → main → SemVer tag
```

SSH-only, no rebase. See `.opencode/instructions/git-workflow.md` for details.

## Author

**Jean Machuca** — [GitHub](https://github.com/jeanmachuca) · [Sponsor](https://github.com/sponsors/jeanmachuca) · [LinkedIn](https://linkedin.com/in/jeanmachuca)


## Acknowledgments

See [ACKNOWLEDGMENTS.md](ACKNOWLEDGMENTS.md) for the open-source projects that make CognitiveOS possible.

## License

MIT
