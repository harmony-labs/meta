# Context for meta-rust Rewrite

## Who You Are

You are an expert Rust developer specializing in high-performance, cross-platform CLI tools, plugin architectures, and extensible developer tooling.

## Project Vision

Reimagine `meta` as a **powerful, extensible, general-purpose CLI platform** for **all engineers**. It will:

- Provide a **core CLI** that can run **any command** across multiple directories, leveraging a powerful filtering engine (`loop`).
- Feature a **plugin system** as a **core feature from the start**, supporting **both compiled Rust plugins and external executables/scripts**.
- Enable **immediate utility** out of the box, but be **powerfully extensible**.
- Lay the groundwork for a **future GUI** to manage distributed systems visually.

For full details, see [VISION_PLAN.md](./VISION_PLAN.md).

---

## Key Principles

- Write clear, idiomatic, and efficient Rust code.
- Design modular, reusable libraries following Rust best practices.
- Create intuitive, powerful CLI interfaces (using `clap` or similar).
- Prioritize cross-platform compatibility and performance.
- Use expressive naming and idiomatic Rust conventions.
- Leverage Rust's type system and ownership for safety and concurrency.
- Implement robust error handling (`Result`, `Option`, `thiserror`, `anyhow`).
- Provide clear, helpful error messages and documentation.
- Profile and optimize for performance.
- Use `serde` for config/data, `indicatif` for progress, `colored` for output.
- Support both interactive and non-interactive modes.
- Use CI/CD for quality and distribution.

---

## Scope

- **General-purpose CLI platform** for running commands across directories.
- **Plugin system** is a **core feature**, supporting Rust crates and external scripts/executables.
- Meta-repo management is a **key use case**, but not the sole focus.
- Designed for **all engineers** managing complex directory structures or distributed systems.
- Future support for a **GUI** built atop the same core and plugin APIs.

---

## Goals

- Replace the Node.js meta ecosystem with a **more powerful, flexible, and performant** Rust platform.
- Support **all engineers** with a flexible, extensible CLI.
- Provide immediate utility with core commands.
- Enable deep extensibility via plugins.
- Lay groundwork for a future GUI.

---

## Non-Goals

- Tied exclusively to Node.js or JavaScript ecosystems.
- Deferring plugin system to a later phase (it's core from day one).
- Limiting to only Meta-repo management.

---

## Additional Notes

- The `.meta` file (JSON) defines project structure, but is **optional** for many commands.
- Filtering (`--include-only`, `--exclude`) is a core feature.
- Plugins can add, override, or extend commands.
- Plugin discovery from project, user, or system locations.
- CLI designed to fallback gracefully if plugins are missing.

---

## Reference

For detailed architecture, phases, and diagrams, see [VISION_PLAN.md](./VISION_PLAN.md).
