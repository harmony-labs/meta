# Meta Build Skill

Execute build and test commands across the meta workspace.

## Building This Project

This is a Cargo workspace. Build commands work from the root:

```bash
# Build everything
cargo build
cargo build --release

# Build specific crate
cargo build -p meta
cargo build -p meta_git_cli
cargo build -p meta-mcp

# Run all tests
cargo test

# Using make
make build
make test
```

## Cross-Repo Commands

To run arbitrary commands across all child repos:

```bash
# Run make in each repo
meta exec -- make build

# Run tests in each repo
meta exec -- make test

# With JSON output for parsing
meta --json exec -- cargo test
```

## Filtering

Target specific repos with tags or include/exclude:

```bash
# Only repos tagged 'backend'
meta --tag backend exec -- cargo build

# Exclude specific repo
meta --exclude meta_mcp exec -- cargo test
```
