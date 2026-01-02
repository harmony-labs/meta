# Meta Core Skill

Core meta repository operations using the `meta` CLI tool.

## Triggers
- /meta
- /meta-exec
- /meta-clone

## Commands

### /meta exec [command]
Execute a command across all repositories.

```bash
meta exec -- <command>
```

### /meta clone
Clone all repositories defined in .meta.

```bash
meta clone
```

### /meta plugins
List installed plugins.

```bash
meta plugins list
```

## MCP Tools Available

When using the meta-mcp server, these tools are available:

- `meta_exec` - Execute command across projects
- `meta_get_config` - Get meta configuration
- `meta_list_projects` - List all projects
- `meta_get_project_path` - Get path for a project
- `meta_list_plugins` - List installed plugins

## Global Options

All meta commands support these global options:

| Option | Description |
|--------|-------------|
| `--json` | Output in JSON format |
| `--tag <tag>` | Filter projects by tag |
| `--include <project>` | Include specific project(s) |
| `--exclude <project>` | Exclude specific project(s) |
| `--recursive` | Include nested meta repos |

## Tag Filtering

All commands support filtering by tag:

```bash
# Execute on backend repos only
meta --tag backend exec -- <command>

# Clone only frontend repos
meta --tag frontend clone
```

## Examples

### Execute command across all repos
```bash
meta exec -- ls -la
```

### Execute with JSON output
```bash
meta --json exec -- git rev-parse HEAD
```

### Execute on specific tagged projects
```bash
meta --tag backend exec -- make build
```

### Clone all repositories
```bash
meta clone
```

### Clone with specific tag
```bash
meta --tag backend clone
```

### List plugins
```bash
meta plugins list
```

### Recursive operations on nested meta repos
```bash
meta --recursive git status
```
