#!/bin/bash

# Claude Project Identifier Uninstaller
# This script removes claude-project-identifier from your system

set -e

# Configuration
INSTALL_DIR="${CLAUDE_PROJECT_DIR:-$HOME/.claude-project-identifier}"
SCRIPT_NAME="claude-project-setup"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${RED}Claude Project Identifier Uninstaller${NC}"
echo "====================================="
echo ""

# Check if installed
if [ ! -d "$INSTALL_DIR" ]; then
    echo -e "${YELLOW}Claude Project Identifier is not installed at $INSTALL_DIR${NC}"
    echo "Nothing to uninstall."
    exit 0
fi

# Confirmation
echo -e "${YELLOW}This will remove Claude Project Identifier from your system.${NC}"
echo "Installation directory: $INSTALL_DIR"
echo ""
echo -n "Are you sure you want to uninstall? (y/N) "
read -n 1 -r
echo

if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Uninstall cancelled."
    exit 0
fi

# Remove installation directory
echo -e "${BLUE}Removing installation directory...${NC}"
rm -rf "$INSTALL_DIR"

# Clean up shell configuration
echo -e "${BLUE}Cleaning up shell configuration...${NC}"

# Function to clean shell config
clean_shell_config() {
    local config_file=$1
    if [ -f "$config_file" ]; then
        # Create backup
        cp "$config_file" "$config_file.backup.$(date +%Y%m%d_%H%M%S)"
        
        # Remove Claude Project Identifier lines
        sed -i.tmp '/# Claude Project Identifier/,+2d' "$config_file"
        sed -i.tmp "/claude-project-identifier/d" "$config_file"
        sed -i.tmp "/alias $SCRIPT_NAME/d" "$config_file"
        
        # Clean up temporary file
        rm -f "$config_file.tmp"
        
        echo -e "${GREEN}✓ Cleaned $config_file${NC}"
    fi
}

# Clean bash config
clean_shell_config "$HOME/.bashrc"

# Clean zsh config
clean_shell_config "$HOME/.zshrc"

# Clean fish config if exists
if [ -d "$HOME/.config/fish" ]; then
    clean_shell_config "$HOME/.config/fish/config.fish"
fi

# Optional: Remove project files
echo ""
echo -e "${YELLOW}Do you want to remove Claude Project Identifier files from your projects?${NC}"
echo "This will search for and list CLAUDE.md, .claude-project, and init-project.sh files."
echo -n "Continue? (y/N) "
read -n 1 -r
echo

if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo -e "${BLUE}Searching for project files...${NC}"
    
    # Find project files (limit search depth for performance)
    project_files=$(find "$HOME" -maxdepth 5 -type f \( -name "CLAUDE.md" -o -name ".claude-project" -o -name "init-project.sh" \) 2>/dev/null | grep -v ".claude-project-identifier" || true)
    
    if [ -z "$project_files" ]; then
        echo "No project files found."
    else
        echo -e "${YELLOW}Found the following files:${NC}"
        echo "$project_files"
        echo ""
        echo -n "Remove these files? (y/N) "
        read -n 1 -r
        echo
        
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            echo "$project_files" | while read -r file; do
                rm -f "$file"
                echo -e "${GREEN}✓ Removed $file${NC}"
            done
        else
            echo "Project files kept."
        fi
    fi
fi

# Final cleanup
echo ""
echo -e "${GREEN}Uninstall complete!${NC}"
echo ""
echo "Notes:"
echo "- Shell configuration backups were created with .backup.TIMESTAMP extension"
echo "- You may need to restart your shell or run: source ~/.bashrc"
echo "- To reinstall, visit: https://github.com/ootakazuhiko/claude-project-identifier"

# Remind to reload shell
echo ""
echo -e "${YELLOW}Please reload your shell configuration:${NC}"
echo "  source ~/.bashrc    # for bash"
echo "  source ~/.zshrc     # for zsh"