---
allowed-tools:
  - mcp__gitkb__kb_list
  - mcp__gitkb__kb_show
  - mcp__gitkb__kb_graph
  - Bash(git kb:*)
description: Show GitKB kanban board with task status columns
---

Display the kanban board and provide actionable context about the current workstream.

## Steps

### 1. Show the Board

```bash
git kb board --all
```

### 2. Analyze Blocked Tasks

If any tasks are in the BLOCKED column (or have `blockedBy` relationships):
- Use `kb_show` to load each blocked task
- Identify what's blocking them
- Summarize: "X is blocked by Y because Z"

### 3. Suggest Next Task

Look at ACTIVE and DRAFT tasks. Suggest what to work on next based on:
- **Priority**: high > medium > low
- **Dependencies**: unblocked tasks first
- **Momentum**: tasks related to recently completed work

### 4. Flag Staleness

If any task has been ACTIVE with no progress log entries in the last 7 days, flag it:
- "task-slug has been active since [date] with no progress updates in 7+ days — is it still being worked on?"

### 5. Present Summary

Show the board output, then add:
- Count of tasks by status
- Any blocked items with reasons
- Suggested next task with rationale
