include Makefile.context.mk

.DEFAULT_GOAL := build

build: 
	cargo build

install:
	cargo install --path .

release: 
	cargo build --release

run: 
	cargo run

test: 
	cargo test

.PHONY: install build run test release
