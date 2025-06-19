#!/bin/bash

# Claude Project Template Setup Script
# This script helps set up the Claude Code project identification system

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m'
BOLD='\033[1m'

echo -e "${CYAN}${BOLD}Claude Code Project Setup${NC}"
echo -e "${CYAN}=========================${NC}"
echo ""

# Find the script's directory
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
TEMPLATE_DIR="$SCRIPT_DIR/../templates"

# Check if template files exist
if [ ! -f "$TEMPLATE_DIR/CLAUDE.md.template" ]; then
    echo -e "${RED}Error: Template files not found in $TEMPLATE_DIR${NC}"
    echo "Please ensure claude-project-identifier is properly installed."
    exit 1
fi

# Get project information from user
echo -e "${GREEN}Let's set up your project!${NC}"
echo ""

read -p "Project Name: " PROJECT_NAME
read -p "Project Type (e.g., Web App, CLI Tool, Library): " PROJECT_TYPE
read -p "Project Description: " PROJECT_DESC
read -p "Project Version [1.0.0]: " PROJECT_VERSION
PROJECT_VERSION=${PROJECT_VERSION:-1.0.0}
read -p "Primary Language (e.g., JavaScript, Python, Go): " PRIMARY_LANG
read -p "Framework (e.g., React, FastAPI, None): " FRAMEWORK
read -p "Your Name: " AUTHOR_NAME
read -p "License [MIT]: " LICENSE
LICENSE=${LICENSE:-MIT}

# Escape special characters for sed
escape_for_sed() {
    echo "$1" | sed 's/[[\.*^$()+?{|]/\\&/g'
}

PROJECT_NAME_ESCAPED=$(escape_for_sed "$PROJECT_NAME")
PROJECT_TYPE_ESCAPED=$(escape_for_sed "$PROJECT_TYPE")
PROJECT_DESC_ESCAPED=$(escape_for_sed "$PROJECT_DESC")
AUTHOR_NAME_ESCAPED=$(escape_for_sed "$AUTHOR_NAME")
PRIMARY_LANG_ESCAPED=$(escape_for_sed "$PRIMARY_LANG")
FRAMEWORK_ESCAPED=$(escape_for_sed "$FRAMEWORK")

# Get target directory (default to current directory)
echo ""
CURRENT_DIR=$(pwd)
read -p "Target project directory [$CURRENT_DIR]: " TARGET_DIR
TARGET_DIR=${TARGET_DIR:-$CURRENT_DIR}

# Validate target directory
if [ ! -d "$TARGET_DIR" ]; then
    echo -e "${YELLOW}Directory doesn't exist. Create it? (y/n)${NC}"
    read -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        mkdir -p "$TARGET_DIR"
    else
        echo -e "${RED}Setup cancelled${NC}"
        exit 1
    fi
fi

# Copy and process templates
echo ""
echo -e "${BLUE}Setting up Claude Code project files...${NC}"

# Process CLAUDE.md
sed -e "s/\[PROJECT_NAME\]/$PROJECT_NAME_ESCAPED/g" \
    -e "s/\[PROJECT_TYPE\]/$PROJECT_TYPE_ESCAPED/g" \
    -e "s/\[PROJECT_DESCRIPTION\]/$PROJECT_DESC_ESCAPED/g" \
    -e "s/\[ENVIRONMENT\]/Development/g" \
    "$TEMPLATE_DIR/CLAUDE.md.template" > "$TARGET_DIR/CLAUDE.md"

# Process .claude-project
sed -e "s/\[PROJECT_NAME\]/$PROJECT_NAME_ESCAPED/g" \
    -e "s/\[PROJECT_TYPE\]/$PROJECT_TYPE_ESCAPED/g" \
    -e "s/\[PROJECT_DESCRIPTION\]/$PROJECT_DESC_ESCAPED/g" \
    -e "s/\[PROJECT_TAGLINE\]/$PROJECT_DESC_ESCAPED/g" \
    -e "s/\[AUTHOR_NAME\]/$AUTHOR_NAME_ESCAPED/g" \
    -e "s/\[LICENSE_TYPE\]/$LICENSE/g" \
    -e "s/\[PRIMARY_LANGUAGE\]/$PRIMARY_LANG_ESCAPED/g" \
    -e "s/\[FRAMEWORK\]/$FRAMEWORK_ESCAPED/g" \
    -e "s/\[REPOSITORY_URL\]/https:\/\/github.com\/user\/repo/g" \
    "$TEMPLATE_DIR/.claude-project.template" > "$TARGET_DIR/.claude-project"

