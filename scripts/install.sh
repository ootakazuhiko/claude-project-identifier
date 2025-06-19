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
    echo ""
    echo "Options:"
    echo "  1) Update existing installation"
    echo "  2) Remove and reinstall"
    echo "  3) Cancel"
    echo ""
    echo -n "Choose an option (1-3): "
    read -n 1 -r
    echo
    
    case $REPLY in
        1)
            echo -e "${BLUE}Updating existing installation...${NC}"
            cd "$INSTALL_DIR" && git pull origin main
            ;;
        2)
            echo -e "${YELLOW}Backing up and reinstalling...${NC}"
            mv "$INSTALL_DIR" "$INSTALL_DIR.backup.$(date +%Y%m%d_%H%M%S)"
            git clone "$REPO_URL" "$INSTALL_DIR"
            ;;
        *)
            echo "Installation cancelled."
            exit 0
            ;;
    esac
else
    echo -e "${GREEN}Installing to $INSTALL_DIR${NC}"
    git clone "$REPO_URL" "$INSTALL_DIR"
fi

# Make scripts executable
chmod +x "$INSTALL_DIR/scripts"/*.sh
chmod +x "$INSTALL_DIR/scripts/claude-add" 2>/dev/null || true

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
        echo "alias claude-add='$INSTALL_DIR/scripts/add-to-existing.sh'" >> "$SHELL_CONFIG"
        echo "alias claude-project-update='$INSTALL_DIR/scripts/update.sh'" >> "$SHELL_CONFIG"
        echo "alias claude-project-uninstall='$INSTALL_DIR/scripts/uninstall.sh'" >> "$SHELL_CONFIG"
        echo -e "${GREEN}Added to $SHELL_CONFIG${NC}"
    else
        # Update existing aliases in case scripts were added
        if ! grep -q "claude-add" "$SHELL_CONFIG"; then
            echo "alias claude-add='$INSTALL_DIR/scripts/add-to-existing.sh'" >> "$SHELL_CONFIG"
        fi
        if ! grep -q "claude-project-update" "$SHELL_CONFIG"; then
            echo "alias claude-project-update='$INSTALL_DIR/scripts/update.sh'" >> "$SHELL_CONFIG"
        fi
        if ! grep -q "claude-project-uninstall" "$SHELL_CONFIG"; then
            echo "alias claude-project-uninstall='$INSTALL_DIR/scripts/uninstall.sh'" >> "$SHELL_CONFIG"
        fi
    fi
fi

echo ""
echo -e "${GREEN}Installation complete!${NC}"
echo ""
echo "Available commands:"
echo "  claude-project-setup     - Set up a new project"
echo "  claude-add               - Add to existing project"
echo "  claude-project-update    - Update to latest version"
echo "  claude-project-uninstall - Uninstall the tool"
echo ""
echo -e "${YELLOW}For NEW projects:${NC}"
echo "1. Reload your shell: source $SHELL_CONFIG"
echo "2. Go to your project directory"
echo "3. Run: claude-project-setup"
echo ""
echo -e "${YELLOW}For EXISTING projects:${NC}"
echo "1. Reload your shell: source $SHELL_CONFIG"
echo "2. Go to your existing project"
echo "3. Run: claude-add"
echo ""
echo "For more information, visit: $REPO_URL"
