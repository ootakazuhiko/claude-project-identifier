#!/bin/bash

# Claude Project Identifier Updater
# This script updates claude-project-identifier to the latest version

set -e

# Configuration
INSTALL_DIR="${CLAUDE_PROJECT_DIR:-$HOME/.claude-project-identifier}"
REPO_URL="https://github.com/ootakazuhiko/claude-project-identifier"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

echo -e "${CYAN}Claude Project Identifier Updater${NC}"
echo "================================"
echo ""

# Check if installed
if [ ! -d "$INSTALL_DIR" ]; then
    echo -e "${RED}Error: Claude Project Identifier is not installed at $INSTALL_DIR${NC}"
    echo "Please install it first using:"
    echo "  curl -sSL https://raw.githubusercontent.com/ootakazuhiko/claude-project-identifier/main/scripts/install.sh | bash"
    exit 1
fi

# Check if it's a git repository
if [ ! -d "$INSTALL_DIR/.git" ]; then
    echo -e "${YELLOW}Warning: Installation directory is not a git repository.${NC}"
    echo "Performing fresh installation..."
    
    # Backup current installation
    echo -e "${BLUE}Creating backup...${NC}"
    mv "$INSTALL_DIR" "$INSTALL_DIR.backup.$(date +%Y%m%d_%H%M%S)"
    
    # Clone fresh copy
    echo -e "${BLUE}Downloading latest version...${NC}"
    git clone "$REPO_URL" "$INSTALL_DIR"
else
    # Get current version
    cd "$INSTALL_DIR"
    CURRENT_VERSION=$(git describe --tags --always 2>/dev/null || echo "unknown")
    echo -e "${BLUE}Current version: $CURRENT_VERSION${NC}"
    
    # Check for updates
    echo -e "${BLUE}Checking for updates...${NC}"
    git fetch origin main --tags
    
    # Get latest version
    LATEST_VERSION=$(git describe --tags --abbrev=0 origin/main 2>/dev/null || echo "latest")
    
    # Check if update is needed
    if [ "$(git rev-parse HEAD)" = "$(git rev-parse origin/main)" ]; then
        echo -e "${GREEN}✓ Already up to date!${NC}"
        exit 0
    fi
    
    echo -e "${YELLOW}Update available: $LATEST_VERSION${NC}"
    
    # Show changes
    echo ""
    echo -e "${BLUE}Changes in the new version:${NC}"
    git log --oneline HEAD..origin/main | head -10
    echo ""
    
    # Confirm update
    echo -n "Do you want to update? (y/N) "
    read -n 1 -r
    echo
    
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Update cancelled."
        exit 0
    fi
    
    # Create backup of current version
    echo -e "${BLUE}Creating backup...${NC}"
    cp -r "$INSTALL_DIR" "$INSTALL_DIR.backup.$(date +%Y%m%d_%H%M%S)"
    
    # Pull latest changes
    echo -e "${BLUE}Updating to latest version...${NC}"
    git pull origin main
fi

# Make scripts executable
echo -e "${BLUE}Setting permissions...${NC}"
chmod +x "$INSTALL_DIR/scripts"/*.sh

# Show what's new
if [ -f "$INSTALL_DIR/CHANGELOG.md" ]; then
    echo ""
    echo -e "${CYAN}What's new:${NC}"
    head -20 "$INSTALL_DIR/CHANGELOG.md" | grep -A 15 "^## \[" | head -15
fi

echo ""
echo -e "${GREEN}✓ Update complete!${NC}"
echo ""

# Check for configuration updates
echo -e "${YELLOW}Checking for configuration updates...${NC}"

# Function to check config version
check_config_updates() {
    local project_file=$1
    local template_file="$INSTALL_DIR/templates/.claude-project.template"
    
    if [ -f "$project_file" ] && [ -f "$template_file" ]; then
        # Compare structure (simplified check)
        local template_keys=$(grep -E '^\s*"[^"]+":' "$template_file" | sort | uniq)
        local project_keys=$(grep -E '^\s*"[^"]+":' "$project_file" | sort | uniq)
        
        if [ "$template_keys" != "$project_keys" ]; then
            echo -e "${YELLOW}Note: New configuration options are available.${NC}"
            echo "  Your config: $project_file"
            echo "  Template: $template_file"
            echo "  Run 'diff $project_file $template_file' to see differences."
            return 1
        fi
    fi
    return 0
}

# Check current directory for project files
if [ -f ".claude-project" ]; then
    echo ""
    if ! check_config_updates ".claude-project"; then
        echo ""
        echo -e "${YELLOW}Consider updating your project configuration to use new features.${NC}"
    else
        echo -e "${GREEN}✓ Your project configuration is up to date.${NC}"
    fi
fi

# Provide migration suggestions
echo ""
echo -e "${CYAN}Next steps:${NC}"
echo "1. Review the changelog: cat $INSTALL_DIR/CHANGELOG.md"
echo "2. Update project configs if needed: claude-project-setup"
echo "3. Check new examples: ls $INSTALL_DIR/examples/"
echo ""
echo -e "${GREEN}Happy coding with Claude Project Identifier!${NC}"