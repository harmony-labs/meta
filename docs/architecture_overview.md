# Architecture Overview

This document provides a high-level overview of the `meta` CLI platform's architecture, including its core components, extensibility points, and system design.

## Table of Contents

- [System Overview](#system-overview)
- [Core Components](#core-components)
- [Plugin System](#plugin-system)
- [Command Execution Flow](#command-execution-flow)
- [Extensibility Points](#extensibility-points)
- [Key Modules](#key-modules)
- [Visual Overview](#visual-overview)
- [See Also](#see-also)

---

## System Overview

`meta` is a modular, extensible CLI platform built in Rust. It enables users to run commands across multiple directories and extend functionality via plugins.

## Core Components

- **meta_cli**: The main CLI entry point, responsible for parsing arguments and dispatching commands.
- **loop_engine**: Executes commands in parallel across multiple directories.
- **meta_plugin_api**: Defines the interface for plugin integration.
- **.meta file**: Optional project manifest describing repositories and structure.

## Plugin System

Plugins are first-class citizens in `meta`:
- Discovered from `.meta-plugins`, user home, or system PATH.
- Can be Rust binaries, scripts, or any executable.
- Can add, override, or extend commands.

See [Plugin Development Guide](plugin_development.md) for details.

## Command Execution Flow

1. User invokes a `meta` command.
2. CLI parses arguments and determines the target command.
3. If a plugin matches, it is executed; otherwise, the loop engine runs the command in all relevant directories.
4. Output is aggregated and presented to the user.

## Extensibility Points

- **Plugins**: Add new commands or override existing ones.
- **Filters**: Control which directories are targeted.
- **Hooks**: (Planned) Allow plugins to hook into command execution phases.

## Key Modules

- **meta_cli/**: CLI logic and argument parsing.
- **loop_lib/**: Core loop engine for multi-directory execution.
- **meta_plugin_api/**: Plugin interface and utilities.
- **meta_project_cli/**: Project management commands.
- **meta_git_cli/**, **meta_rust_cli/**: Example plugin implementations.

## Visual Overview

> **Visual assets such as architecture diagrams and flowcharts should be placed in [docs/assets/](assets/).**
> If not available, see [Visual Assets](assets/README.md) for instructions on adding diagrams and screenshots.

## See Also

- [Advanced Usage Guide](advanced_usage.md)
- [Plugin Development Guide](plugin_development.md)
- [FAQ / Troubleshooting Guide](faq_troubleshooting.md)