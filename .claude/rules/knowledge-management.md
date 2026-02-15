# Knowledge Management

Maintain the GitKB knowledge base as you work. Documents are your persistent memory across sessions.

## Before Starting Work

- Check `git kb board` or `kb_board` to see what's active and what's blocked
- If you're about to do non-trivial work and no task exists for it, create one first
- Search before creating: `kb_search` with keywords to avoid duplicates

## While Working

- Add progress entries to the active task document as you make progress
- Include `[[tasks/...]]` wikilinks in git commit messages for related tasks:
  ```
  fix: resolve timeout issue

  Implements [[tasks/gitkb-33]]
  ```
- When you discover bugs or issues, create incident documents — don't just fix and forget

## After Significant Work

- Update `context/overridable/active` to reflect what changed and what's next
- Check off completed acceptance criteria in task documents
- Add completion evidence (commit hashes, test results) before marking tasks done

## Document Lifecycle

- **Create first, implement second** — the document IS your plan
- **Update as you go** — don't wait until the end to document
- **Complete the body before changing status** — never mark "done" without evidence
- **Link everything** — tasks reference specs, incidents reference fixes, commits reference tasks
