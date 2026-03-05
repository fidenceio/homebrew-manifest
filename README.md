## 📋 Version Information

| Property | Value |
|----------|-------|
| **Current Version** | `1.2.0` |
| **Release Date** | `2026-03-05 23:23:33 UTC` |
| **Git Tag** | `v1.2.0` |
| **Branch** | `main` |
| **Last Updated** | `2026-03-05 23:23:33 UTC` |
| **CLI Version** | `1.2.0` |

---
*This repo is versioned and documented by [Manifest CLI](https://github.com/fidenceio/manifest.cli).*
## 📦 Available Formulas

### [manifest](Formula/manifest.rb)
A powerful CLI tool for versioning, AI documenting, and repository operations.

**Install:**
```bash
# Add the tap
brew tap fidenceio/fidenceio-homebrew-tap

# Install manifest
brew install manifest
```

**Features:**
- 🚀 Complete automated workflow management
- 🕐 Trusted timestamp verification
- 📚 Automatic documentation generation
- 🏷️ Git operations and version management
- 🖥️ Cross-platform OS detection and optimization

## 🧭 Overall Manifest Strategy

This tap is one part of a coordinated three-repository strategy:

- **CLI (`manifest.cli`)**: command workflow and release orchestration
- **Cloud (`manifest.cloud`)**: AI intelligence and recommendation services
- **Tap (`homebrew.tap`)**: package distribution and upgrade delivery

North Star references:

- [Manifest CLI North Star](https://github.com/fidenceio/manifest.cli/blob/main/docs/NORTH_STAR.md)
- [Manifest Cloud North Star](https://github.com/fidenceio/manifest.cloud/blob/main/docs/NORTH_STAR.md)
- [Homebrew Tap North Star](NORTH_STAR.md)

## 🔧 Adding This Tap

```bash
brew tap fidenceio/fidenceio-homebrew-tap
```

## 📋 Requirements

- macOS or Linux
- Homebrew installed
- Git (recommended)
- Node.js >=16.0.0

## 🚀 Quick Start

```bash
# Add the tap and install manifest
brew tap fidenceio/fidenceio-homebrew-tap
brew install manifest

# Test the installation
manifest --help
manifest test
```

## 📚 Documentation

- **Manifest CLI**: [https://github.com/fidenceio/manifest.cli](https://github.com/fidenceio/manifest.cli)
- **Homebrew**: [https://brew.sh/](https://brew.sh/)

## 🤝 Contributing

To add new formulas or update existing ones:

1. Fork this repository
2. Add your formula to the `Formula/` directory
3. Submit a pull request

## 📄 License

MIT License - see individual formula files for details.
