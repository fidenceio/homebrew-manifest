# 🍺 Fidence.io Homebrew Tap

This is a [Homebrew](https://brew.sh/) tap containing formulas for Fidence.io tools and utilities.

## 📦 Available Formulas

### [manifest](Formula/manifest.rb)
A powerful CLI tool for managing manifest files, versioning, and repository operations with trusted timestamp verification.

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

## �� Contributing

To add new formulas or update existing ones:

1. Fork this repository
2. Add your formula to the `Formula/` directory
3. Submit a pull request

## 📄 License

MIT License - see individual formula files for details.
