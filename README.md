# Fidence Homebrew Tap for Manifest

This repository distributes the `manifest` Homebrew formula.

## Install

```bash
brew tap fidenceio/fidenceio-homebrew-tap
brew install manifest
```

## Upgrade

```bash
brew update && brew upgrade manifest
```

## Formula Source of Truth

- `Formula/manifest.rb`

Current formula points to CLI release tarball:

- `https://github.com/fidenceio/manifest.cli/archive/refs/tags/v33.2.0.tar.gz`

## Verify

```bash
manifest --help
manifest test
```

## Notes

- Tap repository version metadata (`VERSION`) tracks tap docs/release bookkeeping and is separate from CLI runtime version.
- Archive docs are retained under `docs/zArchive/` and are not touched during active-doc refreshes.
