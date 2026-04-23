# devcontainer

A small Debian-based devcontainer image for day-to-day development.

It ships with a sensible interactive shell setup and a small toolset for containerized development:

- `fish` as the default shell
- `mise` for tool management and task orchestration
- `sudo` with a passwordless `dev` user
- `git`, `curl`, and `openssh-client`
- `tailscale`

Published images are built for `linux/amd64` and `linux/arm64`, signed with keyless Cosign, and include an SBOM.

## Why this image?

This repository is the source for the published image at `ghcr.io/lauritsk/devcontainer`.

It is meant to be:

- small enough to understand and maintain
- predictable for both local use and CI
- easy to consume from VS Code / Dev Containers
- reproducible through `mise`-managed checks and release tasks

## What the container looks like

The image currently:

- starts from a pinned Debian 13 base image
- creates a non-root `dev` user with UID/GID `1000`
- sets `/home/dev` as the working directory
- uses `fish` as the login shell
- enables passwordless sudo for the `dev` user
- activates `mise` automatically in `fish`

## Use it in a Dev Container

A minimal `.devcontainer/devcontainer.json` can point at a published image directly:

```json
{
  "name": "devcontainer",
  "image": "ghcr.io/lauritsk/devcontainer:0.2.0",
  "features": {
    "ghcr.io/devcontainers/features/docker-outside-of-docker:1": {}
  }
}
```

The repository itself uses this shape, with extra persistent mounts for `mise` data and cache:

```json
{
  "name": "devcontainer",
  "image": "ghcr.io/lauritsk/devcontainer:0.2.0@sha256:ba053b40ae21b5f3c4f3b9d80967b1639242c1a6a0a07c61794eb4a2e68dd16d",
  "features": {
    "ghcr.io/devcontainers/features/docker-outside-of-docker:1": {}
  },
  "mounts": [
    "source=devcontainer-mise-data,target=/home/dev/.local/share/mise,type=volume",
    "source=devcontainer-mise-cache,target=/home/dev/.cache/mise,type=volume"
  ]
}
```

> [!TIP]
> Prefer pinning a released tag and digest in consumer repositories for repeatable environments.

## Develop locally

This project uses [`mise`](https://mise.jdx.dev/) for tooling, checks, and release automation.

Common commands:

```sh
mise run setup
mise run lint
mise run build
mise run test
mise run audit
mise run check
```

### Task reference

| Command | Purpose |
| --- | --- |
| `mise run build` | Build the image locally as `localhost/devcontainer:latest` |
| `mise run test` | Run a smoke test against the built image |
| `mise run audit` | Scan the image and repository for high/critical issues |
| `mise run check` | Run the main project quality gates |
| `mise run release:check` | Validate GoReleaser configuration |
| `mise run release:verify` | Run a snapshot release from a clean worktree |
| `mise run sbom` | Generate an SBOM for the repository |

## Release flow

Releases are driven by Conventional Commits and Cocogitto.

```sh
mise run release:version
```

That creates the next Git tag. Pushing the resulting `v*` tag triggers GitHub Actions to publish:

- multi-arch container images to `ghcr.io/lauritsk/devcontainer`
- container signatures via Cosign keyless signing
- release artifacts and metadata via GoReleaser

> [!NOTE]
> Git tags use the form `vX.Y.Z`, while published container tags use `X.Y.Z`.

## Verify a published image

Published images are signed with GitHub Actions OIDC and Cosign.

```sh
cosign verify ghcr.io/lauritsk/devcontainer:X.Y.Z \
  --certificate-identity "https://github.com/lauritsk/devcontainer/.github/workflows/release.yml@refs/tags/vX.Y.Z" \
  --certificate-oidc-issuer "https://token.actions.githubusercontent.com"
```

## CI and publishing

GitHub Actions runs:

- `mise run check` on pushes and pull requests
- `mise run release:verify` as a release dry-run check
- `mise run release` on pushed `v*` tags

The published image metadata is defined in `.goreleaser.yaml`, including:

- OCI labels
- supported platforms
- SBOM generation
- Cosign signing
