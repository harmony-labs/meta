# Meta Plugins Skill

Meta uses a plugin system to intercept commands and provide enhanced behavior.

## How Plugins Work

When you run `meta <command>`, meta checks if a plugin handles that command pattern:

1. **Plugin matches** → Plugin executes with special logic
2. **No plugin** → Falls back to `meta exec -- <command>`

Example:
- `meta git status` → git plugin runs `git status` in all repos
- `meta git clone <url>` → git plugin clones parent + all children from `.meta`
- `meta npm install` → no plugin, falls back to exec

## Built-in Plugins

### Git Plugin (`meta-git`)

Handles all `meta git *` commands with special cases:

| Command | Behavior |
|---------|----------|
| `meta git clone <url>` | Clone parent, read `.meta`, clone all children |
| `meta git update` | Clone missing repos, pull existing ones |
| `meta git snapshot *` | Create/restore workspace state |
| `meta git setup-ssh` | Configure SSH multiplexing |
| `meta git <other>` | Pass through to all repos |

### Project Plugin (`meta-project`)

Workspace management:

```bash
meta project list      # List projects from .meta
meta project check     # Verify all repos exist
meta project sync      # Clone missing repos
```

### Rust Plugin (`meta-rust`)

Cargo workspace awareness:

```bash
meta rust build        # Build with workspace detection
meta rust test         # Test with proper ordering
```

## Plugin Discovery

Plugins are discovered from:
1. `.meta-plugins/` in current directory
2. `~/.meta-plugins/` in home directory
3. Executables named `meta-*` in PATH

## Plugin Management

```bash
# List installed plugins
meta plugin list

# Search registry for plugins
meta plugin search <query>

# Install from registry
meta plugin install <name>

# Uninstall
meta plugin uninstall <name>
```

## Understanding Command Flow

```
meta git status
  │
  ├─ Is there a 'git' plugin? Yes (meta-git)
  │
  ├─ Plugin receives: command="git status", projects=[list]
  │
  ├─ Plugin returns: ExecutionPlan with commands per repo
  │
  └─ Meta executes plan via loop engine
```

For commands with special handling (like `clone`), the plugin does the work directly instead of returning an execution plan.

## Why This Matters

Plugins let you:
- **Extend meta** with domain-specific behavior
- **Intercept patterns** like `git clone` to add meta-aware logic
- **Provide help text** via `meta <plugin> --help`

When you see a command behave "magically" (like `meta git clone` cloning multiple repos), a plugin is handling it.
