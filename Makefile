RUST_BACKTRACE ?= full
RUST_LOG ?= trace

include Makefile.context.mk

.DEFAULT_GOAL := build-all-and-install

build-all-and-install: build-all install

build-all: build build-plugins

build: 
	cargo build

build-plugins:
	cargo build --release -p meta_git_cli
	cargo build --release -p meta_project_cli
	mkdir -p .meta-plugins
	cp target/release/libmeta_git_cli.dylib .meta-plugins/meta-git-cli.dylib
	cp target/release/libmeta_project_cli.dylib .meta-plugins/meta-project-cli.dylib

clean:
	cargo clean

clean-plugins:
	rm -rf .meta-plugins

copy-plugins-to-home:
	cp -r .meta-plugins ~/.meta-plugins

install:
	cargo install --path meta_cli

rebuild-plugins: clean-plugins build-plugins

release: 
	cargo build --release

rm-meta:
	rm -rf meta

run: 
	cargo run

test:
	RUST_BACKTRACE=$(RUST_BACKTRACE) RUST_LOG=$(RUST_LOG) cargo test --workspace

test-meta-git-clone: rm-meta
	RUST_BACKTRACE=$(RUST_BACKTRACE) RUST_LOG=$(RUST_LOG) cargo run --release --bin meta -- git clone git@github.com:mateodelnorte/meta.git

test-meta-git-clone-depth-1-recursive: rm-meta
	RUST_BACKTRACE=$(RUST_BACKTRACE) RUST_LOG=$(RUST_LOG) cargo run --release --bin meta -- git clone git@github.com:mateodelnorte/meta.git --depth 1 --recursive

test-meta-git-clone-parallel-recursive: rm-meta
	RUST_BACKTRACE=$(RUST_BACKTRACE) RUST_LOG=$(RUST_LOG) cargo run --release --bin meta -- git clone git@github.com:mateodelnorte/meta.git --parallel 4 --recursive

integration-test:
	cargo build -p meta
	RUST_BACKTRACE=$(RUST_BACKTRACE) RUST_LOG=$(RUST_LOG) META_CLI_PATH=target/debug/meta CARGO_BIN_EXE_meta=target/debug/meta cargo test --workspace --tests

.PHONY: install build run test release integration-test
