# Meta Architecture Improvement Plan

## Goal
Transform meta into the premier multi-repo management tool with easy installation, extensible plugin ecosystem, team-friendly features, and AI-era capabilities.

## User Requirements
- **Target audience**: Both enterprise and OSS equally
- **Plugin distribution**: Hybrid (public registry + private company registries)
- **Plugin technology**: Open to suggestions (not limited to Rust-only)
- **Permissions**: Git-based permissions (leverage existing git access control)

---

## Phase 1: Foundation & Machine-Readable Output

### 1.1 JSON Output Mode
Add `--json` flag to all commands for machine-readable output.

**Files to modify:**
- [meta_cli/src/main.rs](meta_cli/src/main.rs) - Add global `--json` flag
- [meta_plugin_api/src/lib.rs](meta_plugin_api/src/lib.rs) - Update Plugin trait with output format parameter
- [meta_git_cli/src/lib.rs](meta_git_cli/src/lib.rs) - Implement JSON output for git commands

**Schema structure:**
```json
{
  "version": "1.0",
  "command": "meta git status",
  "timestamp": "2024-01-15T10:30:00Z",
  "results": [
    {
      "project": "loop_lib",
      "path": "./loop_lib",
      "success": true,
      "data": { ... }
    }
  ]
}
```

### 1.2 Project Tags
Allow tagging projects to run commands on subsets.

**New file:** `meta_cli/src/tags.rs`

**Tag config in `.meta`:**
```yaml
projects:
  web-app:
    path: ./web-app
    tags: [frontend, typescript]
  api-service:
    path: ./api-service
    tags: [backend, rust]
  shared-utils:
    path: ./shared-utils
    tags: [frontend, backend]  # Can have multiple tags
```

**Usage:** `meta git status --tag frontend` or `meta git pull --tags backend,rust`

**Note on team "views":** Teams naturally create their own `.meta` files with their subset of repos. No special feature needed - a repo can exist in multiple teams' `.meta` files simultaneously. Git permissions handle access control.

### 1.3 YAML Support for .meta
Support both JSON and YAML formats for `.meta` configuration.

**Files to modify:**
- [meta_cli/src/main.rs](meta_cli/src/main.rs) - Detect and parse both formats
- Add `serde_yaml` dependency

**Supported files:** `.meta` (JSON), `.meta.yaml`, `.meta.yml`

**Backward compatibility:** The existing simple format continues to work:
```json
{
  "projects": {
    "web-app": "git@github.com:org/web-app.git",
    "api-service": "git@github.com:org/api-service.git"
  }
}
```

**Extended format** (optional) adds tags and explicit paths:
```yaml
# Team frontend repositories
projects:
  # Simple format still works - string value = git URL
  web-app: git@github.com:org/web-app.git

  # Extended format - object value with optional fields
  api-service:
    repo: git@github.com:org/api-service.git
    path: ./services/api      # optional, defaults to ./{project-name}
    tags: [backend, rust]     # optional
```

**Parsing logic:**
- If project value is a string → treat as git URL (backward compat)
- If project value is an object → parse extended format
- Path defaults to `./{project-name}` if not specified

---

## Phase 2: Distribution

### 2.1 GitHub Actions Release Pipeline
**New file:** `.github/workflows/release.yml`

- Build cross-platform binaries (macOS arm64/x86, Linux, Windows)
- Create GitHub releases with checksums
- Trigger on version tags

### 2.2 Homebrew Tap
**New repo:** `homebrew-tap`

- Formula for `meta` with plugin support
- Post-install script to set up plugin directory
- Auto-update on releases

### 2.3 Installation Script
**New file:** `install.sh`

```bash
curl -fsSL https://get.meta-cli.dev | bash
```

- Detect platform and architecture
- Download appropriate binary
- Set up PATH and completions

---

## Phase 3: Plugin Ecosystem

### 3.1 Subprocess Plugin Support
Allow plugins written in any language via subprocess communication.

**New file:** `meta_plugin_api/src/subprocess.rs`

**Protocol:**
- Plugins are executables named `meta-plugin-{name}`
- Commands passed as JSON on stdin
- Results returned as JSON on stdout
- Manifest file describes available commands

**Example plugin manifest (`meta-plugin-docker/manifest.json`):**
```json
{
  "name": "docker",
  "version": "1.0.0",
  "commands": ["build", "push", "compose"],
  "runtime": "python3"
}
```

