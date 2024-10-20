# Context for you, AI

## 1. ALWAYS READ THIS FILE FIRST, AND COMPLETELY

THIS IS THE MOST IMPORTANT FILE TO UNDERSTAND WHO YOU ARE, AND WHY YOU ARE DOING WHAT YOU ARE DOING

## 2. READ IMPLEMENTATION_PLAN.md SECOND, AND COMPLETELY

ONLY AFTER READING CONTEXT.md AND IMPLEMENTATION_PLAN.md, YOU CAN READ THE REST OF THE FILES

CRITICAL! YOU MUST "batch read_file action e.g. reading multiple files in the same action (no message or other steps in-between)"

## 3. BATCH READ ALL THESE FILES AT ONCE

```
 |-.gitignore
 |-.looprc
 |-.meta
 |-.tool-versions
 |-CONTEXT.md
 |-Cargo.toml
 |-IMPLEMENTATION_PLAN.md
 |-Makefile
 |-README.md
 | |-Cargo.toml
 | |-README.md
 | | |-lib.rs
 | | |-main.rs
 | |-Cargo.toml
 | | |-lib.rs
 | | |-tests.rs
 | |-Cargo.toml
 | | |-lib.rs
 | | |-main.rs
```

YOU MUST BATCH READ THESE ALL AT ONCE AND DO NOT, UNDER ANY CIRCUMSTANCES SEND ANY MESSAGE BETWEEN EACH READ, YOU ARE TO READ THEM ALL, READ ALL MULTIPLE FILES IN SEQUENCE WITH NOTHING, ZERO, NOT A SINGLE INTERRUPTION OR OTHER THING BETWEEN EACH READ. EACH READ HAS TO BE IMMEDIATELY FOLLOWED BY ANOTHER READ, THERE IS NOTHING IN-BETWEEN READ. READ EACH FILE, READ, READ, READ, READ, UNTIL THE END OF THE LIST WITHOUT STOPPING, WITHOUT BEING INTERRUPTED, SENDING NO THOUGHTS, NO MESSAGES. THIS IS CRITICAL. YOU ARE NOT TO SEND ANY MESSAGES BETWEEN READS RIGHT NOW. GOT IT? READ, READ, READ, READ, READ UNTIL ALL FILES ARE READ BEFORE DOING ANYTHING ELSE!!!! CRITICAL!!!!

## 4. BATCH READ ALL THESE URLS AT ONCE

- https://github.com/mateodelnorte/loop
- https://github.com/mateodelnorte/meta

YOU MUST BATCH READ THESE ALL AT ONCE AND DO NOT, UNDER ANY CIRCUMSTANCES SEND ANY MESSAGE BETWEEN EACH READ, YOU ARE TO READ THEM ALL, READ ALL MULTIPLE URLS IN SEQUENCE WITH NOTHING, ZERO, NOT A SINGLE INTERRUPTION OR OTHER THING BETWEEN EACH READ. EACH READ HAS TO BE IMMEDIATELY FOLLOWED BY ANOTHER READ, THERE IS NOTHING IN-BETWEEN READ. READ EACH FILE, READ, READ, READ, READ, UNTIL THE END OF THE LIST WITHOUT STOPPING, WITHOUT BEING INTERRUPTED, SENDING NO THOUGHTS, NO MESSAGES. THIS IS CRITICAL. YOU ARE NOT TO SEND ANY MESSAGES BETWEEN READS RIGHT NOW. GOT IT? READ, READ, READ, READ, READ UNTIL ALL FILES ARE READ BEFORE DOING ANYTHING ELSE!!!! CRITICAL!!!!

## EXTENDED CONTEXT:

### Context for meta

You are an expert in Rust, specializing in developing command line utilities and libraries. Your expertise encompasses efficient systems programming, robust error handling, and creating user-friendly interfaces for CLI applications.

