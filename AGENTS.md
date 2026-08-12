# Repository Guidelines

## Project Structure & Module Organization

This repository contains the reproducible build inputs for an ImmortalWrt x86-64 EFI image. Keep the root reserved for project-wide files such as `README.md`, `Makefile`, and this guide. Keep ImageBuilder configuration in `config/`, container setup in `docker/`, firmware overlay files in `files/`, and build helpers in `scripts/`. Do not commit firmware images, downloaded ImageBuilder archives, caches, or local backups.

## Build, Test, and Development Commands

Use the Makefile's small, discoverable command set:

- `make build` — produce local build artifacts.
- `make check` — run static validation for tracked build inputs.

Document required tools and exact setup steps in `README.md`. Do not commit generated output, caches, or local environment files. GitHub Actions is the authoritative full build environment.

## Coding Style & Naming Conventions

Use POSIX shell for firmware init scripts and Bash for host build helpers. Preserve the existing tab indentation in shell scripts; use tabs only for Makefile recipes. Choose descriptive names, keep modules focused, and limit comments to non-obvious decisions.

## Testing Guidelines

Add deterministic checks for build-script behavior changes. `make check` must remain runnable without Docker, downloaded build assets, or a local firmware image, and GitHub Actions must run it before the full firmware build.

## Commit & Pull Request Guidelines

There is no Git history in the current scaffold from which to infer an existing convention. Use short, imperative commit subjects, optionally with a conventional prefix, such as `docs: add setup instructions` or `fix: reject empty image path`. Keep each commit focused. Pull requests should explain the motivation and approach, list verification commands and results, link relevant issues, and include screenshots or logs when user-visible behavior changes.
