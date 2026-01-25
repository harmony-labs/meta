## Project Architecture: Meta-Repo (NOT a monorepo)

This is a **meta-repo** — a workspace of independent git repositories managed by the `meta` CLI tool. Each directory listed in `.meta` (the project config) is a **separate git repo** with its own remote, commits, and history.

**Critical rules:**
- NEVER assume this is a monorepo. There is no single shared git history.
- Each workspace member (e.g., `meta_cli/`, `meta_core/`, `loop_lib/`) is its own git repo cloned from its own GitHub remote.
- The root `.gitignore` ignores all child repos because they are NOT part of the parent repo.
- The root `Cargo.toml` defines a Rust workspace for local development convenience, but each member builds and publishes independently.
- When creating a new crate/package, it MUST be initialized as a separate git repo, pushed to GitHub under `harmony-labs/`, and added to both `.meta` (projects config) and `.gitignore`.

**Project config (`.meta`):**
```json
{
  "projects": {
    "meta_cli": "git@github.com:harmony-labs/meta_cli.git",
    "meta_core": "git@github.com:harmony-labs/meta_core.git",
    ...
  }
}
```

**What `meta` does:** Clones all child repos, runs commands across them in parallel (`meta exec`), manages git worktrees across the entire workspace (`meta worktree`), and provides project-level coordination.

## GitKB

This project uses GitKB for knowledge management.

@.kb/AGENTS.md
