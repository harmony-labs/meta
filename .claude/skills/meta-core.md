# Meta Core Skill

Core understanding of the meta CLI and this meta repository workspace.

## What is a Meta Repo?

A **meta repository** is a parent repo that manages multiple child repositories. The `.meta` file defines which child repos belong to the workspace:

```json
{
  "projects": {
    "child_name": "git@github.com:org/child_name.git"
  }
}
```

## This Workspace Structure

This is the `meta` CLI tool's own meta repo. It contains:
- Root repo (`.`) - the main meta repo with workspace Cargo.toml
- Child repos - individual crates that are also separate git repos

Use `meta git status` to see all repos and their current state.

## Key Commands

### Execute Command Across All Repos
```bash
meta exec -- <command>
```
Runs any shell command in each repo directory.

### List Projects
```bash
meta projects list
```

### Clone Entire Workspace
```bash
meta git clone <meta-repo-url>
```

## Global Options

| Option | Description |
|--------|-------------|
| `--json` | Output in JSON format (useful for parsing) |
| `--tag <tag>` | Filter projects by tag |
| `--include <project>` | Only include specific project(s) |
| `--exclude <project>` | Exclude specific project(s) |
| `--recursive` | Include nested meta repos |
| `--dry-run` | Preview without executing |

## Building This Project

Since this is a Cargo workspace:

```bash
# Build all crates
cargo build

# Build specific binary
cargo build -p meta
cargo build -p meta_git_cli

# Run tests
cargo test

# Or use make
make build
make test
```

## MCP Tools (when meta-mcp server is running)

- `meta_exec` - Execute command across projects
- `meta_get_config` - Get meta configuration
- `meta_list_projects` - List all projects
- `meta_get_project_path` - Get path for a project
