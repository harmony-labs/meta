# Meta Safety Skill

Multi-repo workspaces are powerful but require awareness. Meta gives you precision tools to operate on exactly what you need, saving turns and avoiding unintended changes.

## Session Start

1. `meta project list --json` — workspace map in one call
2. `meta git status` — see state of all repos at once
3. Note which repos provide shared dependencies (check `.meta.yaml` for `provides`/`depends_on`)

## Precision Operations

Instead of cd-ing into repos one by one, use meta flags to target exactly what you need:

```bash
# Target specific repos
meta --include repo1,repo2 exec -- command

# Target by tag
meta --tag backend exec -- cargo test

# Exclude repos
meta --exclude legacy exec -- npm update

# Dependency-aware order
meta --ordered exec -- cargo build

# Combine: tagged repos, in order, excluding one
meta --tag backend --exclude legacy --ordered exec -- make deploy
```

## Before Modifying Shared Code

When modifying a repo that other repos depend on:

1. **Check dependents**: Use `meta_analyze_impact <repo-name>` (MCP tool) to see transitive dependents
2. **Plan cascading changes**: If `meta_core` changes, repos that depend on it may need updates
3. **Build in order**: `meta --ordered exec -- cargo build` respects the dependency graph

## Efficient Commits

```bash
# Commit in exactly the repos you modified
meta --include repo1,repo2 git commit -m "feat: update shared API"

# Push only tagged repos
meta --tag backend git push

# Per-repo commit messages (when changes differ)
# Use meta_git_multi_commit MCP tool
```

## Query DSL (MCP)

The `meta_query_repos` MCP tool filters repos by state:

| Query | Result |
|-------|--------|
| `dirty:true` | Repos with uncommitted changes |
| `tag:backend` | Repos tagged "backend" |
| `dirty:true AND tag:backend` | Combine filters |
| `branch:feature-x` | Repos on a specific branch |

## Worktree Strict Mode

When creating worktrees from a specific ref (tag/SHA/branch), use `--strict` in CI/automation contexts where you need all-or-nothing behavior:

```bash
# Without --strict: warns but continues if some repos lack the ref
meta worktree create feature-test --from-ref v2.0.0 --all

# With --strict: fails immediately if ANY repo lacks the ref
meta worktree create feature-test --from-ref v2.0.0 --all --strict
```

**When to use --strict:**
- CI pipelines testing a specific release tag across all repos
- Automated scripts that require consistent state
- Debugging scenarios where partial worktrees would be misleading

**When NOT to use --strict:**
- Interactive development (warnings are usually sufficient)
- Working with repos that legitimately don't have the ref
- Exploratory work where partial context is acceptable

## Efficiency Tips

- One `meta git status` replaces N individual `git status` calls
- One `meta --tag X exec -- cmd` replaces N `cd && cmd` sequences
- `meta_analyze_impact` before modifying providers prevents cascading fix-up commits
- `meta --ordered exec -- cargo build` builds in correct dependency order automatically
- `meta --dry-run exec -- dangerous-cmd` previews before executing