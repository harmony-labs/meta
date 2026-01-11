# meta

[![Build Status](https://img.shields.io/github/actions/workflow/status/harmony-labs/meta/release.yml?branch=main)](https://github.com/harmony-labs/meta/actions)
[![Version](https://img.shields.io/github/v/release/harmony-labs/meta)](https://github.com/harmony-labs/meta/releases)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

`meta` is a **powerful, extensible multi-repository management CLI** built in Rust. It enables engineers to **run any command across many repositories** with ease, and extend functionality via a flexible plugin system.

---

## Table of Contents

- [Key Features](#key-features)
- [Installation](#installation)
- [Quick Start](#quick-start)
- [Configuration](#configuration)
  - [Simple Format (Legacy)](#simple-format-legacy)
  - [Extended Format](#extended-format)
  - [YAML Support](#yaml-support)
  - [Dependency Tracking](#dependency-tracking)
- [Commands](#commands)
- [Filtering](#filtering)
  - [Query DSL](#query-dsl)
- [Snapshots](#snapshots)
- [Plugins](#plugins)
- [MCP Server (AI Integration)](#mcp-server-ai-integration)
- [Claude Code Skills](#claude-code-skills)
- [Loop System](#loop-system)
- [CLI Reference](#cli-reference)
- [Documentation](#documentation)
- [Roadmap](#roadmap)
- [Contributing](#contributing)
- [License](#license)

---

## Key Features

- **Run any command** across multiple repositories using a fast, portable Rust CLI
- **Project tags** for filtering (`--tag backend,api`)
- **YAML and JSON** configuration support
- **Nested meta repos** with `--recursive` flag
- **JSON output** mode for scripting (`--json`)
- **Plugin system** with auto-discovery
- **MCP server** for AI agent integration (29 tools)
- **Multi-repo git operations** including per-repo commit messages
- **Workspace snapshots** for safe batch operations with rollback
- **Query DSL** for filtering repos by state (`dirty:true AND tag:backend`)
- **Dependency tracking** with impact analysis and execution ordering
- **Claude Code skills** for AI-assisted multi-repo workflows
- **Cross-platform**: works on macOS, Linux, and Windows

---

## Installation

### Via Install Script (Recommended)

**macOS/Linux:**
```bash
curl -fsSL https://raw.githubusercontent.com/harmony-labs/meta/main/install.sh | bash
```

**Windows (PowerShell):**
```powershell
irm https://raw.githubusercontent.com/harmony-labs/meta/main/install.ps1 | iex
```

### Via Homebrew (macOS/Linux)

```bash
brew install harmony-labs/tap/meta-cli
```

### Via cargo-binstall

```bash
cargo binstall meta-cli
```

### From Source

```bash
cargo install --git https://github.com/harmony-labs/meta
```

---

## Quick Start

1. **Clone a meta repository:**

   ```bash
   meta git clone https://github.com/org/meta-repo.git
   ```

   This clones the meta repo and all child repositories defined in its `.meta` file.

2. **Run commands across all repos:**

   ```bash
   meta git status
   meta git pull
   meta npm install
   meta cargo test
   ```

3. **Filter by tags:**

   ```bash
   meta git pull --tag backend
   meta npm test --tag frontend,shared
   ```

4. **See help:**

   ```bash
   meta --help
   meta git --help
   ```

---

## Configuration

Meta projects are configured via a `.meta` file (JSON) or `.meta.yaml`/`.meta.yml` (YAML) in the repository root.

### Simple Format (Legacy)

The original format maps project names to repository URLs:

```json
{
  "projects": {
    "api-service": "git@github.com:org/api-service.git",
    "web-app": "git@github.com:org/web-app.git",
    "shared-utils": "git@github.com:org/shared-utils.git"
  }
}
```

This format is still fully supported and works seamlessly.

### Extended Format

The extended format supports tags, custom paths, and dependency tracking:

```json
{
  "projects": {
    "api-service": {
      "repo": "git@github.com:org/api-service.git",
      "tags": ["backend", "rust"]
    },
    "web-app": {
      "repo": "git@github.com:org/web-app.git",
      "path": "apps/web",
      "tags": ["frontend", "typescript"]
    },
    "shared-utils": {
      "repo": "git@github.com:org/shared-utils.git",
      "tags": ["shared"]
    }
  }
}
```

**Extended format fields:**

| Field | Required | Description |
|-------|----------|-------------|
| `repo` | Yes | Git repository URL |
| `path` | No | Custom clone path (defaults to project name) |
| `tags` | No | Array of tags for filtering |

### YAML Support

YAML configuration is supported via `.meta.yaml` or `.meta.yml`:

```yaml
projects:
  api-service:
    repo: git@github.com:org/api-service.git
    tags:
      - backend
      - rust

  web-app:
    repo: git@github.com:org/web-app.git
    path: apps/web
    tags:
      - frontend
      - typescript

  shared-utils: git@github.com:org/shared-utils.git  # Simple format also works
```

**File priority:** `.meta.yaml` > `.meta.yml` > `.meta`

### Dependency Tracking

For advanced workflows like impact analysis and build ordering, extend your configuration with `provides` and `depends_on`:

```yaml
projects:
  shared-utils:
    repo: git@github.com:org/shared-utils.git
    tags: [lib]
    provides: [utils-api]
    depends_on: []

  auth-service:
    repo: git@github.com:org/auth-service.git
    tags: [backend]
    provides: [auth-api]
    depends_on:
      - shared-utils

  api-service:
    repo: git@github.com:org/api-service.git
    tags: [backend]
    depends_on:
      - auth-service
      - utils-api  # Can reference provided items
```

This enables:
- **Impact analysis**: See what's affected when a project changes
- **Execution ordering**: Build/test in correct dependency order
- **Transitive dependencies**: Understand the full dependency graph

### Mixed Format

You can mix simple and extended formats in the same file:

```yaml
projects:
  # Extended format with tags
  api-service:
    repo: git@github.com:org/api-service.git
    tags: [backend]

  # Simple format (legacy)
  legacy-app: git@github.com:org/legacy-app.git
```

---

## Commands

### Core Commands

| Command | Description |
|---------|-------------|
| `meta <command>` | Run any command across all repositories |
| `meta git status` | Git status for all repos |
| `meta git pull` | Pull latest changes |
| `meta git push` | Push commits |
| `meta npm install` | Install npm dependencies |
| `meta cargo test` | Run Rust tests |

### Git Plugin Commands

| Command | Description |
|---------|-------------|
| `meta git clone <url>` | Clone meta repo and all child repos |
| `meta git update` | Pull changes and clone missing repos |
| `meta git setup-ssh` | Configure SSH multiplexing |
| `meta git commit --edit` | Per-repo commit messages via editor |
| `meta git commit -m "msg"` | Same message across all repos |
| `meta git snapshot create <name>` | Create workspace state snapshot |
| `meta git snapshot list` | List available snapshots |
| `meta git snapshot restore <name>` | Restore workspace to snapshot |

### Plugin Management

| Command | Description |
|---------|-------------|
| `meta plugin list` | List installed plugins |
| `meta plugin search <query>` | Search plugin registry |
| `meta plugin install <name>` | Install a plugin |
| `meta plugin uninstall <name>` | Remove a plugin |

### AI Integration

| Command | Description |
|---------|-------------|
| `meta init claude` | Install Claude Code skills for this repo |
| `meta init claude --force` | Reinstall/update Claude Code skills |

---

## Filtering

### By Tag

```bash
# Single tag
meta git pull --tag backend

# Multiple tags (OR logic)
meta npm test --tag frontend,shared
```

### By Directory

```bash
# Include only specific directories
meta git status --include-only api-service,web-app

# Exclude directories
meta npm install --exclude legacy-app
```

### Recursive Processing

```bash
# Process nested meta repositories
meta git status --recursive

# Limit recursion depth
meta git pull --recursive --depth 2
```

### Query DSL

Filter repositories by their git state using a powerful query language:

```bash
# Find repos with uncommitted changes
meta query "dirty:true"

# Find dirty backend repos on main branch
meta query "dirty:true AND tag:backend AND branch:main"

# Find repos ahead of remote
meta query "ahead:true"
```

**Query conditions:**
- `dirty:true/false` - Uncommitted changes
- `branch:<name>` - On specific branch
- `tag:<name>` - Has specific tag
- `ahead:true/false` - Ahead of remote
- `behind:true/false` - Behind remote

Combine with `AND`: `dirty:true AND tag:backend AND branch:main`

---

## Snapshots

Snapshots capture the complete state of all repositories for safe batch operations:

```bash
# Create a snapshot before risky operations
meta git snapshot create before-refactor

# List available snapshots
meta git snapshot list

# Preview what restore would do
meta git snapshot restore before-refactor --dry-run

# Restore workspace to snapshot state
meta git snapshot restore before-refactor
```

**What snapshots capture per repo:**
- Current commit SHA
- Branch name
- Dirty status (auto-stashes uncommitted work on restore)

---

## Plugins

Plugins extend meta with specialized functionality. They are discovered automatically from:

- `.meta-plugins/` in the current directory
- `.meta-plugins/` in parent directories
- `~/.meta-plugins/`
- System PATH (binaries named `meta-*`)

### Built-in Plugins

| Plugin | Commands | Description |
|--------|----------|-------------|
| `git` | `clone`, `status`, `update`, `commit`, `setup-ssh` | Git operations |
| `project` | `check`, `sync`, `update` | Project management |
| `rust` | `build`, `test` | Rust/Cargo commands |

### Plugin Help

```bash
meta git --help
meta project --help
```

---

## MCP Server (AI Integration)

Meta includes an MCP (Model Context Protocol) server for AI agent integration, exposing 29 tools for multi-repo operations.

### Setup

Add to Claude Desktop's `claude_desktop_config.json`:

```json
{
  "mcpServers": {
    "meta": {
      "command": "meta-mcp",
      "args": []
    }
  }
}
```

### Available Tools

**Core:** `meta_list_projects`, `meta_exec`, `meta_get_config`, `meta_get_project_path`

**Git:** `meta_git_status`, `meta_git_pull`, `meta_git_push`, `meta_git_fetch`, `meta_git_diff`, `meta_git_branch`, `meta_git_add`, `meta_git_commit`, `meta_git_checkout`, `meta_git_multi_commit`

**Build:** `meta_detect_build_systems`, `meta_run_tests`, `meta_build`, `meta_clean`

**Discovery:** `meta_search_code`, `meta_get_file_tree`, `meta_list_plugins`

**AI Features:** `meta_query_repos`, `meta_workspace_state`, `meta_analyze_impact`, `meta_execution_order`, `meta_snapshot_create`, `meta_snapshot_list`, `meta_snapshot_restore`, `meta_batch_execute`

See [docs/mcp_server.md](docs/mcp_server.md) for full documentation.

---

## Claude Code Skills

Meta includes purpose-built skills for Claude Code that teach AI agents how to work effectively with multi-repository codebases.

### Installation

```bash
# Install skills to .claude/skills/ in your meta repo
meta init claude

# Force reinstall/update
meta init claude --force
```

### Available Skills

| Skill | Purpose |
|-------|---------|
| `meta-workspace` | Understanding meta repo structure and navigation |
| `meta-git` | Multi-repo git operations, snapshots, SSH optimization |
| `meta-exec` | Command execution model, filtering, parallel execution |
| `meta-plugins` | Plugin system and command interception |

### How Skills Help AI Agents

Skills teach Claude:
- **Use `meta git` instead of `git`** for workspace-wide operations
- **Create snapshots before risky batch changes** for safe rollback
- **Filter by tags** to scope operations appropriately
- **Understand plugin interception** (e.g., `meta git clone` does more than `git clone`)

See [docs/claude_code_skills.md](docs/claude_code_skills.md) for detailed skill documentation.

---

## Loop System

The **loop** system is the underlying engine that runs commands across directories. It can be used standalone:

```bash
loop git status
loop npm install
loop cargo test
```

Configure with `.looprc`:

```
--include repo1,repo2
--exclude legacy
--parallel
```

See [docs/loop.md](docs/loop.md) for details.

---

## Documentation

- **[MCP Server Guide](docs/mcp_server.md)** - AI agent integration
- **[Plugin Development](docs/plugin_development.md)** - Writing plugins
- **[Architecture Overview](docs/architecture_overview.md)** - System design
- **[Advanced Usage](docs/advanced_usage.md)** - Power-user features
- **[FAQ / Troubleshooting](docs/faq_troubleshooting.md)** - Common issues
- **[Loop System](docs/loop.md)** - Loop engine details

---

## CLI Reference

```
Usage: meta [OPTIONS] [COMMAND]...

Arguments:
  [COMMAND]...  Command to run across repositories

Options:
  -c, --config <FILE>       Path to .meta config file
  -t, --tag <TAGS>          Filter by tag(s), comma-separated
  -i, --include <DIRS>      Include only these directories
  -e, --exclude <DIRS>      Exclude these directories
  -r, --recursive           Process nested meta repos
      --depth <N>           Max recursion depth
      --json                Output in JSON format
  -v, --verbose             Verbose output
  -s, --silent              Silent mode
  -h, --help                Print help
  -V, --version             Print version
```

---

## Roadmap

- [x] Core CLI + plugin system
- [x] Git plugin with parallel clone
- [x] YAML configuration support
- [x] Project tags and filtering
- [x] JSON output mode
- [x] Nested meta repos (`--recursive`)
- [x] MCP server for AI agents (29 tools)
- [x] Multi-commit support (`meta git commit --edit`)
- [x] Plugin help system
- [x] Query DSL for advanced filtering
- [x] Workspace snapshots with rollback
- [x] Dependency tracking and impact analysis
- [x] Claude Code skills integration
- [x] Windows support (PowerShell installer)
- [ ] Dependency graph visualization (CLI)
- [ ] GUI for visual management

See [.context/VISION_PLAN.md](.context/VISION_PLAN.md) for full details.

---

## Contributing

Contributions welcome! Please see [CONTRIBUTING.md](CONTRIBUTING.md).

---

## Community & Support

- **Issues:** [GitHub Issues](https://github.com/harmony-labs/meta/issues)
- **Discussions:** [GitHub Discussions](https://github.com/harmony-labs/meta/discussions)

---

## License

MIT License. See [LICENSE](LICENSE).
