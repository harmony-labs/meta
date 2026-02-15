---
allowed-tools:
  - mcp__gitkb__kb_status
  - mcp__gitkb__kb_diff
  - mcp__gitkb__kb_commit
  - mcp__gitkb__kb_show
description: Commit workspace changes to the knowledge base with validation
---

Review, validate, and commit pending workspace changes.

## Steps

### 1. Review Changes

Use `kb_status` to see what will be committed, then `kb_diff` to review actual changes.

### 2. Validate Before Committing

Check for common issues in the diff:

**Status change without body update (AGENTS.md rule #8):**
If a document's `status` field changed to `completed`/`done`/`resolved` but the body has no corresponding updates (no completion evidence, no checked acceptance criteria), **warn the user**:
> "This changes status to completed but the document body doesn't show completion evidence. Consider adding a Completion Evidence section or checking off acceptance criteria before committing."

**Graph-derived fields being committed:**
If the diff shows changes to fields that are graph-derived (`blocks`, `children`, `references`), warn:
> "The field `blocks` is graph-derived — it's computed from other documents' `blocked_by` fields. Committing it may cause unexpected behavior. Consider removing it from the frontmatter."

**Empty or skeleton documents:**
If a new document has only frontmatter and no body content, warn:
> "This document has no body content. Consider adding at least an Overview section before committing."

### 3. Generate Commit Message

Analyze the changes and draft a concise commit message:
- Summarize what changed (created, modified, status transitions)
- Reference document slugs
- Keep it under 72 characters for the first line

### 4. Commit

Use `kb_commit` with the generated message and `author: "Claude <claude@anthropic.com>"`.

### 5. Confirm

Show what was committed and the resulting state.
