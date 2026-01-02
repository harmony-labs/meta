# Meta Build Skill

Execute build and test commands across multiple repositories using the `meta` CLI tool.

## Triggers
- /meta-build
- /meta-test

## Commands

### /meta-build [command]
Execute a build command across all repositories.

```bash
meta exec -- <build-command>
```

### /meta-test [command]
Execute a test command across all repositories.

```bash
meta exec -- <test-command>
```

## MCP Tools Available

When using the meta-mcp server, these tools are available:

- `meta_exec` - Execute any command across projects
- `meta_detect_build_systems` - Detect build systems per project (Cargo, npm, make, go, maven, gradle, python)

## Tag Filtering

All commands support filtering by tag:

```bash
# Build only backend repos
meta --tag backend exec -- <build-command>

# Test only frontend repos
meta --tag frontend exec -- <test-command>
```

## Examples

### Execute build across all repos
```bash
meta exec -- make build
```

### Execute tests across all repos
```bash
meta exec -- make test
```

### Execute with JSON output for parsing
```bash
meta --json exec -- make test
```

### Execute on specific tagged projects
```bash
meta --tag backend exec -- make build
```
