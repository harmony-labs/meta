# Meta Discovery Skill

Project discovery and listing across multiple repositories using the `meta` CLI tool.

## Triggers
- /meta-discover
- /meta-projects

## Commands

### /meta-discover
List all projects in the meta workspace.

```bash
meta projects list
```

### /meta-projects [tag]
List projects, optionally filtered by tag.

```bash
meta --tag <tag> projects list
```

## MCP Tools Available

When using the meta-mcp server, these tools are available:

- `meta_list_projects` - List all projects with tags
- `meta_get_config` - Get the raw .meta configuration
- `meta_get_project_path` - Get absolute path for a project
- `meta_search_code` - Search code patterns across repos
- `meta_get_file_tree` - Get file tree structure

## Tag Filtering

All commands support filtering by tag:

```bash
# List only backend projects
meta --tag backend projects list

# List only frontend projects
meta --tag frontend projects list
```

## Examples

### List all projects
```bash
meta projects list
```

### List projects with JSON output
```bash
meta --json projects list
```

### List projects with specific tag
```bash
meta --tag backend projects list
```