# Copy init-project.sh
cp "$TEMPLATE_DIR/init-project.sh.template" "$TARGET_DIR/init-project.sh"
chmod +x "$TARGET_DIR/init-project.sh"

# Copy claude-prompt.sh for terminal integration
if [ -f "$TEMPLATE_DIR/claude-prompt.sh.template" ]; then
    cp "$TEMPLATE_DIR/claude-prompt.sh.template" "$TARGET_DIR/.claude-prompt.sh"
    chmod +x "$TARGET_DIR/.claude-prompt.sh"
fi

# Check if Makefile exists
if [ -f "$TARGET_DIR/Makefile" ]; then
    echo -e "${YELLOW}Makefile already exists. Add Claude commands? (y/n)${NC}"
    read -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo "" >> "$TARGET_DIR/Makefile"
        cat "$SCRIPT_DIR/../addons/makefile/Makefile.addon" >> "$TARGET_DIR/Makefile"
        echo -e "${GREEN}✓ Added Claude commands to existing Makefile${NC}"
    fi
else
    echo -e "${YELLOW}No Makefile found. Create one? (y/n)${NC}"
    read -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo "# $PROJECT_NAME Makefile" > "$TARGET_DIR/Makefile"
        echo "" >> "$TARGET_DIR/Makefile"
        cat "$SCRIPT_DIR/../addons/makefile/Makefile.addon" >> "$TARGET_DIR/Makefile"
        echo -e "${GREEN}✓ Created new Makefile with Claude commands${NC}"
    fi
fi

# Create a quick reference file
cat > "$TARGET_DIR/CLAUDE_QUICK_REFERENCE.md" << EOF
# Claude Code Quick Reference

## Displaying Project Info
\`\`\`bash
# Show project information
make info

# Or directly
bash init-project.sh
\`\`\`

## Project Files
- **CLAUDE.md** - Instructions for Claude Code
- **.claude-project** - Project configuration
- **init-project.sh** - Display script

## Customization
Edit \`.claude-project\` to update:
- Project information
- Banner design
- Waiting indicators
- Tech stack details

## Waiting Indicators
The system shows "[WAITING]" status when idle, helping you know when Claude Code is ready for input.

Generated by Claude Project Setup on $(date)
EOF

echo ""
echo -e "${GREEN}${BOLD}Setup Complete!${NC}"
echo ""
echo -e "${CYAN}Files created in $TARGET_DIR:${NC}"
echo "  ✓ CLAUDE.md"
echo "  ✓ .claude-project"
echo "  ✓ init-project.sh"
echo "  ✓ .claude-prompt.sh"
echo "  ✓ CLAUDE_QUICK_REFERENCE.md"
if [ -f "$TARGET_DIR/Makefile" ]; then
    echo "  ✓ Makefile (updated)"
fi

echo ""
echo -e "${YELLOW}${BOLD}🎯 Terminal Title Bar Integration:${NC}"
echo ""
echo -e "${CYAN}To show project name in your terminal title bar:${NC}"
echo ""
echo "1. Copy the prompt integration to your home directory:"
echo -e "   ${GREEN}cp $TARGET_DIR/.claude-prompt.sh ~/.claude-prompt.sh${NC}"
echo ""
echo "2. Add to your shell configuration:"
if [ -n "$BASH_VERSION" ]; then
    echo -e "   ${GREEN}echo 'source ~/.claude-prompt.sh' >> ~/.bashrc${NC}"
elif [ -n "$ZSH_VERSION" ]; then
    echo -e "   ${GREEN}echo 'source ~/.claude-prompt.sh' >> ~/.zshrc${NC}"
else
    echo -e "   ${GREEN}Add 'source ~/.claude-prompt.sh' to your shell config${NC}"
fi
echo ""
echo "3. Reload your shell:"
echo -e "   ${GREEN}source ~/.bashrc${NC}  # or source ~/.zshrc"
echo ""
echo -e "${PURPLE}Result: Your terminal will show:${NC}"
echo -e "   Terminal title: ${BOLD}Claude Code - $PROJECT_NAME${NC}"
echo -e "   Prompt: ${CYAN}[$PROJECT_NAME]${NC} ~/path/to/project $"
echo ""
echo -e "${YELLOW}Manual display:${NC}"
echo "  cd $TARGET_DIR && ./init-project.sh"
echo ""
echo -e "${GREEN}Happy coding with Claude Code! 🚀${NC}"