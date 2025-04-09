# meta

`meta` is a **powerful, extensible, general-purpose CLI platform** built in Rust. It enables engineers to **run any command across many directories** with ease, and extend functionality via a flexible plugin system.

---

## Key Features

- **Run any command** across multiple directories using a fast, portable Rust CLI.
- **Loop-powered core**: commands like `meta git status` work out of the box, running `git status` in all relevant directories.
- **Slim, powerful plugins**: extend or override commands for complex workflows (e.g., `meta git clone`, `meta git update`).
- **Filtering options**: target specific directories with `--include-only` and `--exclude`.
- **Cross-platform**: works on macOS, Linux, and Windows.
- **Immediate utility**, but **powerfully extensible**.

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

## Extending meta with Plugins

- Plugins can be **compiled Rust crates** or **external executables/scripts**.
- Plugins are **discovered automatically** from:
  - `.meta-plugins` in your project
  - Your home directory
  - System PATH
- Plugins can **add, override, or extend** commands.
- Example plugin commands:
  - `meta git clone` — clone the meta repo and **all child repos in parallel**, with an interactive multi-progress UI showing per-repo status.
  - `meta git update` — pull latest changes across all repos.
  - `meta project sync` — interactive sync wizard.
  - `meta cargo build` — run `cargo build` only in directories with a `Cargo.toml`.
  - `meta cargo test` — run tests across all Rust crates.

Most commands **just work** via the loop engine. Plugins are for **specialized orchestration** with interactive feedback.

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


---

## Installation

Download the latest release for your platform from the [GitHub Releases](https://github.com/yourusername/meta/releases) page.

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

## License

MIT License. See [LICENSE](LICENSE).
