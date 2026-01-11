# Architecture Overview

This document provides a comprehensive overview of the `meta` CLI platform's architecture, including its core components, plugin system, and data flow.

## Table of Contents

- [System Overview](#system-overview)
- [Workspace Structure](#workspace-structure)
- [Core Components](#core-components)
- [Plugin System](#plugin-system)
- [Command Execution Flow](#command-execution-flow)
- [Data Models](#data-models)
- [Key Modules](#key-modules)
- [Integration Points](#integration-points)
- [See Also](#see-also)

---

## System Overview

`meta` is a modular, extensible multi-repository management CLI built in Rust. It follows a workspace-based architecture with 8 member crates:

```
meta/
├── meta_cli/           # Main CLI entry point (binary: meta)
├── meta_git_cli/       # Git plugin (binary: meta-git)
├── meta_git_lib/       # Git library utilities
├── meta_project_cli/   # Project management plugin (binary: meta-project)
├── meta_rust_cli/      # Rust/Cargo plugin (binary: meta-rust)
├── meta_mcp/           # MCP server for AI integration (binary: meta-mcp)
├── loop_cli/           # Standalone loop CLI (binary: loop)
└── loop_lib/           # Core loop engine library
```

## Workspace Structure

The Cargo workspace enables shared dependencies and coordinated builds:

```toml
[workspace]
members = [
    "loop_cli",
    "loop_lib",
    "meta_cli",
    "meta_git_cli",
    "meta_git_lib",
    "meta_mcp",
    "meta_rust_cli",
    "meta_project_cli",
]
resolver = "2"

[workspace.package]
version = "0.1.0"
edition = "2021"
license = "MIT"
```

## Core Components

### meta_cli

The main CLI entry point responsible for:
- Argument parsing (via clap)
- Configuration loading (`.meta`, `.meta.yaml`, `.meta.yml`)
- Plugin discovery and dispatch
- Filter application (tags, include, exclude)
- Snapshot management
- Query DSL processing
- Dependency graph analysis

Key modules:
- `main.rs` - Entry point, argument parsing
- `config.rs` - Configuration loading and parsing
- `subprocess_plugins.rs` - Plugin discovery and execution
- `snapshots.rs` - Workspace snapshot functionality
- `query.rs` - Query DSL implementation
- `dependency_graph.rs` - Dependency tracking and analysis
- `registry.rs` - Plugin registry client
- `init.rs` - Claude Code skills installation

### loop_lib

The core execution engine that runs commands across directories:
- Directory expansion and filtering
- Parallel/sequential execution
- Output aggregation
- Error handling and reporting

Used by both `meta_cli` and `loop_cli`.

### loop_cli

Standalone CLI for the loop engine:
- Direct command execution without meta overhead
- `.looprc` configuration support
- Useful for non-meta multi-directory operations

### meta_git_cli

Git plugin providing:
- Queue-based recursive cloning
- Workspace snapshots
- SSH multiplexing setup
- Standard git operation passthrough

### meta_git_lib

Shared git utilities:
- Repository status queries
- Branch management
- Clone operations

### meta_mcp

MCP (Model Context Protocol) server exposing 29 tools:
- Core operations (list, exec, config)
- Git operations (status, pull, push, commit, etc.)
- Build/test operations
- Discovery tools (search, file tree)
- AI-dominance features (query, impact analysis, snapshots)

### meta_project_cli

Project management plugin:
- Project health checks
- Configuration sync
- Missing repo detection

### meta_rust_cli

Rust/Cargo plugin:
- Workspace-aware builds
- Test execution
- Cargo command passthrough

## Plugin System

### Discovery

Plugins are discovered from:
1. `.meta-plugins/` in current directory
2. Parent directories' `.meta-plugins/`
3. `~/.meta-plugins/` in home directory
4. System PATH (executables named `meta-*`)

Dual naming support: `meta-git` or `meta_git_cli`

### Protocol

Plugins communicate via JSON over stdin/stdout:

**Plugin Info Request:**
```bash
meta-git --meta-plugin-info
```

**Response:**
```json
{
  "name": "git",
  "version": "0.1.0",
  "description": "Git operations for meta repositories",
  "commands": ["clone", "status", "update", "commit", "snapshot"]
}
```

**Execution Request:**
```bash
echo '{"command":"status","args":[],"projects":[...]}' | meta-git --meta-plugin-exec
```

**Response:**
```json
{
  "success": true,
  "results": [
    {"project": "api", "success": true, "output": "..."}
  ]
}
```

### Interception Model

When you run `meta <command>`:

1. **Check for plugin** - Does a plugin handle this command pattern?
2. **If plugin exists** - Route to plugin with project list and filters
3. **If no plugin** - Fall back to `loop_lib` execution

Special case commands (like `meta git clone`) are fully handled by the plugin rather than passed through to all repos.

## Command Execution Flow

```
User: meta git status --tag backend
              │
              ▼
    ┌─────────────────────┐
    │     meta_cli        │
    │  (parse arguments)  │
    └─────────────────────┘
              │
              ▼
    ┌─────────────────────┐
    │  Load Configuration │
    │  (.meta/.meta.yaml) │
    └─────────────────────┘
              │
              ▼
    ┌─────────────────────┐
    │   Apply Filters     │
    │  (tags, include,    │
    │   exclude)          │
    └─────────────────────┘
              │
              ▼
    ┌─────────────────────┐
    │  Plugin Discovery   │
    │  (find meta-git)    │
    └─────────────────────┘
              │
              ▼
    ┌─────────────────────┐
    │  Plugin Execution   │
    │  (JSON over stdio)  │
    └─────────────────────┘
              │
              ▼
    ┌─────────────────────┐
    │  Output Aggregation │
    │  (human or JSON)    │
    └─────────────────────┘
```

For non-plugin commands:

```
User: meta npm install --tag frontend
              │
              ▼
    ┌─────────────────────┐
    │     meta_cli        │
    └─────────────────────┘
              │
              ▼
    ┌─────────────────────┐
    │  No Plugin Match    │
    │  (fall back to      │
    │   loop_lib)         │
    └─────────────────────┘
              │
              ▼
    ┌─────────────────────┐
    │    loop_lib::run    │
    │  (parallel/serial   │
    │   execution)        │
    └─────────────────────┘
              │
              ▼
    ┌─────────────────────┐
    │  Per-Directory Exec │
    │  (npm install in    │
    │   each repo)        │
    └─────────────────────┘
```

## Data Models

### Project Configuration

```rust
pub struct MetaConfig {
    pub projects: HashMap<String, ProjectEntry>,
    pub ignore: Option<Vec<String>>,
}

pub enum ProjectEntry {
    Simple(String),  // Just URL
    Extended {
        repo: String,
        path: Option<String>,
        tags: Option<Vec<String>>,
        provides: Option<Vec<String>>,
        depends_on: Option<Vec<String>>,
    },
}
```

### Workspace Snapshot

```rust
pub struct WorkspaceSnapshot {
    pub name: String,
    pub created_at: DateTime<Utc>,
    pub description: Option<String>,
    pub projects: HashMap<String, ProjectSnapshot>,
}

pub struct ProjectSnapshot {
    pub sha: String,
    pub branch: String,
    pub dirty: bool,
}
```

### Query Condition

```rust
pub enum QueryCondition {
    Dirty(bool),
    Branch(String),
    Tag(String),
    Ahead(bool),
    Behind(bool),
    ModifiedIn(Duration),
    Language(String),
}

pub struct Query {
    pub conditions: Vec<QueryCondition>,  // AND-combined
}
```

### Dependency Graph

```rust
pub struct DependencyGraph {
    pub projects: HashMap<String, ProjectDependencies>,
}

pub struct ProjectDependencies {
    pub provides: Vec<String>,
    pub depends_on: Vec<String>,
}
```

## Key Modules

| Module | Purpose |
|--------|---------|
| `meta_cli/src/main.rs` | CLI entry, arg parsing |
| `meta_cli/src/config.rs` | Config loading |
| `meta_cli/src/subprocess_plugins.rs` | Plugin discovery/execution |
| `meta_cli/src/snapshots.rs` | Workspace snapshots |
| `meta_cli/src/query.rs` | Query DSL |
| `meta_cli/src/dependency_graph.rs` | Dependency analysis |
| `meta_cli/src/registry.rs` | Plugin registry |
| `meta_cli/src/init.rs` | Skills installation |
| `loop_lib/src/lib.rs` | Core loop engine |
| `meta_git_cli/src/lib.rs` | Git plugin logic |
| `meta_mcp/src/main.rs` | MCP server |

## Integration Points

### meta_cli ↔ loop_lib

The main CLI uses loop_lib for directory iteration and command execution when no plugin handles the command.

### meta_cli ↔ subprocess_plugins

Plugin manager discovers, validates, and executes plugins via subprocess communication.

### meta_cli ↔ snapshots

Snapshot module captures and restores workspace state for safe batch operations.

### meta_cli ↔ query

Query module parses DSL strings and filters projects by git state.

### meta_cli ↔ dependency_graph

Dependency graph enables impact analysis and topological sorting for build ordering.

### meta_mcp ↔ All

MCP server exposes all functionality to AI agents via JSON-RPC protocol.

### meta_git_cli ↔ meta_git_lib

Git plugin uses shared library for repository operations.

## See Also

- [Plugin Development Guide](plugin_development.md)
- [Advanced Usage Guide](advanced_usage.md)
- [MCP Server Documentation](mcp_server.md)
- [FAQ / Troubleshooting](faq_troubleshooting.md)
