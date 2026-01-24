# Claude Code Skills for Meta

Meta includes four purpose-built Claude Code skills that teach AI agents how to work effectively with multi-repository codebases. These skills are pedagogical—they explain HOW to work in a meta repo, not just WHAT commands exist.

## Installation

Install skills via the `meta init` command:

```bash
# Install skills to .claude/skills/
meta init claude

# Force reinstall/update existing skills
meta init claude --force
```

Skills are installed to `.claude/skills/` in your meta repository and are automatically discovered by Claude Code.

## Available Skills

### meta-workspace - Understanding Meta Repos

**Purpose:** Teaches Claude about meta repository structure and why multi-repo commands matter.

**Key concepts covered:**
- The `.meta` file structure (JSON and YAML formats)
- Simple vs extended project formats
- Tag-based filtering
- Nested meta repos and recursive operations
- Why `meta git` is better than `git` in workspaces

**When Claude should reference this skill:**
- When first entering a meta repository
- When asked about project structure
- When confused about repo relationships

### meta-git - Git Operations

**Purpose:** Multi-repo git operations with special attention to snapshots and safe batch changes.

**Key concepts covered:**
- `meta git clone` and its queue-based recursive cloning
- `meta git update` for syncing workspaces
- Snapshot create/list/restore workflow
- SSH optimization with `setup-ssh`
- Safe workflow patterns (status → snapshot → work → commit)

**When Claude should reference this skill:**
- Before any multi-repo git operation
- When making batch changes across repos
- When needing to undo workspace-wide changes

### meta-exec - Execution Model

**Purpose:** How commands run across repos, filtering options, and output modes.

**Key concepts covered:**
- Direct command passthrough (`meta npm install`)
- `meta exec -- <cmd>` syntax
- Parallel vs sequential execution
- `--include`, `--exclude`, `--tag` filtering
- `--dry-run` for previewing operations
- JSON output mode for scripting
- Filter precedence (tag → include → exclude)

**When Claude should reference this skill:**
- When running arbitrary commands across repos
- When needing to filter target repositories
- When building scripts that use meta

### meta-plugins - Plugin System

**Purpose:** How plugins intercept commands and extend meta's behavior.

**Key concepts covered:**
- Plugin discovery locations
- How command routing works (plugin vs exec fallback)
- Built-in plugins (git, project, rust)
- Plugin management commands
- Why some commands behave "magically" (e.g., `meta git clone`)

**When Claude should reference this skill:**
- When a command behaves unexpectedly
- When extending meta with custom behavior
- When troubleshooting command routing

## Skill Design Philosophy

These skills were designed with specific principles:

1. **Pedagogical, not encyclopedic** - Skills teach workflows and decision-making, not just command lists

2. **Context-aware** - Skills explain WHEN to use techniques, not just HOW

3. **Safety-first** - Snapshots and dry-run are emphasized for batch operations

4. **AI-optimized** - Written for how AI agents process instructions, with clear patterns and examples

## Creating Custom Skills

Add custom skills by creating markdown files in `.claude/skills/`:

```markdown
---
description: Brief description of the skill
triggers:
  - /trigger-name
  - /alternate-trigger
---

# Skill Name

Instructions for Claude...
```

### Best Practices for Custom Skills

1. **Focus on workflow, not reference** - Explain when and why, not just what
2. **Include concrete examples** - Show actual command sequences
3. **Highlight safety patterns** - Snapshots, dry-run, filtered operations
4. **Keep it scannable** - Use tables, code blocks, and clear headers

## Best Practices for AI Agents

1. **Use tags** - Filter operations by tag to avoid affecting unrelated projects
2. **Check status first** - Run `meta git status` before bulk operations
3. **Use atomic mode** - For risky operations, use atomic mode for auto-rollback
4. **Leverage queries** - Use query DSL to find specific repos by state
5. **Create snapshots** - Before major changes, create a snapshot for easy rollback

## Integration with MCP Server

While skills provide guidance for CLI usage, Claude can also use the Meta MCP server for programmatic access. The MCP server exposes 29 tools:

| Skill Domain | Related MCP Tools |
|--------------|-------------------|
| meta-workspace | `meta_list_projects`, `meta_get_config`, `meta_workspace_state` |
| meta-git | `meta_git_*`, `meta_snapshot_*` |
| meta-exec | `meta_exec`, `meta_batch_execute`, `meta_query_repos` |
| meta-plugins | `meta_list_plugins` |

See [mcp_server.md](mcp_server.md) for full MCP documentation.

## Updating Skills

Skills are embedded in the `meta` binary and updated with each release. To get the latest skills:

1. Update meta: `brew upgrade meta-cli` or reinstall
2. Reinstall skills: `meta init claude --force`

The `--force` flag overwrites existing skill files with the latest versions.
