# Repository Guidelines

## Project Structure & Module Organization

This repository is currently an empty project scaffold; no source, test, or asset directories have been committed yet. Keep the root reserved for project-wide files such as `README.md`, build configuration, and this guide. As the project grows, group implementation code by responsibility rather than placing it directly in the root. Use conventional top-level locations such as `src/` for source code, `tests/` for automated tests, `scripts/` for developer utilities, and `docs/` for longer documentation. Store fixtures beside the tests that consume them or under `tests/fixtures/`.

## Build, Test, and Development Commands

No build system or development commands are defined yet. When adding one, expose a small, discoverable command set through a `Makefile` or the ecosystem's standard task runner. Prefer stable entry points such as:

- `make build` — produce local build artifacts.
- `make test` — run the complete automated test suite.
- `make lint` — run formatting and static-analysis checks.
- `make clean` — remove generated artifacts only.

Document required tools and exact setup steps in `README.md`. Do not commit generated output, caches, or local environment files.

## Coding Style & Naming Conventions

Follow the formatter and linter standard for the language introduced, and commit their configuration with the first source files. Use spaces unless the chosen toolchain requires tabs (for example, recipe lines in a `Makefile`). Choose descriptive names: `snake_case` for scripts and shell functions, `kebab-case` for documentation filenames, and the language's normal convention for symbols. Keep modules focused and comments limited to non-obvious decisions.

## Testing Guidelines

Add tests with every behavior change and bug fix. Mirror source organization under `tests/`, and name tests after observable behavior, such as `test_rejects_invalid_config`. Tests must be deterministic, isolated from developer machines, and runnable with one documented command. New tooling should include a basic smoke test in CI.

## Commit & Pull Request Guidelines

There is no Git history in the current scaffold from which to infer an existing convention. Use short, imperative commit subjects, optionally with a conventional prefix, such as `docs: add setup instructions` or `fix: reject empty image path`. Keep each commit focused. Pull requests should explain the motivation and approach, list verification commands and results, link relevant issues, and include screenshots or logs when user-visible behavior changes.
