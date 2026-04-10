# devcontainer

This repository uses `mise` for local tooling and CI orchestration.

Common tasks:

- `mise run lint`
- `mise run test`
- `mise run check`
- `mise run release:check`
- `mise run release:verify`

## Releases

Commits follow Conventional Commits and are versioned with Cocogitto.

- `mise run release:version` creates the next version and tag
- pushing the resulting `v*` tag publishes `ghcr.io/lauritsk/devcontainer`
- `.goreleaser.yaml` uses GoReleaser's experimental `dockers_v2` support for multi-arch Docker releases
