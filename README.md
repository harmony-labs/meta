# meta

`meta` is a Rust implementation of the `meta` tool for managing multi-project systems and libraries. It allows you to execute commands across multiple repositories defined in a `.meta` file.

## Features

- Execute any command across multiple directories
- Easily manage multi-repo projects with directory filtering options
- Lightweight and fast Rust implementation
- Available as a downloadable executable from GitHub releases

## Installation

Download the latest release for your platform from the [GitHub Releases](https://github.com/yourusername/meta/releases) page.

## Usage

1. Create a `.meta` file in your root directory, listing the repositories you want to manage:

```json
{
  "projects": {
    "repo1": "./path/to/repo1",
    "repo2": "./path/to/repo2"
  }
}
```

2. Run commands using the `meta` tool:

```
meta git status
```

This will run `git status` in the root directory and all directories specified in the `.meta` file.

## Contributing

Contributions are welcome! Please see our [Contributing Guide](CONTRIBUTING.md) for more details.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
