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

### Step 1: Install Claude Project Identifier

```bash
# One-line installation (recommended)
curl -sSL https://raw.githubusercontent.com/ootakazuhiko/claude-project-identifier/main/scripts/install.sh | bash

# Or with wget
wget -qO- https://raw.githubusercontent.com/ootakazuhiko/claude-project-identifier/main/scripts/install.sh | bash

# Or manual installation
git clone https://github.com/ootakazuhiko/claude-project-identifier.git
cd claude-project-identifier
./scripts/setup.sh
```

### Step 2: Set Up Your Project

Navigate to your project directory and run the setup:

```bash
cd /path/to/your/project

# Option 1: Interactive setup (recommended)
claude-project-setup
# Follow the prompts to configure your project

# Option 2: Manual setup
cp ~/.claude-project-identifier/templates/CLAUDE.md.template ./CLAUDE.md
cp ~/.claude-project-identifier/templates/.claude-project.template ./.claude-project
cp ~/.claude-project-identifier/templates/init-project.sh.template ./init-project.sh
chmod +x init-project.sh
# Then edit the files to match your project
```

### Step 3: Test Your Setup

```bash
# If you have a Makefile
make info

# Or run directly
./init-project.sh
```

You should see your project information displayed with a waiting indicator!

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

## 📋 Setup Steps Summary

1. **Install the tool** (one-time setup)
   ```bash
   curl -sSL https://raw.githubusercontent.com/ootakazuhiko/claude-project-identifier/main/scripts/install.sh | bash
   ```

2. **Apply to your project**
   ```bash
   cd /path/to/your/project
   claude-project-setup  # Interactive setup
   ```

3. **Customize** (edit the generated files)
   - `CLAUDE.md` - Project instructions for Claude Code
   - `.claude-project` - Project configuration
   - `init-project.sh` - Display script

4. **Test**
   ```bash
   make info  # or ./init-project.sh
   ```

## 🔄 Update & Uninstall

### Update to Latest Version

```bash
# Automatic update
~/.claude-project-identifier/scripts/update.sh

# Or pull latest changes
cd ~/.claude-project-identifier && git pull
```

### Uninstall

```bash
# Complete uninstall
~/.claude-project-identifier/scripts/uninstall.sh

# Or manual removal
rm -rf ~/.claude-project-identifier
# Then remove PATH entries from ~/.bashrc or ~/.zshrc
```

## 📖 Documentation

- [Setup Guide](docs/setup-guide.md) - Detailed installation instructions
- [Customization](docs/customization.md) - How to customize displays
- [Examples](examples/) - Sample configurations for different project types
- [Troubleshooting](docs/troubleshooting.md) - Common issues and solutions
- [Uninstall & Update](docs/uninstall-update.md) - How to update or remove

## 🛠️ Configuration

The system requires three files in your project root:

1. **CLAUDE.md** - Instructions for Claude Code
   - Tells Claude Code how to display project information
   - Contains project overview and development commands

2. **.claude-project** - Project configuration (JSON)
   - Defines project metadata (name, version, type)
   - Customizes banners, colors, and waiting messages
   - Configures what information to display

3. **init-project.sh** - Display script
   - Bash script that renders the project information
   - Reads configuration from `.claude-project`
   - Can be called via `make info` or directly

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
