# Changelog

## [0.2.7](https://github.com/harmony-labs/meta/compare/v0.2.6...v0.2.7) (2026-02-03)


### Bug Fixes

* improve VERSION sync comment formatting ([4357697](https://github.com/harmony-labs/meta/commit/435769711d39d09dd903b2e8b56063248f3c3e81))

## [0.2.6](https://github.com/harmony-labs/meta/compare/v0.2.5...v0.2.6) (2026-02-03)


### Bug Fixes

* pull before pushing VERSION sync to avoid race condition ([acfca5f](https://github.com/harmony-labs/meta/commit/acfca5ffc2cd7fb4cef865249506163bb62cc197))

## [0.2.5](https://github.com/harmony-labs/meta/compare/v0.2.4...v0.2.5) (2026-02-03)


### Bug Fixes

* ensure VERSION file ends with newline ([8f80d55](https://github.com/harmony-labs/meta/commit/8f80d5585433f7de2e0f66e0b6028ba446ad48af))
* trigger release build after VERSION sync completes ([90948fc](https://github.com/harmony-labs/meta/commit/90948fcfe3aacc779d37146822c7df8affe3f171))

## [0.2.4](https://github.com/harmony-labs/meta/compare/v0.2.3...v0.2.4) (2026-02-03)


### Features

* automate VERSION file sync after release creation ([9b02426](https://github.com/harmony-labs/meta/commit/9b02426897a1669c35f51eb2b67d967da0d4a912))


### Bug Fixes

* add checkout step before release-please ([b66d78a](https://github.com/harmony-labs/meta/commit/b66d78ad39cae89963dff70354a085d5a046af73))
* add root package to Cargo.toml for rust release type ([6e3bdfa](https://github.com/harmony-labs/meta/commit/6e3bdfac8a4c73215b03ea0f0969b373ac7e75db))
* create Cargo.toml dynamically in CI instead of tracking in repo ([0c85eb9](https://github.com/harmony-labs/meta/commit/0c85eb99572c6c7431f90740388a45349b8bf2eb))
* remove workspace Cargo.toml and use meta exec in CI ([91b39a0](https://github.com/harmony-labs/meta/commit/91b39a03e289a99d718fb239fed374f30a430805))
* restore workspace Cargo.toml and CI to working state ([4f539c9](https://github.com/harmony-labs/meta/commit/4f539c903e71851284ecc3b59a034aa2b00dad68))
* restore workspace Cargo.toml and revert to simple release type ([f989639](https://github.com/harmony-labs/meta/commit/f989639d534acf25ad6b262313c53ccecd5585eb))
* use explicit type for VERSION in extra-files ([c3e479a](https://github.com/harmony-labs/meta/commit/c3e479ac4f15a96d1aefc837a9730be5c3f27b1a))

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
