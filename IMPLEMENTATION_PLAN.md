# Implementation Plan for meta and loop

AI INSTRUCTIONS: 

1. Update tasks with √ when completed. 
2. Ensure all functionality for completed tasks stays functional when adding new functionality.
3. Ensure tests are written for all functionality.
4. Ensure all tests pass before completing a task.

## Phase 1: Project Setup and Core Functionality

1. √: Set up project structure using Cargo workspaces
   - √: Create a root directory for the workspace
   - √: Create separate directories for `meta` and `loop` crates
   - √: Set up a shared library crate for common functionality
   - √: Configure Cargo.toml files for workspace and individual crates

2. √: Implement core `loop` functionality
   - √: Set up error handling and logging
   - √: Implement `.looprc` file parsing
      - √: Example: ```json
        {
          "ignore": [ ".git" ]
        }
        ```
   - √: Develop command execution logic
   - √: Build CLI interface using clap or structopt
   - √: Implement directory filtering options (--include, --exclude, etc.)
   - √: Ensure color output from child commands is retained

3. √ Develop `meta` functionality
   - √ Implement `.meta` file parsing
      - Example `.meta` file:
        ```json
        {
          "ignore": [ ".git" ],
          "projects": {
            "loop": "git@github.com:mateodelnorte/loop.git",
            "loop_lib": "git@github.com:mateodelnorte/loop_lib.git",
            "meta": "git@github.com:mateodelnorte/meta.git"
          }
        }
        ```
   - √ Create logic to pass directory list, command, and options to `loop` / `loop_lib`

4. √ Integrate `loop` library into `meta` (done via leveraging `loop_lib` as a library)
   - √ Use `loop` as a dependency in `meta` (done via leveraging `loop_lib` as a library)
   - √ Implement `meta` commands using `loop` functionality (done via leveraging `loop_lib` as a library)

## Phase 2: Enhanced Functionality

6. Add parallel execution option to `loop`
   - Implement multi-threading for running commands in parallel
   - Add a `--parallel` flag to enable parallel execution
   - Show spinner and summary of each command being run
   - Show combined output when done, retaining color from child processes

7. Improve error handling and reporting in both `loop` and `meta`
   - Implement detailed error messages
   - Add color-coded output for better readability

8. Extend `meta` functionality
   - Implement `meta`-specific features that leverage `loop`
   - Ensure `meta` correctly handles `loop` options like directory filtering

## Phase 3: Testing and Documentation

9. Write comprehensive tests
   - Unit tests for core functions in both `loop` and `meta`
   - Integration tests for CLI functionality
   - Tests for the interaction between `meta` and `loop`

10. Create documentation
    - Write comprehensive READMEs for both `loop` and `meta`
    - Document the API for using `loop` as a library
    - Create man pages for both tools

## Phase 4: Polish and Distribution

11. Set up CI/CD pipeline
    - Configure GitHub Actions for automated testing and building
    - Set up automated releases for multiple platforms

12. Prepare for distribution
    - Set up binary releases on GitHub for both `loop` and `meta`
    - Investigate distribution through package managers (e.g., Homebrew, Chocolatey)

## Phase 5: Future Enhancements

13. Optimize performance
    - Profile both applications to identify bottlenecks
    - Implement performance improvements

14. Enhance user experience
    - Add interactive mode for certain commands
    - Implement command suggestions for mistyped commands

15. Consider additional features
    - Analyze user feedback and usage patterns
    - Implement new features that benefit both `loop` and `meta` users

This implementation plan provides a structured approach to developing both the `loop` and `meta` tools as separate but interconnected projects. The plan focuses on leveraging `loop` as a library within `meta`, while also maintaining them as independent executables. The plan can be adjusted as development progresses and new requirements or challenges arise.

# Update implementation plan

1. to include a plugin system, which allows adding additional sub commands to meta. For instance, meta could be extended to support git commands not provided by git, itself, like `meta git update` to update the meta git repo, pulling in any newly added repositories. `meta git --help` would show help for any `meta-git` plugin added commands followed by the rest of `git --help`. 
