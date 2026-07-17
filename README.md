# CognitiveOS

> An AI-native operating system. No apps. No browsers. No permission dialogs.
> Intent-centric computing.

CognitiveOS replaces the app-centric model — find, open, learn, grant permissions, manage files — with a single interaction: start the device, ask the AI, and the AI handles everything. The human sets goals. The AI operates the machine.

---

## Why CognitiveOS

### The Problem

Computing today is app-centric. Every task requires finding the right app, opening it, navigating its interface, granting permissions, learning how it works, and switching between apps to compose results. The human adapts to the machine. The operating system does nothing — it is a blank slate that offloads every responsibility onto the user.

Current AI assistants (Siri, Google Assistant, Alexa) are not solutions. They are apps bolted onto legacy operating systems — thin voice layers that coexist with the app grid rather than replacing it.

### The Solution

CognitiveOS is built from the ground up as an intent-centric operating system. The entire user experience is three steps:

1. **Start the device**
2. **Ask AI** (speak or text)
3. **AI does something**

No apps. No browsers. No permission dialogs. No settings menus. No file managers. No notification center. The AI owns hardware, resources, software lifecycle, and interaction. The human speaks; the machine acts.

### Who This Is For

- **Makers and developers** building the next generation of computing — an OS where AI is the primary user, not an add-on
- **Investors** looking at the AI-native OS market — a clean-sheet architecture with no legacy baggage
- **Researchers** exploring intent-centric design, two-tier AI brains, and firmware-level guardrails

---

## Architecture

CognitiveOS runs on Alpine Linux with a two-tier AI brain, a message-bus daemon, and hardware abstraction through MCP bridges:

```
┌─────────────────────────────────────────────────────┐
│                    User (Human)                      │
├─────────────────────────────────────────────────────┤
│                  Bubble Tea TUI (cli)                │
├─────────────────────────────────────────────────────┤
│          coginit (boot manager / init)               │
├─────────────────────────────────────────────────────┤
│          cognitiveosd (daemon — message bus)          │
├──────────────────┬──────────────────────────────────┤
│   Raw Model      │    Wide Model (inference)         │
│   (local, MCU)   │    (local or remote .gguf)       │
├──────────────────┴──────────────────────────────────┤
│  MCP Bridges: display, audio, network, gpio, serial  │
├─────────────────────────────────────────────────────┤
│              Alpine Linux + /dev/fb0                 │
└─────────────────────────────────────────────────────┘
```

**Key concepts:**

- **Raw Model** — A lightweight, always-on firmware guardrail. Validates system codes, checks hardware resources, and filters prompts before they reach the Wide Model. Runs on local hardware (MCU-class). The Wide Model cannot read or modify it.

- **Wide Model** — A full-capability reasoning engine loaded on demand via `.gguf` files. Handles natural language understanding, task planning, and complex reasoning. Communicates with the daemon through an Ollama-compatible HTTP API.

- **MCP Bridges** — Six lightweight Go servers that expose hardware capabilities as MCP tools: display (framebuffer), audio (ALSA), network (Wi-Fi/Ethernet), GPIO, serial, and package management. The daemon spawns and supervises these automatically.

- **Package Manager (cpm)** — The AI discovers, installs, and removes its own capabilities through `.cgp` (Cognitive Patch) packages. The human never touches a package manager.

- **Boot Manager (coginit)** — PID 1 in Docker, child of OpenRC on bare-metal. Orchestrates engine startup in sequence: boot dependencies, Raw Model, inference engine, daemon, runtime dependencies, CLI. Includes a backdoor shell for emergency access.

---

## Project Status

CognitiveOS is actively booting and running real inference on both x86_64 and Raspberry Pi (aarch64). The core stack is operational: `coginit` boots the system, `cograw` loads the Raw Model guardrail, `coginfer` serves the Wide Model, `cognitiveosd` routes messages between the daemon and hardware bridges, and the CLI provides the human interface.

A bootable ISO image (x86_64) and RPi SD card image (aarch64) are building through CI. Docker images for all six variants (standard, gateway, edge, micro, titan) are published to GitHub Container Registry on every release.

