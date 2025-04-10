# Advanced Usage Guide

This guide covers advanced features of the `meta` CLI, including powerful filtering, scripting, and extensibility options for expert users.

## Table of Contents

- [Filtering Commands](#filtering-commands)
- [Scripting with meta](#scripting-with-meta)
- [Advanced Plugin Usage](#advanced-plugin-usage)
- [Environment Variables](#environment-variables)
- [Customizing meta Behavior](#customizing-meta-behavior)
- [Troubleshooting](#troubleshooting)
- [See Also](#see-also)

---

## Filtering Commands

`meta` allows you to target specific directories or exclude certain projects using filters:

- **Include Only**:
  Run a command only in selected projects:
  ```bash
  meta git status --include-only repo1,repo2
  ```
- **Exclude**:
  Skip certain projects:
  ```bash
  meta npm install --exclude legacy-repo
  ```

You can combine filters for fine-grained control.

## Scripting with meta

`meta` is script-friendly and can be used in shell scripts or CI pipelines.

- **Chaining Commands**:
  ```bash
  meta git pull && meta npm install
  ```
- **Capturing Output**:
  ```bash
  meta ls -1 | grep src
  ```
- **Using with xargs**:
  ```bash
  meta list | xargs -I{} echo "Project: {}"
  ```

## Advanced Plugin Usage

- **Custom Plugins**:
  Place your plugin binaries or scripts in `.meta-plugins` or a directory in your PATH.
- **Override Built-in Commands**:
  Plugins can override default behavior for any command.
- **Interactive Plugins**:
  Plugins can provide interactive UIs, spinners, and progress bars.

See [Plugin Development Guide](plugin_development.md) for details.

## Environment Variables

You can influence `meta` behavior with environment variables:

- `META_DEBUG=1` — Enable debug output.
- `META_CONFIG` — Specify a custom config file.

## Customizing meta Behavior

- **.meta file**:
  Customize your project structure and plugin discovery.
- **Plugin Hooks**:
  Use plugin hooks to extend or modify command execution.

## Troubleshooting

For common issues, see the [FAQ / Troubleshooting Guide](faq_troubleshooting.md).

## See Also

- [Plugin Development Guide](plugin_development.md)
- [Architecture Overview](architecture_overview.md)
- [FAQ / Troubleshooting Guide](faq_troubleshooting.md)