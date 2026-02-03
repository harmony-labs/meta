# Changelog

## [0.3.0](https://github.com/harmony-labs/meta/compare/meta-v0.2.3...meta-v0.3.0) (2026-02-03)


### ⚠ BREAKING CHANGES

* remove trailing meta flag interception (meta-26)
* .meta JSON config replaced by .meta.yaml
* Unrecognized top-level commands no longer fall through to `meta exec`. Use explicit `meta exec <command>` instead.

### Features

* add AI-dominance features, MCP tools, and distribution ([33103c6](https://github.com/harmony-labs/meta/commit/33103c6d138c2cbcac55be9ff5a99bcd63a47c32))
* add automated crates.io publish and Homebrew update to release ([3786ba0](https://github.com/harmony-labs/meta/commit/3786ba08012bfa8c82c27b2c16c1b0e57db0a8fc))
* add automated versioning with conventional commits ([bdf952d](https://github.com/harmony-labs/meta/commit/bdf952db3a0f1b65ef4ef3568d6a8fb7a6f2c609))
* add bats integration tests to CI ([8daf83d](https://github.com/harmony-labs/meta/commit/8daf83d6d67fc0613450559b5db74225696197b8))
* add BATS integration tests, rename --include-only to --include ([de904cc](https://github.com/harmony-labs/meta/commit/de904cc6ecb0f8fc00cc2a3071731c5f401bac48))
* Add Cargo.toml ([c4e2e4b](https://github.com/harmony-labs/meta/commit/c4e2e4b6dde018129501369216157fddeb4c933e))
* add Claude Code hooks for meta context and agent guard ([1d17d85](https://github.com/harmony-labs/meta/commit/1d17d85716ff735de9cd0a5a5ef7f4bc4432f585))
* add Claude Code rules and init integration tests (meta-28) ([4ba2be5](https://github.com/harmony-labs/meta/commit/4ba2be5940db5de045c703d6d510454d7d0e3833))
* add Claude Code settings template with Stop hook (meta-17) ([720bf56](https://github.com/harmony-labs/meta/commit/720bf5607a0feb62e74d1f102e848ba30f92758e))
* add colored verbose output. add initial integration test ([122a2c8](https://github.com/harmony-labs/meta/commit/122a2c807a458f790cca4a1b934b733a0e9fb33a))
* add default agent guard config and update lockfile (meta-32) ([2c8185a](https://github.com/harmony-labs/meta/commit/2c8185a364e362d4a72324f9044e1a50d2707080))
* add dependencies to Cargo.toml ([17f3595](https://github.com/harmony-labs/meta/commit/17f35953276edfbe74255b9ac87e1b128286c82f))
* Add dependency on loop_lib ([7dba057](https://github.com/harmony-labs/meta/commit/7dba057dd1354de6e2b35328281e258ea5cee978))
* add GitHub Actions CI/CD and meta_git workspace member ([3210b2d](https://github.com/harmony-labs/meta/commit/3210b2d41dec8afaffc18cbc0b3b236f182bb655))
* add global strict mode tests and documentation (meta-34) ([f49bf7b](https://github.com/harmony-labs/meta/commit/f49bf7bc06ed701d28ec68a87f0bae26fd0ad552))
* add handler for child repo update notifications ([059a338](https://github.com/harmony-labs/meta/commit/059a33841ef56dee8eedcdb79c3d5da86b598322))
* add meta_mcp to workspace ([192ad81](https://github.com/harmony-labs/meta/commit/192ad8177526997eb60c7f6d7e69e4928a5706fb))
* add meta-6 cloud worktree tests and documentation ([2fcf750](https://github.com/harmony-labs/meta/commit/2fcf750d9b75e74ce66c2b36615bff9b8d56ae33))
* add new Makefile target for building, installing, and copying plugins ([3c08001](https://github.com/harmony-labs/meta/commit/3c08001b38e6679c55a6640253d26a73fa6fd3b1))
* add plugin help system and multi-commit support ([4038ab8](https://github.com/harmony-labs/meta/commit/4038ab8708a6fe43a3c5f7c024f1c2b7dbab4a1a))
* Add plugin system to `meta` for enhanced functionality and commands ([8bebf0f](https://github.com/harmony-labs/meta/commit/8bebf0fda1818ec75c6a737303aafba6a124a1e1))
* add Windows PowerShell installation script ([a88fc13](https://github.com/harmony-labs/meta/commit/a88fc1353ee6549346723ba9b9ce64f8695c97dd))
* add workspace package metadata for version inheritance ([3335a37](https://github.com/harmony-labs/meta/commit/3335a37e828df557d207f00a546ff866ba3c3db4))
* adding loop_lib tests and loop README ([5a6b75b](https://github.com/harmony-labs/meta/commit/5a6b75bf00432b3965f2a8197b6c0ad5e0d447c7))
* Claude Code plugin package and skill improvements (meta-20) ([f353b22](https://github.com/harmony-labs/meta/commit/f353b227fd3c6dc865e099e1d2aac4c60dd4ad36))
* expand distribution to include meta-project and loop ([49d16ab](https://github.com/harmony-labs/meta/commit/49d16ab76cb92d85d83ba6da9f6fafa3bca4f68d))
* implement composable validator system for agent guard (meta-32) ([323a3c8](https://github.com/harmony-labs/meta/commit/323a3c8ab931b6c189564157406abfcb291a1843))
* Implement plugin system in `meta` and add `meta-git` plugin ([3d590a0](https://github.com/harmony-labs/meta/commit/3d590a07af200983ac3e54c860ee7892583a8820))
* integrate meta_git_lib into project ecosystem ([e26e73d](https://github.com/harmony-labs/meta/commit/e26e73df5c3a9dde76ccb2a85f99f5102f5ce42a))
* **meta_cli:** implement M7 plugin update command ([8daa183](https://github.com/harmony-labs/meta/commit/8daa18395551d1b50ebbc3315ba3862650851601))
* **meta_cli:** test dispatch ([bd5bb56](https://github.com/harmony-labs/meta/commit/bd5bb5609e2efc46929f2f3d19898fb526c0274f))
* **project-structure:** reorganize context files and enhance gitignore ([43d8dab](https://github.com/harmony-labs/meta/commit/43d8dabda61834666030f1b8d2cd4f2803244529))
* refactor CONTEXT.md for meta-rust rewrite with plugin-centric vision ([8e087f7](https://github.com/harmony-labs/meta/commit/8e087f78fa8053cea5b1eb8c6a025c42653138a6))
* refactor for smaller, more concise ([aefcd3a](https://github.com/harmony-labs/meta/commit/aefcd3ae1606b845489e0f22f546a98099ad6073))
* remove implicit exec fallback for LLM safety (meta-7) ([327c985](https://github.com/harmony-labs/meta/commit/327c9858170a37cac9dd11be2084ae791084b4e6))
* remove trailing meta flag interception (meta-26) ([e7319d0](https://github.com/harmony-labs/meta/commit/e7319d01a8cef4c2c3d49fb17c7428f09775ddc1))
* Set up Cargo workspace for meta and loop ([19dbf4e](https://github.com/harmony-labs/meta/commit/19dbf4e0b888b0f9286a3aff3bad1f5812419ade))
* streaming child command output. --add-aliases-to-global-looprc command added. able to leverage cached aliases. TODO: ensure color/streaming of child commands after cwd ([2f2f6e8](https://github.com/harmony-labs/meta/commit/2f2f6e81821f34b5153581c5448d714ba9a684d4))
* switch to release-please for automated versioning ([acae04f](https://github.com/harmony-labs/meta/commit/acae04f2a6e3522b86f05e4d9f792395d6d12044))
* test automated versioning ([9ae4cef](https://github.com/harmony-labs/meta/commit/9ae4ceffedca4f51b1e3fd7c02f33779dc047322))
* transition .meta to .meta.yaml with dependency data (meta-18) ([e4f9166](https://github.com/harmony-labs/meta/commit/e4f91668ce3d7939b550176e320f8a129a01fd3d))
* Update all files to refer to the expected executable as `meta`, not `meta-rs` ([fa03977](https://github.com/harmony-labs/meta/commit/fa03977a38d4d51465b354e7296e8588e6e8253e))
* Update implementation plan for meta tool ([0803b2e](https://github.com/harmony-labs/meta/commit/0803b2ef8297650814bd0c0c45895d5638f47084))


### Bug Fixes

* add workflow_dispatch for testing and improve payload handling ([4a9e55f](https://github.com/harmony-labs/meta/commit/4a9e55fc371c1d81196b37ca49ffac1876593028))
* **ci:** use PAT for sync commits to trigger downstream workflows ([50982c3](https://github.com/harmony-labs/meta/commit/50982c32eb8fa8608d85dfe11b086dd3d980556d))
* clone child repos in CI workflows (meta-repo architecture) ([af067f5](https://github.com/harmony-labs/meta/commit/af067f5f7f264f00582c75c7c694c80d3c6d2d6b))
* configure release-please to update VERSION file ([3fd4d58](https://github.com/harmony-labs/meta/commit/3fd4d58a4fb5688917e8ee04ca15678333d57f2f))
* explicitly pass DEPLOY_KEY to external workflow ([4f59d4b](https://github.com/harmony-labs/meta/commit/4f59d4b80c2464aa3edf0da981f414dab655f3d6))
* fixing meta_rust_cli git repo path ([7320fe8](https://github.com/harmony-labs/meta/commit/7320fe8fd8171ccff384d0651c4e5e7bea8a2b3b))
* fixing test make target ([2db442f](https://github.com/harmony-labs/meta/commit/2db442f6213601a8d7eea515d934bafb806cb267))
* fixing workspace Cargo.toml for updated folder project names ([57a33fd](https://github.com/harmony-labs/meta/commit/57a33fde791ad5d95ab94b04da6261bfdde3b4b1))
* handle repository_dispatch in release workflow ([3c48892](https://github.com/harmony-labs/meta/commit/3c48892c1fda9ff0e398a476e902a4ec75c56882))
* **meta_cli:** remove dead code wrapper function ([046a663](https://github.com/harmony-labs/meta/commit/046a663680c6f30702c19dc6d593e5ed7519414f))
* **meta_cli:** remove needless borrow in test ([a391dbf](https://github.com/harmony-labs/meta/commit/a391dbf7f8740d5a2d59a76a67e0b41dd36d8da7))
* **meta_cli:** repository dispatch test ([188ad78](https://github.com/harmony-labs/meta/commit/188ad78a37cc7dd0c34564d61717eea9be3dec53))
* **meta_cli:** support .meta.json and skip directories in config discovery ([0b0e71d](https://github.com/harmony-labs/meta/commit/0b0e71d47be1320613909311b41074ad9cea3cee))
* plugin discovery and config file resolution ([c20598b](https://github.com/harmony-labs/meta/commit/c20598bffd747c9b12b118a17599de4bfabf485b))
* Remove package section from Cargo.toml to resolve manifest error ([2bfe3b8](https://github.com/harmony-labs/meta/commit/2bfe3b882c9a580283ee635357aee4c7a806b9fd))
* resolve build issues and update dependencies ([220b55b](https://github.com/harmony-labs/meta/commit/220b55bf589773caf92e2c08ed3ebf6280e8d327))
* Set Rust version and create workspace Cargo.toml ([51e73ff](https://github.com/harmony-labs/meta/commit/51e73ff168a5c5a78fd0fa74503b68ae7c7000b6))
* **tests:** fix bats integration tests for M4 ([10a0015](https://github.com/harmony-labs/meta/commit/10a0015d3036aa60e22df38d296c1cedc62047cc))
* **tests:** use .meta/plugins/ and .meta.json in bats tests ([81b2b4e](https://github.com/harmony-labs/meta/commit/81b2b4e26edce919b1a73f83f5f36eb121dcbd7b))

## [0.2.3](https://github.com/harmony-labs/meta/compare/v0.2.2...v0.2.3) (2026-02-03)


### Bug Fixes

* **ci:** use PAT for sync commits to trigger downstream workflows ([50982c3](https://github.com/harmony-labs/meta/commit/50982c32eb8fa8608d85dfe11b086dd3d980556d))
* **meta_cli:** remove dead code wrapper function ([046a663](https://github.com/harmony-labs/meta/commit/046a663680c6f30702c19dc6d593e5ed7519414f))
* **meta_cli:** remove needless borrow in test ([a391dbf](https://github.com/harmony-labs/meta/commit/a391dbf7f8740d5a2d59a76a67e0b41dd36d8da7))
* **meta_cli:** support .meta.json and skip directories in config discovery ([0b0e71d](https://github.com/harmony-labs/meta/commit/0b0e71d47be1320613909311b41074ad9cea3cee))
* plugin discovery and config file resolution ([c20598b](https://github.com/harmony-labs/meta/commit/c20598bffd747c9b12b118a17599de4bfabf485b))
* **tests:** use .meta/plugins/ and .meta.json in bats tests ([81b2b4e](https://github.com/harmony-labs/meta/commit/81b2b4e26edce919b1a73f83f5f36eb121dcbd7b))

## [0.2.2](https://github.com/harmony-labs/meta/compare/v0.2.1...v0.2.2) (2026-02-02)


### Features

* add bats integration tests to CI ([8daf83d](https://github.com/harmony-labs/meta/commit/8daf83d6d67fc0613450559b5db74225696197b8))

## [0.2.1](https://github.com/harmony-labs/meta/compare/v0.2.0...v0.2.1) (2026-02-01)


### Features

* add handler for child repo update notifications ([059a338](https://github.com/harmony-labs/meta/commit/059a33841ef56dee8eedcdb79c3d5da86b598322))
* **meta_cli:** test dispatch ([bd5bb56](https://github.com/harmony-labs/meta/commit/bd5bb5609e2efc46929f2f3d19898fb526c0274f))


### Bug Fixes

* add workflow_dispatch for testing and improve payload handling ([4a9e55f](https://github.com/harmony-labs/meta/commit/4a9e55fc371c1d81196b37ca49ffac1876593028))
* configure release-please to update VERSION file ([3fd4d58](https://github.com/harmony-labs/meta/commit/3fd4d58a4fb5688917e8ee04ca15678333d57f2f))
* handle repository_dispatch in release workflow ([3c48892](https://github.com/harmony-labs/meta/commit/3c48892c1fda9ff0e398a476e902a4ec75c56882))
* **meta_cli:** repository dispatch test ([188ad78](https://github.com/harmony-labs/meta/commit/188ad78a37cc7dd0c34564d61717eea9be3dec53))

## [0.2.0](https://github.com/harmony-labs/meta/compare/v0.1.3...v0.2.0) (2026-02-01)


### Features

* switch to release-please for automated versioning ([acae04f](https://github.com/harmony-labs/meta/commit/acae04f2a6e3522b86f05e4d9f792395d6d12044))
* test automated versioning ([9ae4cef](https://github.com/harmony-labs/meta/commit/9ae4ceffedca4f51b1e3fd7c02f33779dc047322))


### Bug Fixes

* explicitly pass DEPLOY_KEY to external workflow ([4f59d4b](https://github.com/harmony-labs/meta/commit/4f59d4b80c2464aa3edf0da981f414dab655f3d6))
