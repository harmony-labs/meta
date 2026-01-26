# Meta Worktree Skill

Manage isolated git worktree sets for multi-repo tasks. Each worktree set creates parallel working directories with feature branches, perfect for:
- Working on multiple features simultaneously
- CI/CD pipelines needing isolated environments
- Code reviews requiring clean checkouts
- Ephemeral testing environments

## When to Use Worktrees

**Create a worktree when:**
- Working on a feature that spans multiple repos and you need isolation
- Running CI checks or tests that shouldn't affect the primary workspace
- Reviewing a PR in a clean environment
- Investigating an incident at a specific version (`--from-ref`)
- Multiple tasks need to proceed in parallel without branch conflicts

**Skip worktrees for:**
- Quick single-file fixes in one repo
- Read-only exploration or research
- Operations you'll complete in the current session without switching context

## Core Concept

A "worktree set" is a named collection of git worktrees, one per repo, all sharing a branch or task name:

```
.worktrees/
  auth-fix/           # task name
    backend/          # git worktree → main repo's backend/
    frontend/         # git worktree → main repo's frontend/
```

## Creating Worktrees

```bash
# Create worktree set with specific repos
meta worktree create auth-fix --repo backend --repo frontend

# Create with all repos in the workspace
meta worktree create full-task --all

# Specify branch name (default: task name)
meta worktree create my-task --repo api --branch feature/my-feature

# Per-repo branch override
meta worktree create review --repo api:main --repo worker:develop

# Start from a specific tag/SHA
meta worktree create incident-42 --from-ref v2.3.1 --repo api

# Start from a GitHub PR's head branch
meta worktree create review --from-pr org/api#42 --repo api
```

## Agent/CI Features

For headless and multi-agent environments:

```bash
# Mark as ephemeral (for automatic cleanup)
meta worktree create ci-check --all --ephemeral

# Set TTL for automatic expiration
meta worktree create ci-check --all --ttl 1h

# Store custom metadata
meta worktree create ci-check --all --meta agent=review-bot --meta run_id=abc123

# Atomic create + run + destroy
meta worktree exec --ephemeral lint-check --all -- make lint
```

### TTL Formats
- `30s` - seconds
- `5m` - minutes
- `1h` - hours
- `2d` - days
- `1w` - weeks

## Managing Worktrees

```bash
# List all worktree sets
meta worktree list
meta worktree list --json

# Show detailed status of a worktree
meta worktree status auth-fix

# Show diff vs base branch
meta worktree diff auth-fix --base main

# Add a repo to existing worktree
meta worktree add auth-fix --repo another-service
```

## Executing Commands

```bash
# Run command in all repos of a worktree set
meta worktree exec auth-fix -- cargo test

# Filter repos
meta worktree exec auth-fix --include backend -- make build
meta worktree exec auth-fix --exclude legacy -- npm test

# Run in parallel
meta worktree exec auth-fix --parallel -- cargo build
```

## Context Detection

When your cwd is inside a `.worktrees/<name>/` directory, meta automatically scopes commands to the worktree's repos with full feature support:

```bash
cd .worktrees/auth-fix/backend
meta exec -- cargo test       # runs in auth-fix's repos, not primary checkout
meta git status               # plugin dispatch works in worktrees
meta --tag cli exec -- pwd    # tag filtering works in worktrees
meta --parallel exec -- build # parallel execution works in worktrees
```

**Include root repo for full features:** When creating worktrees, include `--repo .` to ensure the `.meta.yaml` config is available inside the worktree. This gives full meta features (tags, plugins, parallel, ignore list) without needing to walk up to the primary checkout:

```bash
meta worktree create auth-fix --repo . --repo backend --repo frontend
```

If root repo is not in the worktree, meta will still find config by walking up to the primary checkout directory.

**Override with `--primary`:** Use `--primary` to bypass worktree context detection and operate on the primary checkout:

```bash
meta exec --primary -- cargo test  # uses primary checkout paths
```

## Cleanup

```bash
# Destroy a worktree set
meta worktree destroy auth-fix

# Force destroy (even with uncommitted changes)
meta worktree destroy auth-fix --force

# Prune expired/orphaned worktrees
meta worktree prune
meta worktree prune --dry-run  # preview without removing
```

## Lifecycle Hooks

Configure hooks in `.meta` to integrate with external systems:

```json
{
  "worktree": {
    "hooks": {
      "post-create": "harmony worktree on-create",
      "post-destroy": "harmony worktree on-destroy",
      "post-prune": "harmony worktree on-prune"
    }
  }
}
```

Hooks receive the worktree entry as JSON on stdin. Hook failures print warnings but don't block operations.

## Centralized Store

All worktree metadata is stored at `~/.meta/worktree.json`:
- Tracks worktrees across all projects on the machine
- Stores ephemeral/TTL status, custom metadata
- Used by `prune` to detect expired worktrees
- Store is optional—commands fall back to filesystem discovery if missing

## GitHub Actions Example

```yaml
steps:
  - name: Review PR
    run: |
      meta worktree exec --ephemeral review-${{ github.run_id }} \
        --from-pr ${{ github.repository }}#${{ github.event.pull_request.number }} \
        --all --json \
        --meta agent=review-bot \
        -- make check
```

## Command Reference

| Command | Description |
|---------|-------------|
| `create <name>` | Create a new worktree set |
| `add <name>` | Add repo(s) to existing worktree |
| `list` | List all worktree sets |
| `status <name>` | Show detailed status |
| `diff <name>` | Show diff vs base branch |
| `exec <name>` | Run command in worktree repos |
| `prune` | Remove expired/orphaned worktrees |
| `destroy <name>` | Remove a worktree set |

### Create Options

| Option | Description |
|--------|-------------|
| `--repo <alias>[:<branch>]` | Add specific repo(s) |
| `--all` | Add all repos |
| `--branch <name>` | Override default branch name |
| `--from-ref <ref>` | Start from tag/SHA |
| `--from-pr <owner/repo#N>` | Start from PR head branch |
| `--ephemeral` | Mark for automatic cleanup |
| `--ttl <duration>` | Time-to-live |
| `--meta <key=value>` | Store custom metadata |

### Exec Options

| Option | Description |
|--------|-------------|
| `--ephemeral` | Atomic create+exec+destroy |
| `--include <repos>` | Only run in specified repos |
| `--exclude <repos>` | Skip specified repos |
| `--parallel` | Run commands concurrently |
