#!/bin/bash

# Claude Project Identifier Installer
# This script installs the claude-project-identifier system

set -e

# Configuration
REPO_URL="https://github.com/ootakazuhiko/claude-project-identifier"
INSTALL_DIR="${CLAUDE_PROJECT_DIR:-$HOME/.claude-project-identifier}"
SCRIPT_NAME="claude-project-setup"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${BLUE}Claude Project Identifier Installer${NC}"
echo "===================================="
echo ""

# Check for existing installation
if [ -d "$INSTALL_DIR" ]; then
    echo -e "${YELLOW}Existing installation found at $INSTALL_DIR${NC}"
    echo -n "Update existing installation? (y/n) "
    read -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Installation cancelled."
        exit 0
    fi
    cd "$INSTALL_DIR" && git pull
else
    echo -e "${GREEN}Installing to $INSTALL_DIR${NC}"
    git clone "$REPO_URL" "$INSTALL_DIR"
fi

# Make scripts executable
chmod +x "$INSTALL_DIR/scripts"/*.sh

# Add to PATH
SHELL_CONFIG=""
if [ -n "$ZSH_VERSION" ]; then
    SHELL_CONFIG="$HOME/.zshrc"
elif [ -n "$BASH_VERSION" ]; then
    SHELL_CONFIG="$HOME/.bashrc"
fi

if [ -n "$SHELL_CONFIG" ]; then
    if ! grep -q "claude-project-identifier" "$SHELL_CONFIG"; then
        echo "" >> "$SHELL_CONFIG"
        echo "# Claude Project Identifier" >> "$SHELL_CONFIG"
        echo "export PATH=\"\$PATH:$INSTALL_DIR/scripts\"" >> "$SHELL_CONFIG"
        echo "alias $SCRIPT_NAME='$INSTALL_DIR/scripts/setup.sh'" >> "$SHELL_CONFIG"
        echo -e "${GREEN}Added to $SHELL_CONFIG${NC}"
    fi
fi

echo ""
echo -e "${GREEN}Installation complete!${NC}"
echo ""
echo "Next steps:"
echo "1. Reload your shell: source $SHELL_CONFIG"
echo "2. Go to your project directory"
echo "3. Run: $SCRIPT_NAME"
echo ""
echo "For more information, visit: $REPO_URL"
