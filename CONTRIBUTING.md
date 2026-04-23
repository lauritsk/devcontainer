# Contributing

## Development setup

This repository uses `mise` for local tooling and task orchestration. Assume only `mise` is installed globally.

```bash
mise install
mise run setup
```

`mise run setup` installs the git pre-commit hook used by this repository.

## Common tasks

| Goal | Command |
| --- | --- |
| Lint the Dockerfile, Actions, and shell scripts | `mise run lint` |
| Build the local devcontainer image | `mise run build` |
| Run the container smoke test | `mise run test` |
| Audit the built image for OS vulnerabilities | `mise run audit:image` |
| Run the full local check suite | `mise run check` |
| Generate an SBOM | `mise run sbom` |

> [!IMPORTANT]
> `mise run build`, `mise run test`, and `mise run audit:image` require a working local Docker daemon.

## Commits

Commits must follow Conventional Commits. Cocogitto enforces this locally and in CI.

Create commits through `mise`:

- `mise exec cocogitto -- cog commit <type> "<message>" [scope]`
- add `-B` for breaking changes
- run `mise run check:commits` to validate commit messages locally

Examples:

- `feat: add new base package`
- `fix: keep dev user shell initialization portable`
- `docs: clarify image smoke tests`

## Pull requests

Before opening a pull request:

- run `mise run check`
- use a Conventional Commit title for the pull request
- update docs when image behavior changes
- keep changes focused and small when possible

## Releases

Releases are managed through `mise`, Cocogitto, and GoReleaser.

- `mise run release:version` creates the next version and tag
- `mise run release:check` validates release configuration
- `mise run release:verify` runs the release pipeline locally in verification mode
- push the resulting commit and `v*` tag to trigger the release workflow
