# Meta Exec Skill

Execute any command across all repositories in the workspace. Meta extends `loop`, a tool for running commands across directories.

## The Execution Model

`meta exec` runs a command in each repo directory:

```bash
# Run 'make build' in every repo
meta exec -- make build

# Run any shell command
meta exec -- ls -la

# Commands with arguments
meta exec -- npm install --save-dev typescript
```

The `--` separates meta options from the command to execute.

## Shorthand: Direct Commands

Any unrecognized command is passed through to exec:

```bash
# These are equivalent:
meta exec -- make test
meta make test

# These are equivalent:
meta exec -- npm run build
meta npm run build
```

**Exception**: Commands that match plugins (like `git`) are handled by the plugin instead.

## Parallel vs Sequential

By default, commands run sequentially with live output. Use `--parallel` for concurrent execution:

```bash
# Sequential (default) - see output as it happens
meta exec -- cargo build

# Parallel - faster, grouped output after completion
meta git status --parallel
```

Parallel mode:
- Uses rayon thread pool for bounded concurrency
- Shows spinners during execution (if TTY)
- Captures and displays output grouped by repo after completion

## Filtering Options

Control which repos run the command. These options come from `loop`:

```bash
# Only include specific directories (overrides config)
meta git status --include api,worker

# Exclude specific directories (adds to ignores)
meta git push --exclude legacy-service

# Filter by tag (meta-specific, applied before loop filtering)
meta --tag backend exec -- make deploy

# Combine: tag filter + directory filter
meta --tag backend git status --include api
```

**Filter precedence:**
1. `--tag` filters projects by tag (meta level)
2. `--include` limits to specific directories (loop level)
3. `--exclude` removes directories (loop level)

## Dry Run

Preview what would happen without executing:

```bash
meta --dry-run exec -- rm -rf node_modules
```

Shows which repos would run the command, with `[DRY RUN]` prefix.

## JSON Output

Get structured output for parsing:

```bash
meta --json exec -- git rev-parse HEAD
```

Returns JSON with:
```json
{
  "success": true,
  "results": [
    {
      "directory": "./api",
      "command": "git rev-parse HEAD",
      "success": true,
      "exit_code": 0,
      "stdout": "abc123...\n"
    }
  ],
  "summary": {
    "total": 5,
    "succeeded": 5,
    "failed": 0,
    "dry_run": false
  }
}
```

## Silent Mode

Suppress all output:

```bash
meta --silent exec -- npm install
```

## Global Options Reference

| Option | Description |
|--------|-------------|
| `--parallel` | Run commands concurrently |
| `--include <dirs>` | Only run in these directories |
| `--exclude <dirs>` | Skip these directories |
| `--tag <tags>` | Filter by project tag(s) |
| `--dry-run` | Preview without executing |
| `--json` | Structured JSON output |
| `--silent` | Suppress output |
| `--verbose` | Show detailed execution info |
| `--recursive` | Include nested meta repos |

## Practical Examples

### Build Everything
```bash
meta exec -- cargo build --release
```

### Run Tests (Parallel for Speed)
```bash
meta git status --parallel
meta exec -- cargo test --parallel
```

### Update Dependencies Selectively
```bash
# Only frontend repos
meta --tag frontend exec -- npm update

# Exclude slow repos
meta exec -- cargo update --exclude large-monorepo
```

### Find Files Across Repos
```bash
meta exec -- find . -name "*.rs" -type f | head -20
```

### Clean Build Artifacts
```bash
meta exec -- cargo clean
meta exec -- rm -rf node_modules dist
```

## When to Use Exec vs Plugins

| Use `meta exec` | Use Plugin (e.g., `meta git`) |
|-----------------|-------------------------------|
| Generic shell commands | Git operations |
| Build/test commands | Commands needing special handling |
| One-off scripts | Operations with meta-specific logic |
| npm/cargo/make | Clone, update, snapshot |

Plugins intercept command patterns and provide enhanced behavior. `meta git clone` doesn't run `git clone` in each repo—it reads `.meta` and clones the entire graph.

## Worktree Context Detection

When your cwd is inside a `.worktrees/<name>/` directory, `meta exec` automatically scopes to the worktree's repos instead of the primary checkout:

```bash
cd .worktrees/auth-fix/backend
meta exec -- cargo test    # runs in auth-fix's repos

# Override with --primary to use primary checkout paths
meta exec --primary -- cargo test
```

This is filesystem-based detection—no store dependency. See `meta-worktree.md` for full worktree management.
