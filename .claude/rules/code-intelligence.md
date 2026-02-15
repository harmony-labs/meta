# Code Intelligence

This project has code intelligence tools available via MCP (`kb_callers`, `kb_symbols`, etc.) and CLI (`git kb callers`, etc.). **Prefer MCP tools** — they support parallel calls and return structured JSON. Fall back to CLI via Bash if MCP is disconnected.

The daemon automatically re-indexes files on save via file watching (500ms debounce). No manual re-indexing needed during normal coding.

## Use Code Intelligence Instead of Grep

Do NOT use Grep or `grep` to find callers, usages, or definitions of functions/methods/types. Use code intelligence tools instead — they understand the AST, not just text matches.

| Instead of | Use |
|------------|-----|
| `Grep` for function callers | `kb_callers` — returns actual call sites from the call graph |
| `Grep` for function definitions | `kb_symbols` with `search:` — finds by name with signature and location |
| `Grep` to understand what a function calls | `kb_callees` — returns actual callees from the call graph |
| `Grep` to assess change impact | `kb_impact` with `file_path:` — transitive blast radius analysis |
| `Glob` + `Grep` to find dead code | `kb_dead_code` — finds symbols with zero callers |

Grep is still appropriate for searching config files, string literals, error messages, and non-code content.

## Before Modifying Functions

Before changing a function signature, renaming a symbol, or modifying a struct's fields, check callers:

```text
kb_callers with symbol: "<symbol_name>"
```

This shows every call site that would break. Use this to assess blast radius before making changes.

## When Exploring Unfamiliar Code

When you need to understand a module or file you haven't seen before, run these in parallel:

```text
kb_symbols with file_path: "<file_path>"     # List all symbols in a file
kb_callers with symbol: "<symbol_name>"      # Who calls this?
kb_callees with symbol: "<symbol_name>"      # What does this call?
```

## Skills

Use these skills for structured code intelligence workflows:

- `/understand <file|symbol>` — Analyze structure, callers, callees, and related docs
- `/before-refactor <symbol>` — Safety check with blast radius and all call sites
- `/explore <query>` — Semantic search across code and documents (requires embeddings; enable in `.kb/config.toml` first)

## Initial Indexing

If symbols commands return empty for a directory that hasn't been indexed yet:

```bash
git kb index <directory_or_file>
```

After initial indexing, the file watcher keeps the index current automatically.

## MCP Tool Reference

| Tool | Purpose |
|------|---------|
| `kb_symbols` | Search/list indexed symbols (filter by file, kind, language) |
| `kb_callers` | Find all callers of a function |
| `kb_callees` | Find all functions called by a symbol |
| `kb_impact` | Analyze change blast radius across the call graph |
| `kb_dead_code` | Find potentially dead code (symbols with no callers) |
| `kb_symbol_refs` | Find KB documents that reference a code symbol |
| `kb_index` | Initial indexing of source files |
