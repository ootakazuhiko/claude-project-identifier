# Claude Project Identifier

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![GitHub release](https://img.shields.io/github/release/ootakazuhiko/claude-project-identifier.svg)](https://github.com/ootakazuhiko/claude-project-identifier/releases)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg?style=flat-square)](http://makeapullrequest.com)

A project identification and context display system for Claude Code (claude.ai/code) that helps maintain project awareness and shows waiting status.

## ✨ Features

- 🎯 **Automatic Project Identification** - Display project info when Claude Code starts
- 👁️ **Waiting Status Indicator** - Clear visual feedback when waiting for user input
- 🎨 **Customizable Banners** - ASCII and Unicode banner options
- 🚀 **Quick Setup** - Get running in under 3 minutes
- 🌍 **Multi-language Support** - Works with any programming language
- 📦 **Zero Dependencies** - Pure bash implementation

## 🚀 Quick Start

### One-line Installation

```bash
curl -sSL https://raw.githubusercontent.com/ootakazuhiko/claude-project-identifier/main/scripts/install.sh | bash
```

Or with wget:
```bash
wget -qO- https://raw.githubusercontent.com/ootakazuhiko/claude-project-identifier/main/scripts/install.sh | bash
```

### Manual Installation

```bash
git clone https://github.com/ootakazuhiko/claude-project-identifier.git
cd claude-project-identifier
./scripts/setup.sh
```

## 📸 What It Looks Like

When you start Claude Code in a configured project:

```
[WAITING] 👁️ Ready for your command...
================================================
 Project: My Awesome Project
 Type: Web Application
 Environment: Development
 Current Directory: /home/user/projects/awesome
 Time: 2024-06-19 10:30:45
================================================

▶ Project Information
  ├─ Name: My Awesome Project
  ├─ Version: 1.0.0
  ├─ Status: Active Development
  └─ Tech Stack: Node.js, React, PostgreSQL

▶ Quick Commands
  ├─ make info    - Show this information
  ├─ npm start    - Start development server
  └─ npm test     - Run tests

Ready to start working on My Awesome Project!
```

## 📖 Documentation

- [Setup Guide](docs/setup-guide.md) - Detailed installation instructions
- [Customization](docs/customization.md) - How to customize displays
- [Examples](examples/) - Sample configurations for different project types
- [Troubleshooting](docs/troubleshooting.md) - Common issues and solutions

## 🛠️ Configuration

The system uses two main files:

1. **CLAUDE.md** - Instructions for Claude Code
2. **.claude-project** - Project configuration (JSON)

Example `.claude-project`:
```json
{
  "project": {
    "name": "My Project",
    "type": "Web Application",
    "version": "1.0.0"
  },
  "display": {
    "waiting_indicators": [
      "[WAITING] 🚀 Ready to build something amazing...",
      "[WAITING] 💡 What shall we create today?"
    ]
  }
}
```

## 🤝 Contributing

We welcome contributions! Please see [CONTRIBUTING.md](CONTRIBUTING.md) for details.

### Development

```bash
# Run tests
./tests/run-all-tests.sh

# Validate templates
./scripts/validate.sh
```

## 📄 License

MIT License - see [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- Inspired by the need for better AI-human collaboration
- Thanks to all contributors and users

## 🔗 Links

- [Changelog](CHANGELOG.md)
- [Report Issues](https://github.com/ootakazuhiko/claude-project-identifier/issues)
- [Discussions](https://github.com/ootakazuhiko/claude-project-identifier/discussions)