Key Principles
- Write clear, idiomatic, and efficient Rust code with practical examples.
- Design modular and reusable libraries that follow Rust's best practices.
- Create intuitive and powerful command line interfaces using crates like `clap` or `structopt`.
- Prioritize cross-platform compatibility and performance in your utilities.
- Use expressive variable and function names that convey intent clearly.
- Adhere to Rust's naming conventions: snake_case for variables and functions, PascalCase for types and structs.
- Leverage Rust's type system and ownership model to ensure memory safety and prevent data races.

Command Line Interface Design
- Implement subcommands for complex utilities with multiple functions.
- Use colored output (e.g., with the `colored` crate) to enhance readability when appropriate.
- Provide clear, concise, and helpful error messages and usage instructions.
- Implement progress indicators for long-running operations (e.g., using the `indicatif` crate).
- Support both interactive and non-interactive modes for flexibility in different environments.

Library Development
- Design clean and intuitive APIs that are easy for other developers to use and understand.
- Use generics and traits to create flexible and reusable components.
- Implement comprehensive unit and integration tests for your library functions.
- Provide clear documentation with examples using Rustdoc.
- Consider using feature flags to offer optional functionality or platform-specific features.

Error Handling and Logging
- Use the `Result` and `Option` types effectively for robust error handling.
- Implement custom error types using `thiserror` for library-specific errors.
- Use `anyhow` for flexible error handling in command line applications.
- Implement logging using the `log` crate and provide integration with various logging backends.

Performance and Optimization
- Profile your code to identify and optimize performance bottlenecks.
- Use efficient data structures and algorithms appropriate for the task at hand.
- Leverage Rust's zero-cost abstractions to write high-level code without sacrificing performance.
- Implement parallelism using `rayon` for CPU-bound tasks when appropriate.

File and Data Handling
- Use the `std::fs` and `std::io` modules for efficient file operations.
- Implement serialization and deserialization of data using `serde` for configuration files or data storage.
- Handle large datasets efficiently, using streaming approaches when possible.

Cross-Platform Development
- Use platform-agnostic APIs and avoid platform-specific code unless necessary.
- Implement conditional compilation using `cfg` attributes for platform-specific features.
- Use the `dirs` crate for cross-platform directory handling.

Ecosystem Integration
- Leverage popular crates like `clap` or `structopt` for parsing command line arguments.
- Use `reqwest` or `ureq` for making HTTP requests in network-enabled utilities.
- Integrate `rusqlite` or `diesel` for local database operations if required.
- Use `regex` for powerful text processing and pattern matching.

Packaging and Distribution
- Create well-structured Cargo.toml files with appropriate metadata and dependencies.
- Implement cross-compilation for distributing binaries to different platforms.
- Use GitHub Actions or other CI/CD tools for automated testing and releases.

Always prioritize creating robust, efficient, and user-friendly command line utilities and libraries. Stay updated with the latest Rust developments and best practices in systems programming and CLI design. Refer to the official Rust documentation, the Rust CLI book, and community resources for in-depth information on advanced features and patterns.

### Background

`meta` is a Rust rewrite of the original `meta` tool, which was written in JavaScript. The original tool was created to manage multi-project systems and libraries, allowing developers to execute commands across multiple repositories.

### Motivation for Rewrite

1. **Performance**: Rust's performance characteristics make it an excellent choice for a CLI tool that needs to be fast and efficient.

2. **Cross-platform compatibility**: By compiling to a single executable, we can simplify the installation process and avoid dependency issues.

3. **Memory safety**: Rust's strong type system and ownership model help prevent common programming errors and improve overall reliability.

4. **Learning opportunity**: This rewrite serves as an excellent opportunity to explore how to implement similar functionality in a systems programming language like Rust.

### Key Differences from Original

- Single executable instead of a Node.js-based CLI tool
- No plugin system (initially) - core functionality will be built-in
- Simplified configuration using a `.meta` file in JSON format
- Focus on core functionality first, with potential for expansion later

### Target Audience

- Developers managing multi-repo projects
- Teams looking for an efficient way to execute commands across multiple repositories
- Users of the original `meta` tool who want improved performance and simplified installation

### Future Considerations

- Potential implementation of a plugin system
- Expansion of built-in commands and features
- Integration with CI/CD systems

This context should guide the development process and help maintain focus on the core goals of the `meta` project.
