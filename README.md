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

| Repo | Language | Role |
|------|----------|------|
| [product-specs](https://github.com/CognitiveOS-Project/product-specs) | Markdown/JSON | Standards, schemas, .cgp format |
| [sdlc](https://github.com/CognitiveOS-Project/sdlc) | Markdown | Implementation plan, workflow, CI/CD |
| [cpm](https://github.com/CognitiveOS-Project/cpm) | Go | Cognitive Package Manager |
| [core-mcp-bridges](https://github.com/CognitiveOS-Project/core-mcp-bridges) | Go | MCP hardware tool servers |
| [inference](https://github.com/CognitiveOS-Project/inference) | Go/C | LLM inference engine |
| [cognitiveosd](https://github.com/CognitiveOS-Project/cognitiveosd) | Go | System daemon |
| [cli](https://github.com/CognitiveOS-Project/cli) | Go | Bubble Tea TUI frontend |
| [cognitiveos-distro](https://github.com/CognitiveOS-Project/cognitiveos-distro) | Shell/Docker | Alpine image builder |
| [cgp-template](https://github.com/CognitiveOS-Project/cgp-template) | Template | .cgp boilerplate |
| [registry-server](https://github.com/CognitiveOS-Project/registry-server) | Go | Package registry |

## Design Principles

- **AI is the OS, not an app** — The AI owns hardware, resources, software lifecycle, and interaction. No fallback desktop. No settings app.
- **One user: the AI** — No user accounts, no permission groups. The AI has unfettered hardware access.
- **Self-managing** — The AI discovers, installs, and removes its own capabilities. The human never touches a package manager.
- **Ephemeral interface** — No windows, no home screen, no app grid. UI exists only for the duration of a task.
- **Universal substrate** — Same architecture from a smartwatch to a server. The only difference is where the model runs.

## Quick Start

```bash
# Clone the distro builder
git clone git@github.com:CognitiveOS-Project/cognitiveos-distro.git
cd cognitiveos-distro

# Build an x86_64 ISO
make iso
```

See each sub-repo's README for component-level build instructions.

## Status

All 7 implementation phases complete. Specs, SDLC, and all repos are implemented and merged.

## Git Workflow

All repos follow the same flow:

```
feature/fix/bugfix branch → PR → development → PR → main → SemVer tag
```

SSH-only, no rebase. See `.opencode/instructions/git-workflow.md` for details.

## Author

**Jean Machuca** — [GitHub](https://github.com/jeanmachuca) · [Sponsor](https://github.com/sponsors/jeanmachuca) · [LinkedIn](https://linkedin.com/in/jeanmachuca)

## License

MIT