The immediate focus is the **v0.1.0 release**: bootable images with real GGUF model inference, end-to-end "ask AI, get response" flow, and a functioning package registry. See [Milestones](https://github.com/CognitiveOS-Project/sdlc/blob/main/plan/milestones.md) for the full roadmap from M0 through M8.

---

## Repositories

| Repo | Language | Role | Build |
|------|----------|------|-------|
| [product-specs](https://github.com/CognitiveOS-Project/product-specs) | Markdown/JSON | Standards, schemas, .cgp format | — |
| [sdlc](https://github.com/CognitiveOS-Project/sdlc) | Markdown | Implementation plan, workflow, CI/CD | — |
| [cpm](https://github.com/CognitiveOS-Project/cpm) | Go | Cognitive Package Manager | `make build` |
| [core-mcp-bridges](https://github.com/CognitiveOS-Project/core-mcp-bridges) | Go | MCP hardware tool servers | `make build` |
| [inference](https://github.com/CognitiveOS-Project/inference) | Go/C | LLM inference engine (coginfer + cograw) | `make build` |
| [cognitiveosd](https://github.com/CognitiveOS-Project/cognitiveosd) | Go | System daemon | `make build` |
| [cli](https://github.com/CognitiveOS-Project/cli) | Go | Bubble Tea TUI frontend | `make build` |
| [coginit](https://github.com/CognitiveOS-Project/coginit) | Go | Boot manager / init | `make build` |
| [cognitiveos-alpine-distro](https://github.com/CognitiveOS-Project/cognitiveos-alpine-distro) | Shell/Docker | Alpine image builder | `make iso` / `make rpi` |
| [cgp-template](https://github.com/CognitiveOS-Project/cgp-template) | Template | .cgp boilerplate | — |
| [registry-server](https://github.com/CognitiveOS-Project/registry-server) | Go | Package registry | `make build` |

---

## Key Documents

All specifications, plans, and design documents are maintained across the project repositories. This index organizes them by audience.

### Vision and Design

| Document | Location | Description |
|----------|----------|-------------|
| [Vision and Philosophy](https://github.com/CognitiveOS-Project/product-specs/blob/main/specs/vision.md) | product-specs | Why CognitiveOS exists, the problem with app-centric computing |
| [Architecture](https://github.com/CognitiveOS-Project/product-specs/blob/main/specs/architecture.md) | product-specs | System architecture, layer diagram, component interactions |
| [Security Model](https://github.com/CognitiveOS-Project/product-specs/blob/main/specs/security-model.md) | product-specs | Trust boundaries, process isolation, firmware integrity |
| [Recommended Hardware](https://github.com/CognitiveOS-Project/product-specs/blob/main/specs/hardware.md) | product-specs | Hardware platforms from Jetson AGX Orin to ESP32-S3 |
| [Filesystem Hierarchy](https://github.com/CognitiveOS-Project/product-specs/blob/main/specs/filesystem-hierarchy.md) | product-specs | Directory structure and mount points |
| [Base Prompt](https://github.com/CognitiveOS-Project/product-specs/blob/main/specs/base-prompt.md) | product-specs | Default system prompt for the AI |

### Technical Specifications

| Document | Location | Description |
|----------|----------|-------------|
| [Boot Flow](https://github.com/CognitiveOS-Project/product-specs/blob/main/specs/boot-flow.md) | product-specs | Boot sequence, engine startup order, degraded mode |
| [Daemon API](https://github.com/CognitiveOS-Project/product-specs/blob/main/specs/cognitiveosd-api.md) | product-specs | cognitiveosd message protocol and socket interface |
| [Inference API](https://github.com/CognitiveOS-Project/product-specs/blob/main/specs/inference-api.md) | product-specs | Inference engine endpoints (Ollama-compatible) |
| [Package Manager](https://github.com/CognitiveOS-Project/product-specs/blob/main/specs/cpm-spec.md) | product-specs | cpm commands, dependency resolution, publish flow |
| [MCP Conventions](https://github.com/CognitiveOS-Project/product-specs/blob/main/specs/mcp-conventions.md) | product-specs | Bridge protocol, JSON-RPC 2.0 over stdio |
| [CGP Format](https://github.com/CognitiveOS-Project/product-specs/blob/main/specs/cgp-format.md) | product-specs | .cgp package archive format |
| [Registry API](https://github.com/CognitiveOS-Project/product-specs/blob/main/specs/registry-api.md) | product-specs | Package registry endpoints |
| [CLI Spec](https://github.com/CognitiveOS-Project/product-specs/blob/main/specs/cli-spec.md) | product-specs | TUI display modes, keybindings, state machine |
| [Raw Model](https://github.com/CognitiveOS-Project/product-specs/blob/main/specs/raw-model.md) | product-specs | Raw Model RPC methods and guardrail behavior |
| [System Codes](https://github.com/CognitiveOS-Project/product-specs/blob/main/specs/system-codes.md) | product-specs | wake, idle, security, reset, unlock |
| [Manifest Fields](https://github.com/CognitiveOS-Project/product-specs/blob/main/specs/manifest-fields.md) | product-specs | cognitive.json manifest schema fields |
| [Release Strategy](https://github.com/CognitiveOS-Project/product-specs/blob/main/specs/release-strategy.md) | product-specs | Versioning, tagging, coordinated releases |

### Architecture Decisions

| ADR | Decision |
|-----|----------|
| [ADR-002](https://github.com/CognitiveOS-Project/product-specs/blob/main/adr/ADR-002-download-weights.md) | Download weights from HuggingFace Hub |
| [ADR-003](https://github.com/CognitiveOS-Project/product-specs/blob/main/adr/ADR-003-backdoor-shell.md) | Backdoor shell for emergency access |
| [ADR-004](https://github.com/CognitiveOS-Project/product-specs/blob/main/adr/ADR-004-package-manager-mcp-bridge.md) | Package manager as MCP bridge |
| [ADR-005](https://github.com/CognitiveOS-Project/product-specs/blob/main/adr/ADR-005-local-fine-tuning.md) | Local fine-tuning strategy |
| [ADR-006](https://github.com/CognitiveOS-Project/product-specs/blob/main/adr/ADR-006-riscv64-architecture.md) | RISC-V (riscv64) as planned architecture |

### Development

| Document | Location | Description |
|----------|----------|-------------|
| [Implementation Plan](https://github.com/CognitiveOS-Project/sdlc/blob/main/plan/implementation-plan.md) | sdlc | Full build plan with phases, dependencies, deliverables |
| [Milestones](https://github.com/CognitiveOS-Project/sdlc/blob/main/plan/milestones.md) | sdlc | M0–M8 milestone tracking with completion status |
| [Contribution Guide](https://github.com/CognitiveOS-Project/sdlc/blob/main/workflow/contribution-guide.md) | sdlc | How to contribute, commit conventions, PR flow |
| [Code Review](https://github.com/CognitiveOS-Project/sdlc/blob/main/workflow/code-review.md) | sdlc | Review checklist and expectations |
| [Testing Strategy](https://github.com/CognitiveOS-Project/sdlc/blob/main/workflow/testing.md) | sdlc | Unit, integration, hardware, and boot testing |
| [CI/CD Pipeline](https://github.com/CognitiveOS-Project/sdlc/blob/main/workflow/ci-cd.md) | sdlc | Pipeline definitions for all repos |

### Website

| Resource | Link |
|----------|------|
| [cognitive-os.org](https://cognitive-os.org) | Project website and documentation |

---

## Getting Involved

### Contributors

Each repository builds independently. Fork, branch, and open a PR — the standard flow across all repos:

```bash
git clone git@github.com:CognitiveOS-Project/<repo>.git
cd <repo>
make build    # Compile
make test     # Run tests
make lint     # Run go vet
```

All Go repos use the same targets: `make build`, `make test`, `make lint`, `make clean`. See the [Contribution Guide](https://github.com/CognitiveOS-Project/sdlc/blob/main/workflow/contribution-guide.md) for branch naming, commit conventions, and the PR review process.

Good entry points for new contributors:
- [cgp-template](https://github.com/CognitiveOS-Project/cgp-template) — create a .cgp package
- [core-mcp-bridges](https://github.com/CognitiveOS-Project/core-mcp-bridges) — add hardware support
- [cli](https://github.com/CognitiveOS-Project/cli) — improve the TUI
- [product-specs](https://github.com/CognitiveOS-Project/product-specs) — write or improve specifications

### Community

Join the conversation on [GitHub Discussions](https://github.com/CognitiveOS-Project/cognitiveos/discussions) — ask questions, share ideas, and connect with other contributors.

### Sponsor CognitiveOS

CognitiveOS is an independent, open-source project. Sponsorship funds go toward:

- **Hardware** — development boards (Jetson, Raspberry Pi, RISC-V) for testing and CI
- **CI/CD** — GitHub Actions minutes for automated builds across six architecture variants
- **Infrastructure** — hosting for the package registry and documentation
- **Model licensing** — commercial-grade GGUF models for development and demos

[<img src="https://img.shields.io/badge/%E2%9D%A4%EF%B8%8F-Sponsor%20on%20GitHub-ea4aaa?style=for-the-badge" alt="Sponsor on GitHub">](https://github.com/sponsors/jeanmachuca)

---

## Author

**Jean Machuca** — [GitHub](https://github.com/jeanmachuca) · [Sponsor](https://github.com/sponsors/jeanmachuca) · [LinkedIn](https://linkedin.com/in/jeanmachuca)

---

## Acknowledgments

See [ACKNOWLEDGMENTS.md](ACKNOWLEDGMENTS.md) for the open-source projects that make CognitiveOS possible — Alpine Linux, llama.cpp, Bubble Tea, MCP, and others.

---

## License

MIT