### 3.2 GitHub-Based Plugin Registry
**New file:** `meta_cli/src/registry.rs`

Use a public GitHub repo as the registry - no database needed!

**Registry repo structure (`github.com/anthropics/meta-plugins`):**
```
plugins/
├── index.json           # Auto-generated plugin index
├── docker/
│   └── plugin.json      # Plugin metadata
├── npm/
│   └── plugin.json
└── terraform/
    └── plugin.json
```

**Plugin metadata (`plugin.json`):**
```json
{
  "name": "docker",
  "description": "Docker commands for meta repositories",
  "version": "1.2.0",
  "author": "username",
  "repository": "github.com/username/meta-plugin-docker",
  "releases": {
    "1.2.0": {
      "darwin-arm64": "https://github.com/.../releases/download/v1.2.0/meta-plugin-docker-darwin-arm64.tar.gz",
      "darwin-x64": "...",
      "linux-x64": "..."
    }
  },
  "checksum": "sha256:..."
}
```

**How it works:**
1. Plugin authors submit PRs to add/update their `plugin.json`
2. GitHub Actions validates the PR (checks URLs work, checksums match, runs basic tests)
3. On merge, CI regenerates `index.json`
4. `meta plugin search` fetches the raw `index.json` from GitHub
5. `meta plugin install` downloads binaries directly from plugin author's releases

**Benefits:**
- No database or server to maintain
- PRs provide audit trail and review process
- GitHub Actions handles validation
- Plugin binaries hosted on authors' own repos (distributed load)
- Anyone can fork for private registries

**Commands:**
```bash
meta plugin search docker
meta plugin install docker
meta plugin install --registry github.com/company/meta-plugins docker-internal
meta plugin list
meta plugin update
```

### 3.3 Plugin Discovery
- `~/.meta/plugins/` for installed plugins
- Local `.meta/plugins/` for project-specific plugins
- Environment variable `META_PLUGIN_PATH` for additional paths
- Registry config in `~/.meta/config.yaml`:
  ```yaml
  registries:
    - github.com/anthropics/meta-plugins  # default
    - github.com/company/internal-plugins  # private
  ```

---

## Phase 4: Advanced Features

### 4.1 Nested Meta Support
Support meta repos containing other meta repos.

**Files to modify:**
- [meta_cli/src/main.rs](meta_cli/src/main.rs) - Recursive .meta detection
- [loop_lib/src/lib.rs](loop_lib/src/lib.rs) - Nested directory handling

**Behavior:**
```
workspace/
├── .meta              # Root meta
├── frontend/
│   ├── .meta          # Nested meta
│   ├── web-app/
│   └── mobile-app/
└── backend/
    ├── .meta          # Nested meta
    └── api-service/
```

Commands: `meta --recursive` or `meta --depth 2`

### 4.2 MCP Server for AI Integration
Expose meta functionality via Model Context Protocol.

**New crate:** `meta_mcp/`

**Capabilities:**
- List all projects and their status
- Execute git operations across repos
- Query project relationships
- Stream real-time updates

**Integration:** Works with Claude Code, Cursor, and other MCP-compatible tools.

---

## Implementation Order

1. **YAML support** - Better developer experience, enables comments
2. **JSON output mode** - Foundation for all tooling integrations
3. **Project tags** - Filter commands to project subsets
4. **GitHub Actions + Homebrew** - Easy installation drives adoption
5. **Subprocess plugins** - Opens ecosystem to all languages
6. **Plugin registry** - Enables sharing and discovery
7. **Nested meta** - Enterprise-scale support
8. **MCP server** - AI-native development workflows

---

## Critical Files Summary

| File | Changes |
|------|---------|
| `meta_cli/src/main.rs` | Global flags, YAML parsing, tag filtering |
| `meta_cli/Cargo.toml` | Add `serde_yaml` dependency |
| `meta_plugin_api/src/lib.rs` | Plugin trait updates for JSON output |
| `meta_git_cli/src/lib.rs` | JSON output implementation |
| `loop_lib/src/lib.rs` | Nested directory handling |
| `.github/workflows/release.yml` | New - CI/CD pipeline |
| `meta_cli/src/tags.rs` | New - Tag filtering logic |
| `meta_cli/src/registry.rs` | New - Plugin registry |
| `meta_plugin_api/src/subprocess.rs` | New - Subprocess protocol |
| `meta_mcp/` | New crate - MCP server |
