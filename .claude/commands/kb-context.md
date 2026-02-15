---
allowed-tools:
  - mcp__gitkb__kb_context
  - mcp__gitkb__kb_status
  - mcp__gitkb__kb_list
  - mcp__gitkb__kb_show
  - mcp__gitkb__kb_checkout
  - mcp__gitkb__kb_create
  - mcp__gitkb__kb_commit
  - Bash(git kb:*)
description: Load and validate project context, bootstrapping if needed
---

Load project context following the AGENTS.md PATH A/B/C flow.

## Steps

### 1. Detect KB State

```bash
git kb list --path context/
```

### 2. Follow the Right Path

**If no context documents exist (PATH A — First-Time Setup):**

The KB is fresh. Help the user establish context:

1. Ask about the project: what it does, who it's for, tech stack, current state
2. Create the 7 context documents:
   - `context/immutable/project-brief` (type: brief)
   - `context/immutable/patterns` (type: patterns)
   - `context/immutable/architecture` (type: architecture)
   - `context/extensible/product` (type: context)
   - `context/extensible/tech` (type: context)
   - `context/overridable/active` (type: context)
   - `context/overridable/progress` (type: context)
3. Populate each with gathered information
4. Commit: `"Initial context setup"`

**If context documents exist (PATH B — Load and Validate):**

1. Use `kb_context` to load the full context bundle
2. Validate completeness — check all 7 docs exist:
   - `context/immutable/project-brief`
   - `context/immutable/patterns`
   - `context/immutable/architecture`
   - `context/extensible/product`
   - `context/extensible/tech`
   - `context/overridable/active`
   - `context/overridable/progress`
3. If any are missing, flag them and offer to create them
4. **Detect staleness** in overridable docs:
   - Check if `context/overridable/active` references tasks that are now completed
   - Check if `context/overridable/progress` shows phases as "in progress" when all their tasks are done
   - If stale, warn: "Active context appears stale — it references [X] as in-progress but that work is complete. Consider running `/kb-handoff` to update it."

**If context was already loaded this session (PATH C — Quick Resume):**

1. Check `kb_status` for pending changes
2. Quick-refresh `context/overridable/active`
3. Resume work

### 3. Present Context Summary

After loading, present a concise summary:
- Current focus (from active context)
- Task board summary (counts by status)
- Any blockers or stale items
- Confidence level: 100% if all context loaded and validated
