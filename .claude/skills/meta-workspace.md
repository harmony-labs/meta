# Meta Workspace Skill

This project is a **meta repository** - a parent repo that manages a graph of child repositories. Understanding this structure is essential for effective operation.

## Starting a Session

When you begin working in a meta repo, discover its structure:

```bash
meta project list --json
```

This returns repos, paths, and tags. Use this to:
- Know which repos exist before making changes
- Identify available tags for filtering operations
- Understand the project graph

Run `meta git status` to see the current state across all repos.

## Why This Matters for You (Claude)

In a meta repo, changes often span multiple repositories. Using `meta` commands instead of plain `git` lets you:
- **Operate on all repos with one command** - fewer tool calls, less context
- **Maintain consistency** - same commit message, same branch across repos
- **Never miss a repo** - meta tracks them all

## The .meta File

The `.meta` file defines child repositories:

```json
{
  "projects": {
    "api": "git@github.com:org/api.git",
    "web": {
      "repo": "git@github.com:org/web.git",
      "path": "./frontend/web",
      "tags": ["frontend", "typescript"]
    }
  }
}
```

**Simple format**: `"name": "git-url"` - clones to `./name`
**Extended format**: Object with `repo`, optional `path`, optional `tags`

YAML is also supported (`.meta.yaml` or `.meta.yml`).

## Discovering What's Here

```bash
# List all projects in this workspace
meta project list

# See git status across ALL repos at once
meta git status
```

## Filtering by Tag

When projects have tags, filter operations:

```bash
# Only frontend repos
meta --tag frontend git status

# Multiple tags (comma-separated)
meta --tag backend,api exec -- make test

# Exclude specific repos
meta --exclude legacy-service git pull
```

## Nested Meta Repos

Meta repos can contain other meta repos. Use `--recursive` to operate on the entire graph:

```bash
# Clone a meta repo and ALL nested meta repos
meta git clone <url> --recursive

# Status across entire graph
meta --recursive git status
```

The `--depth N` flag limits recursion depth.

## Key Commands Quick Reference

| Command | What It Does |
|---------|--------------|
| `meta git status` | Git status in ALL repos |
| `meta git clone <url>` | Clone meta repo + all children |
| `meta exec -- <cmd>` | Run command in all repos |
| `meta project list` | List all child projects |
| `meta init claude` | Install these skills |

## When Working in This Repo

1. **Always check `meta git status`** before starting work
2. **Use `meta git` for multi-repo operations** - it's one command vs N commands
3. **Create snapshots before risky batch operations** - `meta git snapshot create <name>`
4. **Commit related changes together** - `meta git commit -m "message"` commits in all dirty repos
