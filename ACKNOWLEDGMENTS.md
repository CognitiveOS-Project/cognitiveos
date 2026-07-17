# Acknowledgments

CognitiveOS is an independent project. These open-source projects make it possible — thank you.

## Base System

- **[Alpine Linux](https://alpinelinux.org)** — Minimal Linux distribution that makes our single-process-root architecture possible.
  - [gitlab.alpinelinux.org](https://gitlab.alpinelinux.org/alpine)
- **[BusyBox](https://busybox.net)** — Core Unix utilities for the base system (`ip`, `iwlist`, `rm`, `umount`, `sysctl`).

## Inference Engine

- **[llama.cpp](https://github.com/ggerganov/llama.cpp)** — C/C++ LLM inference framework. Powers our local model execution.
- **[GGML](https://github.com/ggerganov/ggml)** — Tensor computation library used by llama.cpp for model loading and inference.

## User Interface

- **[Bubble Tea](https://github.com/charmbracelet/bubbletea)** — Go framework for terminal user interfaces.
- **[Lip Gloss](https://github.com/charmbracelet/lipgloss)** — Go library for terminal layout and styling.

## Protocol

- **[Model Context Protocol (MCP)](https://modelcontextprotocol.io)** — Protocol for AI-tool integration.
  - [github.com/modelcontextprotocol](https://github.com/modelcontextprotocol)

## API Compatibility

- **[Ollama](https://github.com/ollama/ollama)** — Our inference API is Ollama-compatible. We do not use Ollama code.

## Media and Hardware

- **[mpv](https://github.com/mpv-player/mpv)** — Video player with DRM direct-rendering mode. Used by display-mcp.
- **[ALSA](https://www.alsa-project.org)** — Advanced Linux Sound Architecture.
  - [github.com/alsa-project](https://github.com/alsa-project)
- **[espeak](https://github.com/rhdunn/espeak)** — Text-to-speech engine. Used by audio-mcp.
- **[mpg123](https://www.mpg123.org)** — MP3 decoder. Used by audio-mcp.
- **[iw](https://git.kernel.org/pub/scm/linux/kernel/git/jberg/iw.git)** — Wireless tool for Wi-Fi scanning.
- **[wpa_supplicant](https://w1.fi/wpa_supplicant/)** — Wi-Fi client for network connections.
- **[dhcpcd](https://www.chronosys.com/pages/dhcpcd.html)** — DHCP client. Used by network-mcp.
- **[libgpiod](https://git.kernel.org/pub/scm/libs/libgpiod/libgpiod.git)** — GPIO character device interface. Used by cognitiveosd for peripheral power management.
- **[udevadm](https://github.com/systemd/systemd)** — Device manager. Used by serial-mcp for device identification.

## Go Libraries

- **[BurntSushi/toml](https://github.com/BurntSushi/toml)** — TOML config file parser. Used by cognitiveosd and cpm.
- **[spf13/cobra](https://github.com/spf13/cobra)** — CLI framework for cpm.
- **[santhosh-tekuri/jsonschema](https://github.com/santhosh-tekuri/jsonschema)** — JSON Schema validator for .cgp manifests in cpm.

## Build Toolchain

- **[Go](https://go.dev)** — Primary programming language.
  - [github.com/golang/go](https://github.com/golang/go)
- **[CMake](https://cmake.org)** — Build system for compiling llama.cpp.
- **[build-base](https://gitlab.alpinelinux.org/alpine/aports)** — Alpine meta-package providing gcc, musl-dev, and other compilation essentials.
- **[apk-tools](https://gitlab.alpinelinux.org/alpine/apk-tools)** — Alpine package manager; also the inspiration for cpm's design.

---

*If we have missed your project, please open a PR.*
