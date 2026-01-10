# Meta Git Skill

This is a **meta repository** - a workspace containing multiple child git repositories. Use `meta git` commands instead of plain `git` when operating across the workspace.

## When to Use Meta Git

**Always use `meta git` when:**
- Checking status across all repos: `meta git status`
- Committing changes that span multiple repos
- Pushing/pulling changes across the workspace
- Creating branches for multi-repo features

**Use plain `git` only when:**
- Operating on a single specific repo
- The root meta repo only (`.` directory)

## Essential Commands

### Check Status Across All Repos
```bash
meta git status
```
Shows git status for every repo in the workspace. Use this before committing to see what's changed where.

### Commit and Push All Repos
```bash
# Commit in each repo with the same message
meta git add .
meta git commit -m "feat: description"

# Push all repos
meta git push
```

### Clone a Meta Repo (with all children)
```bash
meta git clone <meta-repo-url>
```
Clones the parent repo and all child repos defined in `.meta`.

### Update All Repos
```bash
meta git update
```
Clones any missing repos and pulls latest changes in parallel.

### Snapshot Before Risky Operations
```bash
# Save current state
meta git snapshot create before-refactor

# Do risky work...

# Restore if needed
meta git snapshot restore before-refactor
```

## Filtering by Project

Use `--tag`, `--include`, or `--exclude` to target specific repos:

```bash
# Only backend repos
meta --tag backend git status

# Exclude a specific repo
meta --exclude meta_mcp git push
```

## Important Behaviors

1. **Output ordering**: Repos report back in parallel, so output order may vary
2. **Failure handling**: One repo failing doesn't stop others
3. **Root repo**: The root meta repo (`.`) is included in all operations

## Common Workflows

### Before Starting Work
```bash
meta git status          # Check for uncommitted changes
meta git pull            # Get latest from all remotes
```

### After Making Changes
```bash
meta git status          # Review what changed
meta git add .           # Stage in all repos
meta git commit -m "..."  # Commit with shared message
meta git push            # Push all repos
```

### Safe Batch Operations
```bash
meta git snapshot create before-changes
# ... make changes ...
meta git snapshot restore before-changes  # if something goes wrong
```
