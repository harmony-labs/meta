# FAQ / Troubleshooting Guide

This guide addresses common questions and issues encountered when using the `meta` CLI platform.

## Table of Contents

- [General Usage](#general-usage)
- [Plugins](#plugins)
- [Project Configuration](#project-configuration)
- [Filtering & Commands](#filtering--commands)
- [Debugging & Troubleshooting](#debugging--troubleshooting)
- [Getting Help](#getting-help)
- [See Also](#see-also)

---

## General Usage

**Q: `meta` command not found?**
A: Ensure `$HOME/.cargo/bin` is in your PATH, or use the full path to the binary.

**Q: How do I install meta?**
A: See the [Installation](../README.md#installation) section in the main README.

## Plugins

**Q: How do I add a new plugin?**
A: Place the plugin binary or script in `.meta-plugins` or a directory in your PATH.

**Q: My plugin is not detected. What should I check?**
A:
- Ensure the plugin is executable.
- Check the naming convention (`meta-<command>`).
- Place it in `.meta-plugins` or a directory in your PATH.
- Use `META_DEBUG=1` for debug output.

## Project Configuration

**Q: Why does meta not find my repos?**
A: Check your `.meta` file for correct paths and structure.

**Q: How do I customize the project structure?**
A: Edit the `.meta` file as described in the [Advanced Usage Guide](advanced_usage.md).

## Filtering & Commands

**Q: How do I run a command only in some repos?**
A: Use `--include-only repo1,repo2` or `--exclude repo3`.

**Q: Can I chain meta commands in scripts?**
A: Yes, see [Scripting with meta](advanced_usage.md#scripting-with-meta).

## Debugging & Troubleshooting

- Use `meta --help` for command usage.
- Set `META_DEBUG=1` for verbose output.
- Check for updates or known issues on [GitHub Issues](https://github.com/yourusername/meta/issues).

## Getting Help

- See [Community & Support](../README.md#community--support).
- For security issues, see [Security Policy](../README.md#security-policy).

## See Also

- [Advanced Usage Guide](advanced_usage.md)
- [Plugin Development Guide](plugin_development.md)
- [Architecture Overview](architecture_overview.md)