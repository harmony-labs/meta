# Contribution Guide

Thank you for your interest in contributing to the `meta` CLI platform! This guide provides an overview of how to get involved and best practices for contributing.

## Table of Contents

- [How to Contribute](#how-to-contribute)
- [Development Environment](#development-environment)
- [Code Standards](#code-standards)
- [Submitting Pull Requests](#submitting-pull-requests)
- [Reporting Issues](#reporting-issues)
- [Contributing Plugins](#contributing-plugins)
- [Resources](#resources)
- [See Also](#see-also)

---

## How to Contribute

- Read the main [CONTRIBUTING.md](../CONTRIBUTING.md) for canonical contribution rules.
- Fork the repository and create a feature branch.
- Make your changes with clear, descriptive commit messages.
- Ensure your code passes all tests and lints.

## Development Environment

- Install Rust (see [Installation](../README.md#installation)).
- Clone the repository and run:
  ```bash
  cargo build
  cargo test
  ```
- Use the provided Makefile for common tasks.

## Code Standards

- Follow Rust best practices and project conventions.
- Write clear, maintainable code.
- Add or update documentation as needed.

## Submitting Pull Requests

- Open a pull request with a clear description of your changes.
- Reference related issues or discussions.
- Ensure your PR passes CI checks.

## Reporting Issues

- Use [GitHub Issues](https://github.com/harmony-labs/meta/issues) for bugs, feature requests, and questions.
- Provide detailed steps to reproduce issues.

## Contributing Plugins

- See the [Plugin Development Guide](plugin_development.md) for how to create and submit plugins.
- Document your plugin and provide usage examples.

## Resources

- [Architecture Overview](architecture_overview.md)
- [Advanced Usage Guide](advanced_usage.md)
- [FAQ / Troubleshooting Guide](faq_troubleshooting.md)

## See Also

- [Plugin Development Guide](plugin_development.md)
- [Architecture Overview](architecture_overview.md)