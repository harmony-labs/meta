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

5. Create a `meta` plugin system
   - Implement a plugin system in `meta` to load plugins from a `.meta-plugins` directory.
   - Create a `meta-git` plugin to add new subcommands for interacting with git repositories.
   - Ensure the plugin system is flexible and can be extended with additional plugins in the future.
   - Plugins are compiled rust libraries that can be added to the `meta` command
   - A plugin system in `meta` will check for the existence of plugins in a `.meta-plugins` folder in the current directory, or in the user's home directory
   - Plugins can add new sub commands to `meta` for interacting with specific functionality
   - A new `meta-git` folder will be created with a `Cargo.toml` file and a `src/lib.rs` file
   - The `meta-git` plugin will be able to add new sub commands to `meta` for interacting with git repositories
   - The `meta-git` will add a `meta git clone [repo]` command that clones a git repository, checks for the existence of a `.meta` file, and clones all the projects specified in the `.meta` file into the current directory
   A new `meta-project` folder will be created with a `Cargo.toml` file and a `src/lib.rs` file
   - The `meta-project` plugin will be able to add new sub commands to `meta` for interacting with projects
   - `meta project update` will update all the projects specified in the `.meta` file. It will clone any resitories that are listed in `.meta`'s `projects` object, but are not currently cloned.
   - `meta project sync` will sync all the projects specified in the `.meta` file. It will start a wizard to step the user through the process of syncing each project. 
      - If a project is not currently cloned, it will ask the user if they want to clone it. If yes, it will clone the project.
      - If a project was removed from the `.meta` file, it will ask the user if they want to remove it. If yes, it will remove the project. (This will be checked by checking for untracked folders in the project directory, specifically if those folders are git repositories but are not listed in the `.meta` file). 
      - If a project is listed in `.meta` but is not listed in `.gitignore`, it will ask the user if they want to add it to `.gitignore`.

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
