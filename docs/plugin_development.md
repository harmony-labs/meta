# Plugin Development Guide

This guide provides a comprehensive overview of developing plugins for the `meta` CLI platform, including best practices, examples, and extensibility points.

## Table of Contents

- [Introduction](#introduction)
- [Plugin Types](#plugin-types)
- [Plugin Discovery](#plugin-discovery)
- [Creating a Plugin](#creating-a-plugin)
- [Plugin API Reference](#plugin-api-reference)
- [Best Practices](#best-practices)
- [Testing Plugins](#testing-plugins)
- [Advanced Plugin Features](#advanced-plugin-features)
- [Troubleshooting](#troubleshooting)
- [See Also](#see-also)

---

## Introduction

Plugins extend the functionality of `meta` by adding, overriding, or enhancing commands. They can be written in Rust, as external executables, or as scripts.

## Plugin Types

- **Rust Crate Plugins**:
  Build plugins as Rust crates for performance and integration.
- **External Executables/Scripts**:
  Any executable or script in your PATH or `.meta-plugins` directory can be a plugin.

## Plugin Discovery

`meta` discovers plugins from:
- `.meta-plugins` in your project root
- Your home directory
- System PATH

Plugins must be executable and follow the naming convention: `meta-<command>`.

## Creating a Plugin

### Rust Plugin Example

1. Create a new Rust binary crate:
   ```bash
   cargo new meta-myplugin --bin
   ```
2. Implement your logic in `main.rs`.
3. Build and place the binary in `.meta-plugins` or your PATH.

### Script Plugin Example

Create an executable script named `meta-hello`:
```bash
#!/bin/bash
echo "Hello from meta plugin!"
```
Make it executable and place it in `.meta-plugins`.

## Plugin API Reference

- Plugins receive command-line arguments and environment variables.
- Plugins can output to stdout/stderr for user feedback.
- For advanced integration, see the [meta_plugin_api](../meta_plugin_api/) crate.

## Best Practices

- Follow naming conventions (`meta-<command>`).
- Provide clear help output (`--help`).
- Handle errors gracefully.
- Support cross-platform usage (avoid OS-specific code when possible).
- Document your plugin's usage and options.

## Testing Plugins

- Test plugins in isolation and as part of the full `meta` workflow.
- Use the `meta --help` and `meta <command> --help` to verify integration.

## Advanced Plugin Features

- Plugins can provide interactive UIs, spinners, and progress bars.
- Plugins can override built-in commands.
- Use environment variables for configuration.

See [Advanced Usage Guide](advanced_usage.md) for more on scripting and advanced CLI features.

## Troubleshooting

If your plugin is not detected:
- Ensure it is executable.
- Check naming and placement.
- Use `META_DEBUG=1` for debug output.

For more help, see the [FAQ / Troubleshooting Guide](faq_troubleshooting.md).

## See Also

- [Plugin Help & Clone Design](plugin_help_and_clone_design.md)
- [Advanced Usage Guide](advanced_usage.md)
- [Architecture Overview](architecture_overview.md)