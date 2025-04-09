# Implementation Plan for meta-rust

This plan outlines the phased development of the new `meta` CLI platform, emphasizing a **plugin-centric, extensible architecture** from the start.

---

## Phase 1: Core CLI and Plugin System

- Implement the **loop** engine for directory iteration and command execution.
- Design and build the **plugin API** supporting:
  - **Compiled Rust dynamic libraries** (dlopen)
  - **External executables/scripts** (discovered via PATH or plugin directories)
- Implement **plugin discovery and dispatch**:
  - `.meta-plugins` directory in project root
  - User's home directory
  - System PATH
- Support **native commands** (e.g., `meta pwd`) and **plugin commands** seamlessly.
- Implement `.meta` file parsing (JSON) for project structure, but **not required** for all commands.
- Implement **filtering options** (`--include-only`, `--exclude`) for directory targeting.
- Provide clear CLI help, error messages, and usage instructions.
- Ensure robust error handling and logging.

---

## Phase 2: Foundational Plugins

- **meta-git**
  - `meta git clone` clones the meta repo and all child repos.
  - `meta git status`, `meta git checkout`, `meta git update`.
- **meta-npm** and **meta-yarn**
  - Run package manager commands across relevant directories.
- **meta-rust**
  - `meta cargo build`, `meta cargo test`, etc., run only in directories containing a `Cargo.toml`.
  - Enables Rust-specific workflows across many crates.
- **meta-project**
  - `meta project update`: clone missing repos listed in `.meta`.
  - `meta project sync`: interactive sync wizard.
- **meta-exec** (optional fallback)
  - Run arbitrary commands if no specific plugin exists.

---

## Phase 3: Polish and Distribution

- Cross-platform builds (macOS, Linux, Windows).
- Set up CI/CD pipelines (GitHub Actions).
- Package manager distribution (Homebrew, Chocolatey, etc.).
- Documentation, examples, and plugin development guides.
- Interactive modes and command suggestions.

---

## Phase 4: Future Enhancements

- Performance profiling and optimizations.
- Advanced filtering and targeting.
- Plugin marketplace or registry.
- **GUI development** interfacing with core and plugins.
- Integration with cloud services or CI/CD systems.

---

## Additional Details

- Plugins can **add, override, or extend** subcommands.
- CLI designed to **fallback gracefully** if plugins are missing.
- `.meta` file is **optional** for many commands.
- Filtering is a **core feature**.
- Meta-repo management is a **key use case**, but not the sole focus.
- The plugin system is **core from day one**, not a future add-on.

---

## Additional Plugin Architecture Notes

- The plugin system supports **both compiled Rust dynamic libraries** and **external executables/scripts**.
- Plugins primarily **add or override commands**; future support may include **intercepting command dispatch**.
- Plugin discovery precedence: project `.meta-plugins` > user plugin dir > system PATH.
- Plugins run with **full user permissions**; users are responsible for plugin trust.
- The GUI will be developed as a **child repo** within the meta-rust meta repo.

For full vision and architecture details, see [VISION_PLAN.md](./VISION_PLAN.md).

## Summary

This plan prioritizes a **powerful, extensible CLI platform** with a plugin system at its core, immediate utility, and a clear path toward a future GUI and broader ecosystem.

For full vision and architecture details, see [VISION_PLAN.md](./VISION_PLAN.md).
