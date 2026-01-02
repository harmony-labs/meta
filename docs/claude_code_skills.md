# Claude Code Skills for Meta

Meta includes four Claude Code skills that provide natural language interfaces for multi-repository operations. These skills are language-agnostic and work with any project type.

## Installation

Skills are located in `.claude/skills/` and are automatically discovered by Claude Code when working in a meta repository.

## Available Skills

### meta-git - Git Operations

**Triggers:** `/meta-git`, `/sync-repos`, `/multi-repo-status`

Provides multi-repo git operations with intelligent status reporting.

**Commands:**
- `/meta-git status` - Show status across all repos
- `/meta-git sync` - Pull and push all repos
- `/meta-git branch <name>` - Create branch across repos
- `/meta-git commit <msg>` - Commit across dirty repos

**Example Usage:**
```
/meta-git status
/meta-git sync
/meta-git branch feature/new-api
/meta-git commit "Update dependencies"
```

### meta-build - Build and Test

**Triggers:** `/meta-build`, `/meta-test`, `/run-tests`

Build and test operations with auto-detection of build systems.

**Commands:**
- `/meta-build` - Build all projects
- `/meta-build --release` - Release build
- `/meta-test` - Run tests across all projects
- `/meta-test --tag backend` - Run tests for tagged projects

**Example Usage:**
```
/meta-build
/meta-test --tag backend
/meta-build --release
```

### meta-discover - Discovery and Analysis

**Triggers:** `/meta-discover`, `/analyze-project`, `/find-code`

Code search and project discovery across repositories.

**Commands:**
- `/meta-discover` - Analyze all projects (build systems, structure)
- `/find-code <pattern>` - Search code across repos
- `/find-code "TODO" --file "*.rs"` - Search with file filter
- `/analyze-deps` - Dependency analysis

**Example Usage:**
```
/meta-discover
/find-code "handleError"
/find-code "import.*axios" --file "*.ts"
/analyze-deps
```

### meta-core - Core Operations

**Triggers:** `/meta`, `/meta-exec`, `/meta-help`

Core meta operations and command execution.

**Commands:**
- `/meta exec <cmd>` - Run command across repos
- `/meta config` - Show configuration
- `/meta plugins` - List plugins
- `/meta query <query>` - Query repos by state

**Example Usage:**
```
/meta exec "git fetch"
/meta config
/meta query "dirty:true AND tag:backend"
```

## Skill File Structure

Each skill file follows this structure:

```markdown
---
description: Brief description of the skill
triggers:
  - /trigger-name
  - /alternate-trigger
---

# Skill Name

Instructions for Claude on how to use this skill...

## Available Commands

### Command 1
Description and examples...

### Command 2
Description and examples...
```

## Creating Custom Skills

You can create custom skills by adding markdown files to `.claude/skills/`:

1. Create a new file: `.claude/skills/my-skill.md`
2. Add frontmatter with triggers
3. Document commands and usage
4. Claude Code will auto-discover it

**Example Custom Skill:**

```markdown
---
description: Deploy to staging environment
triggers:
  - /deploy
  - /stage
---

# Deploy Skill

Deploy projects to staging environment.

## Commands

### /deploy staging
Deploy all services to staging.

Uses meta MCP tools:
1. `meta_git_status` to check for uncommitted changes
2. `meta_run_tests` to verify tests pass
3. `meta_exec` to run deploy scripts
```

## Best Practices

1. **Use tags** - Filter operations by tag to avoid affecting unrelated projects
2. **Check status first** - Run `/meta-git status` before bulk operations
3. **Use atomic mode** - For risky operations, use atomic mode for auto-rollback
4. **Leverage queries** - Use `/meta query` to find specific repos by state
5. **Create snapshots** - Before major changes, create a snapshot for easy rollback

## Integration with MCP

Skills use the Meta MCP server under the hood. When Claude Code executes a skill command, it translates to MCP tool calls:

| Skill Command | MCP Tool(s) |
|--------------|-------------|
| `/meta-git status` | `meta_git_status` |
| `/meta-git sync` | `meta_git_pull`, `meta_git_push` |
| `/meta-build` | `meta_build` |
| `/meta-test` | `meta_run_tests` |
| `/find-code <pattern>` | `meta_search_code` |
| `/meta query` | `meta_query_repos` |
