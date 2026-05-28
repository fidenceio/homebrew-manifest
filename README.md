# Homebrew Tap For Manifest CLI

This repository distributes Manifest CLI through Homebrew.

Product source and release notes live in [fidenceio/manifest.cli](https://github.com/fidenceio/manifest.cli). This tap should stay narrow: formula metadata, installation instructions, and formula-update history.

## Install

```bash
brew tap fidenceio/tap
brew install manifest
```

Upgrade:

```bash
brew update
brew upgrade manifest
```

## Formula

| File | Purpose |
| ---- | ------- |
| [Formula/manifest.rb](Formula/manifest.rb) | Homebrew formula for Manifest CLI |

The formula installs the CLI source under Homebrew `libexec`, writes a wrapper at `bin/manifest`, installs Bash and zsh completions, and depends on Bash, yq, Git, and coreutils.

## Release Flow

The canonical Manifest CLI release path updates this tap after a CLI release artifact is available.

Expected release flow:

1. CLI release updates `fidenceio.manifest.cli`.
2. CLI release automation computes the new formula URL and SHA.
3. Tap commit updates `Formula/manifest.rb`.
4. Users receive the new formula through `brew update && brew upgrade manifest`.

## Maintainer Checks

Run tap checks through Homebrew in an environment intended for packaging validation. Do not install repository development dependencies on the host for this workspace.

Useful read-only checks:

```bash
git status --short --branch
brew info manifest
brew audit --formula Formula/manifest.rb
```

## Documentation

- [CHANGELOG.md](CHANGELOG.md)
- [docs/INDEX.md](docs/INDEX.md)
- Product docs: [Manifest CLI documentation](https://github.com/fidenceio/manifest.cli/tree/main/docs)

