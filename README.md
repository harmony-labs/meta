# meta

[![Build Status](https://img.shields.io/github/actions/workflow/status/yourusername/meta/ci.yml?branch=main)](https://github.com/yourusername/meta/actions)
[![Version](https://img.shields.io/github/v/release/yourusername/meta)](https://github.com/yourusername/meta/releases)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![Crates.io](https://img.shields.io/crates/v/meta)](https://crates.io/crates/meta)
[![Docs](https://img.shields.io/badge/docs-online-blue)](https://docs.rs/meta)

`meta` is a **powerful, extensible, general-purpose CLI platform** built in Rust. It enables engineers to **run any command across many directories** with ease, and extend functionality via a flexible plugin system.

---

![meta CLI Screenshot](docs/assets/meta-cli-screenshot.png)
<!-- If no screenshot is available, replace with: -->
<!-- ![meta CLI Screenshot Placeholder](https://via.placeholder.com/800x200?text=meta+CLI+Screenshot) -->

---

## Table of Contents

- [Key Features](#key-features)
- [How It Works](#how-it-works)
- [Multi-Repo Clone UI](#multi-repo-clone-ui)
- [Installation](#installation)
- [Quick Start](#quick-start)
- [Extending meta with Plugins](#extending-meta-with-plugins)
- [Loop System](docs/loop.md)
  - [loop_cli](loop_cli/README.md)
  - [loop_lib](loop_lib/README.md)
  - [Loop Advanced Usage](docs/loop_advanced_usage.md)
  - [Loop Architecture](docs/loop_architecture_overview.md)
  - [Loop FAQ](docs/loop_faq_troubleshooting.md)
  - [Loop Visual Assets](docs/assets/loop_README.md)
- [Advanced Usage Guide](docs/advanced_usage.md)
- [Plugin Development Guide](docs/plugin_development.md)
- [Architecture Overview](docs/architecture_overview.md)
- [Roadmap](#roadmap)
- [Contributing](docs/contributing.md)
- [FAQ / Troubleshooting](docs/faq_troubleshooting.md)
- [Visual Assets](docs/assets/README.md)
- [Community & Support](#community--support)
- [Security Policy](#security-policy)
- [Acknowledgments](#acknowledgments)
- [License](#license)

---
### Documentation

- **[Advanced Usage Guide](docs/advanced_usage.md):** Power-user features, filtering, scripting, and customization.
- **[Plugin Development Guide](docs/plugin_development.md):** How to create, test, and publish plugins.
- **[Architecture Overview](docs/architecture_overview.md):** System design, key modules, and extensibility.
- **[FAQ / Troubleshooting](docs/faq_troubleshooting.md):** Common issues and solutions.
- **[Contribution Guide](docs/contributing.md):** How to contribute to the project.
- **[Visual Assets](docs/assets/README.md):** Screenshots, diagrams, and GIFs for documentation.
---

## Key Features

- **Run any command** across multiple directories using a fast, portable Rust CLI.
- **Loop-powered core**: commands like `meta git status` work out of the box, running `git status` in all relevant directories.
- **Slim, powerful plugins**: extend or override commands for complex workflows (e.g., `meta git clone`, `meta git update`).
- **Filtering options**: target specific directories with `--include-only` and `--exclude`.
- **Cross-platform**: works on macOS, Linux, and Windows.
- **Immediate utility**, but **powerfully extensible**.

---

## Loop System

The **loop** system is a powerful CLI utility included with meta for running any shell command in multiple repositories or directories in parallel. It is ideal for monorepos and multi-package projects, making repetitive tasks like dependency management, testing, and code generation fast and easy.

- By default, `loop` runs your command in all child repositories of the current directory.
- You can use expressive CLI options or a `.looprc` config file to control exactly where your command will run.
- Developers can also use the underlying [loop_lib](loop_lib/README.md) Rust library to leverage loop's capabilities programmatically, including directory filtering and config parsing.

**Example usage:**
```sh
loop git status
loop npm install
loop cargo test
```

- To include or exclude specific directories, use CLI options (see [loop_cli/README.md](loop_cli/README.md)).
- To set persistent defaults, create a `.looprc` file in your project root.

**Loop Documentation:**
- [Loop Overview](docs/loop.md)
- [Loop Advanced Usage](docs/loop_advanced_usage.md)
- [Loop Architecture](docs/loop_architecture_overview.md)
- [Loop FAQ / Troubleshooting](docs/loop_faq_troubleshooting.md)
- [Loop Visual Assets](docs/assets/loop_README.md)
- [loop_cli – CLI Usage](loop_cli/README.md)
- [loop_lib – Rust Library](loop_lib/README.md)

---

## How It Works

- Define your project structure in an optional `.meta` JSON file:

```json
{
  "projects": {
    "repo1": "./path/to/repo1",
    "repo2": "./path/to/repo2"
  }
}
```

- Run commands across all projects:

```bash
meta git status
meta pwd
meta ls -la
```

- The **loop engine** executes these commands in all specified directories.

- Use **filters** to narrow scope:

```bash
meta git status --include-only repo1,repo2
meta npm install --exclude legacy-repo
```

---

## Multi-Repo Clone UI

The `meta git clone` command provides:

- **Parallel cloning** of all child repositories.
- **Live, per-repo spinners** showing current git output.
- **Styled, emoji-prefixed phase messages** for resolving, fetching, linking, and cloning.
- **Graceful skipping** of existing directories.
- Built with **Indicatif** and **Console** libraries for a polished CLI experience.

Example output:

```
[1/4] 🔍  Resolving meta manifest...
[2/4] 🚚  Fetching meta repository...
[3/4] 🔗  Linking child repositories...
[4/4] 📃  Cloning child repositories...
[1/12] ⠄ Cloning plugins/meta-init
[2/12] ⠄ Cloning plugins/meta-exec
[1/12]   Cloned plugins/meta-init
[2/12]   Cloned plugins/meta-exec
...
```

---

## Installation

Download the latest release for your platform from the [GitHub Releases](https://github.com/yourusername/meta/releases) page.

Or install from source:

```bash
cargo install meta
```

---

## Quick Start

1. **Install meta** (see [Installation](#installation)).
2. **Initialize your meta project** (optional):

   ```bash
   meta init
   ```

3. **Add your repositories** to `.meta`:

   ```json
   {
     "projects": {
       "repo1": "./path/to/repo1",
       "repo2": "./path/to/repo2"
     }
   }
   ```

4. **Run a command across all repos**:

   ```bash
   meta git status
   ```

5. **Clone all child repos**:

   ```bash
   meta git clone
   ```

6. **See help for more commands**:

   ```bash
   meta --help
   ```

![meta CLI in action](docs/assets/meta-cli-demo.gif)
<!-- If no GIF is available, use a placeholder: -->
<!-- ![meta CLI Demo Placeholder](https://via.placeholder.com/800x200?text=meta+CLI+Demo) -->

---

## Extending meta with Plugins

- Plugins can be **compiled Rust crates** or **external executables/scripts**.
- Plugins are **discovered automatically** from:
  - `.meta-plugins` in the current directory
  - `.meta-plugins` in each parent directory up to the filesystem root
  - `.meta-plugins` in your home directory
  - System PATH

  When you run `meta` with the `--verbose` flag, it will print every location searched for plugins and indicate when a plugin directory is found and loaded. If a plugin fails to load, a clear error message (including the path and error) will be printed, but discovery will continue for other plugins.
- Plugins can **add, override, or extend** commands.
- Example plugin commands:
  - `meta git clone` — clone the meta repo and **all child repos in parallel**, with an interactive multi-progress UI showing per-repo status.
  - `meta git update` — pull latest changes across all repos.
  - `meta project sync` — interactive sync wizard.
  - `meta cargo build` — run `cargo build` only in directories with a `Cargo.toml`.
  - `meta cargo test` — run tests across all Rust crates.

Most commands **just work** via the loop engine. Plugins are for **specialized orchestration** with interactive feedback.

---

## Plugin Development Guide

For a detailed guide on writing plugins, see [Plugin Help & Clone Design](docs/plugin_help_and_clone_design.md).

---

## Roadmap

- Core CLI + plugin system (in progress)
- Foundational plugins (`meta-git`, `meta-npm`, `meta-project`)
- Cross-platform builds and distribution
- Future: GUI for visual management

See [VISION_PLAN.md](.context/VISION_PLAN.md) for full details.

---

## Contributing

Contributions welcome! Please see our [Contributing Guide](CONTRIBUTING.md).

---

## Community & Support

- **Chat:** [Discord](https://discord.gg/your-invite) | [Gitter](https://gitter.im/yourusername/meta)
- **Discussions:** [GitHub Discussions](https://github.com/yourusername/meta/discussions)
- **Issue Tracker:** [GitHub Issues](https://github.com/yourusername/meta/issues)
- **Twitter:** [@yourusername](https://twitter.com/yourusername)

---

## Security Policy

If you discover a security vulnerability, please **do not open a public issue**. Instead, report it privately by emailing [security@yourdomain.com](mailto:security@yourdomain.com). We will respond promptly and coordinate a fix.

---

## FAQ / Troubleshooting

**Q: meta command not found?**
A: Ensure `$HOME/.cargo/bin` is in your PATH, or use the full path to the binary.

**Q: How do I add a new plugin?**
A: Place the plugin binary or script in `.meta-plugins` or a directory in your PATH.

**Q: Why does meta not find my repos?**
A: Check your `.meta` file for correct paths and structure.

**Q: How do I run a command only in some repos?**
A: Use `--include-only repo1,repo2` or `--exclude repo3`.

**Q: Where can I get more help?**
A: See [Community & Support](#community--support).

---

## Acknowledgments

- [Indicatif](https://github.com/console-rs/indicatif) and [Console](https://github.com/console-rs/console) for CLI UI.
- [Rust](https://www.rust-lang.org/) and the Rust community.
- All contributors and plugin authors.

---

## License

MIT License. See [LICENSE](LICENSE).
