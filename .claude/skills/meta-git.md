# Meta Git Operations Skill

Multi-repo git operations using the `meta` CLI tool.

## Triggers
- /meta-git
- /sync-repos
- /multi-repo-status

## Commands

### /meta-git status
Show git status across all repositories in the meta workspace.

```bash
meta --json git status
```

### /meta-git sync
Pull latest changes and push local commits across all repos.

```bash
# Pull all repos
meta git pull

# Push all repos with commits
meta git push
```

### /meta-git branch [name]
Create or switch to a branch across all repositories.

```bash
# Create new branch across all repos
meta git checkout -b feature/my-feature

# Switch to existing branch
meta git checkout main
```

### /meta-git commit [message]
Commit staged changes across all dirty repositories with a shared message.

```bash
# Stage all changes
meta git add .

# Commit with message
meta git commit -m "feat: implement new feature"
```

### /meta-git diff
Show diffs across all repositories.

```bash
# Show unstaged diffs
meta git diff

# Show staged diffs
meta git diff --staged
```

## MCP Tools Available

When using the meta-mcp server, these tools are available:

- `meta_git_status` - Get status for all projects
- `meta_git_pull` - Pull changes (supports `rebase: true`)
- `meta_git_push` - Push commits
- `meta_git_fetch` - Fetch from remotes
- `meta_git_diff` - Get diffs (supports `staged: true`)
- `meta_git_branch` - Get branch info including ahead/behind
- `meta_git_add` - Stage files
- `meta_git_commit` - Commit with message
- `meta_git_checkout` - Switch/create branches

## Tag Filtering

All commands support filtering by tag:

```bash
# Only operate on backend repos
meta --tag backend git status

# Pull only frontend repos
meta --tag frontend git pull
```

## Examples

### Sync all repos before starting work
```bash
meta git fetch
meta git pull --rebase
```

### Create feature branch across all repos
```bash
meta git checkout -b feature/user-auth
```

### Commit related changes across multiple repos
```bash
meta git add .
meta git commit -m "feat: add user authentication across services"
meta git push
```

### Check which repos have uncommitted changes
```bash
meta --json git status | jq '.results[] | select(.output | contains("Changes"))'
```
