#!/bin/bash

# Claude Project Identifier - Add to Existing Repository
# This script adds Claude Project Identifier to an existing project

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

echo -e "${CYAN}${BOLD}Add Claude Project Identifier to Existing Project${NC}"
echo -e "${CYAN}=================================================${NC}"
echo ""

# Find the script's directory
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
TEMPLATE_DIR="$SCRIPT_DIR/../templates"

# Check if we're in a git repository
if [ -d ".git" ]; then
    echo -e "${GREEN}✓ Git repository detected${NC}"
    IS_GIT_REPO=true
else
    echo -e "${YELLOW}⚠ Not a git repository${NC}"
    IS_GIT_REPO=false
fi

# Check for existing Claude files
EXISTING_FILES=()
[ -f "CLAUDE.md" ] && EXISTING_FILES+=("CLAUDE.md")
[ -f ".claude-project" ] && EXISTING_FILES+=(".claude-project")
[ -f "init-project.sh" ] && EXISTING_FILES+=("init-project.sh")
[ -f ".claude-prompt.sh" ] && EXISTING_FILES+=(".claude-prompt.sh")

if [ ${#EXISTING_FILES[@]} -gt 0 ]; then
    echo -e "${YELLOW}Found existing Claude files:${NC}"
    for file in "${EXISTING_FILES[@]}"; do
        echo "  - $file"
    done
    echo ""
    echo -e "${YELLOW}Do you want to backup and replace them? (y/n)${NC}"
    read -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        # Create backup
        BACKUP_DIR=".claude-backup-$(date +%Y%m%d-%H%M%S)"
        mkdir -p "$BACKUP_DIR"
        for file in "${EXISTING_FILES[@]}"; do
            cp "$file" "$BACKUP_DIR/"
            echo -e "${GREEN}✓ Backed up $file to $BACKUP_DIR/${NC}"
        done
    else
        echo -e "${RED}Installation cancelled${NC}"
        exit 1
    fi
fi

# Auto-detect project information
echo ""
echo -e "${BLUE}Auto-detecting project information...${NC}"

# Project name from git or directory
if [ "$IS_GIT_REPO" = true ]; then
    PROJECT_NAME=$(basename "$(git rev-parse --show-toplevel 2>/dev/null)" || basename "$PWD")
else
    PROJECT_NAME=$(basename "$PWD")
fi

# Try to detect project type
PROJECT_TYPE="Unknown"
if [ -f "package.json" ]; then
    if grep -q "react" package.json 2>/dev/null; then
        PROJECT_TYPE="React Application"
    elif grep -q "vue" package.json 2>/dev/null; then
        PROJECT_TYPE="Vue Application"
    elif grep -q "angular" package.json 2>/dev/null; then
        PROJECT_TYPE="Angular Application"
    elif grep -q "express" package.json 2>/dev/null; then
        PROJECT_TYPE="Node.js Server"
    else
        PROJECT_TYPE="JavaScript/Node.js Project"
    fi
elif [ -f "requirements.txt" ] || [ -f "setup.py" ] || [ -f "pyproject.toml" ]; then
    if [ -f "manage.py" ]; then
        PROJECT_TYPE="Django Application"
    elif grep -q "flask" requirements.txt 2>/dev/null; then
        PROJECT_TYPE="Flask Application"
    elif grep -q "fastapi" requirements.txt 2>/dev/null; then
        PROJECT_TYPE="FastAPI Application"
    else
        PROJECT_TYPE="Python Project"
    fi
elif [ -f "go.mod" ]; then
    PROJECT_TYPE="Go Project"
elif [ -f "Cargo.toml" ]; then
    PROJECT_TYPE="Rust Project"
elif [ -f "pom.xml" ] || [ -f "build.gradle" ]; then
    PROJECT_TYPE="Java Project"
elif [ -f "composer.json" ]; then
    PROJECT_TYPE="PHP Project"
elif [ -f "Gemfile" ]; then
    PROJECT_TYPE="Ruby Project"
else
    PROJECT_TYPE="Software Project"
fi

# Get description from README or package.json
PROJECT_DESC=""
if [ -f "README.md" ]; then
    # Try to extract first paragraph from README
    PROJECT_DESC=$(head -n 10 README.md | grep -v "^#" | grep -v "^$" | head -n 1 | sed 's/[*`]//g' | cut -c1-60)
elif [ -f "package.json" ]; then
    PROJECT_DESC=$(grep -o '"description": "[^"]*"' package.json 2>/dev/null | head -1 | cut -d'"' -f4)
fi
[ -z "$PROJECT_DESC" ] && PROJECT_DESC="A $PROJECT_TYPE"

# Version detection
PROJECT_VERSION="1.0.0"
if [ -f "package.json" ]; then
    VERSION=$(grep -o '"version": "[^"]*"' package.json 2>/dev/null | head -1 | cut -d'"' -f4)
    [ -n "$VERSION" ] && PROJECT_VERSION=$VERSION
elif [ -f "setup.py" ]; then
    VERSION=$(grep -o "version=['\"][^'\"]*['\"]" setup.py 2>/dev/null | head -1 | cut -d= -f2 | tr -d "'\"")
    [ -n "$VERSION" ] && PROJECT_VERSION=$VERSION
fi

# Primary language detection
PRIMARY_LANG="Unknown"
if [ -f "package.json" ]; then
    PRIMARY_LANG="JavaScript"
elif [ -f "tsconfig.json" ]; then
    PRIMARY_LANG="TypeScript"
elif [ -f "requirements.txt" ] || [ -f "setup.py" ]; then
    PRIMARY_LANG="Python"
elif [ -f "go.mod" ]; then
    PRIMARY_LANG="Go"
elif [ -f "Cargo.toml" ]; then
    PRIMARY_LANG="Rust"
elif [ -f "pom.xml" ] || [ -f "build.gradle" ]; then
    PRIMARY_LANG="Java"
elif [ -f "composer.json" ]; then
    PRIMARY_LANG="PHP"
elif [ -f "Gemfile" ]; then
    PRIMARY_LANG="Ruby"
fi

# Get author from git
AUTHOR_NAME=$(git config --get user.name 2>/dev/null || echo "Unknown")

echo ""
echo -e "${GREEN}Detected Information:${NC}"
echo "  Project Name: $PROJECT_NAME"
echo "  Project Type: $PROJECT_TYPE"
echo "  Description: $PROJECT_DESC"
echo "  Version: $PROJECT_VERSION"
echo "  Language: $PRIMARY_LANG"
echo "  Author: $AUTHOR_NAME"
echo ""

# Allow user to modify
echo -e "${YELLOW}Press Enter to accept or type new value:${NC}"
echo ""
read -p "Project Name [$PROJECT_NAME]: " INPUT_NAME
PROJECT_NAME=${INPUT_NAME:-$PROJECT_NAME}

read -p "Project Type [$PROJECT_TYPE]: " INPUT_TYPE
PROJECT_TYPE=${INPUT_TYPE:-$PROJECT_TYPE}

read -p "Description [$PROJECT_DESC]: " INPUT_DESC
PROJECT_DESC=${INPUT_DESC:-$PROJECT_DESC}

read -p "Version [$PROJECT_VERSION]: " INPUT_VERSION
PROJECT_VERSION=${INPUT_VERSION:-$PROJECT_VERSION}

# Escape special characters for sed
escape_for_sed() {
    echo "$1" | sed 's/[[\.*^$()+?{|]/\\&/g'
}

PROJECT_NAME_ESCAPED=$(escape_for_sed "$PROJECT_NAME")
PROJECT_TYPE_ESCAPED=$(escape_for_sed "$PROJECT_TYPE")
PROJECT_DESC_ESCAPED=$(escape_for_sed "$PROJECT_DESC")
PRIMARY_LANG_ESCAPED=$(escape_for_sed "$PRIMARY_LANG")
AUTHOR_NAME_ESCAPED=$(escape_for_sed "$AUTHOR_NAME")

# Create Claude files
echo ""
echo -e "${BLUE}Creating Claude Project files...${NC}"

# Create minimal CLAUDE.md if it doesn't exist
if [ ! -f "CLAUDE.md" ] || [ -n "$BACKUP_DIR" ]; then
    cat > "CLAUDE.md" << 'EOF'
# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Identification

When working with this project, Claude Code should always display the following information at startup and when waiting for user input:

```
[WAITING] ユーザー入力待機中... / Waiting for user input...
================================================
EOF
    echo " Project: $PROJECT_NAME" >> "CLAUDE.md"
    echo " Type: $PROJECT_TYPE" >> "CLAUDE.md"
    echo " Environment: Development" >> "CLAUDE.md"
    echo " Current Directory: [current path]" >> "CLAUDE.md"
    echo " Time: [current time]" >> "CLAUDE.md"
    cat >> "CLAUDE.md" << 'EOF'
================================================
```

## Project Overview

EOF
    echo "$PROJECT_NAME is $PROJECT_DESC." >> "CLAUDE.md"
    echo "" >> "CLAUDE.md"
    echo "---" >> "CLAUDE.md"
    echo "" >> "CLAUDE.md"
    echo "Remember: Always display the project identification banner when starting work on this project." >> "CLAUDE.md"
    
    echo -e "${GREEN}✓ Created CLAUDE.md${NC}"
fi

# Create .claude-project
cat > ".claude-project" << EOF
{
  "project": {
    "name": "$PROJECT_NAME",
    "description": "$PROJECT_DESC",
    "version": "$PROJECT_VERSION",
    "type": "$PROJECT_TYPE",
    "status": "Active"
  },
  "display": {
    "banner": [
      "╔══════════════════════════════════════════════╗",
      "║           $PROJECT_NAME v$PROJECT_VERSION                ║",
      "║    $PROJECT_DESC            ║",
      "╚══════════════════════════════════════════════╝"
    ],
    "waiting_indicators": [
      "[WAITING] 👁️  Ready for your command...",
      "[WAITING] 🤖 Awaiting instructions...",
      "[WAITING] 💭 What would you like to do?",
      "[WAITING] ⏳ Standing by...",
      "[WAITING] 🎯 Ready to assist..."
    ],
    "info": {
      "show_git_branch": true,
      "show_environment": true,
      "show_timestamp": true
    }
  },
  "metadata": {
    "author": "$AUTHOR_NAME",
    "created": "$(date -u +"%Y-%m-%dT%H:%M:%SZ")",
    "language": "$PRIMARY_LANG",
    "repository": "$(git config --get remote.origin.url 2>/dev/null || echo "")"
  }
}
EOF
echo -e "${GREEN}✓ Created .claude-project${NC}"

# Copy init-project.sh
cp "$TEMPLATE_DIR/init-project.sh.template" "init-project.sh"
chmod +x "init-project.sh"
echo -e "${GREEN}✓ Created init-project.sh${NC}"

# Copy claude-prompt.sh
cp "$TEMPLATE_DIR/claude-prompt.sh.template" ".claude-prompt.sh"
chmod +x ".claude-prompt.sh"
echo -e "${GREEN}✓ Created .claude-prompt.sh${NC}"

# Add to .gitignore if it's a git repo
if [ "$IS_GIT_REPO" = true ] && [ -f ".gitignore" ]; then
    if ! grep -q "init-project.sh" .gitignore; then
        echo "" >> .gitignore
        echo "# Claude Project Identifier" >> .gitignore
        echo "init-project.sh" >> .gitignore
        echo ".claude-prompt.sh" >> .gitignore
        echo -e "${GREEN}✓ Updated .gitignore${NC}"
    fi
fi

# Check for Makefile
if [ -f "Makefile" ]; then
    if ! grep -q "info:" Makefile; then
        echo -e "${YELLOW}Add Claude commands to Makefile? (y/n)${NC}"
        read -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            echo "" >> Makefile
            echo "# Claude Project Identifier" >> Makefile
            echo ".PHONY: info claude-info" >> Makefile
            echo "info claude-info:" >> Makefile
            echo "	@./init-project.sh" >> Makefile
            echo -e "${GREEN}✓ Added 'make info' command${NC}"
        fi
    fi
fi

echo ""
echo -e "${GREEN}${BOLD}✨ Successfully added Claude Project Identifier!${NC}"
echo ""
echo -e "${CYAN}Files created/updated:${NC}"
echo "  ✓ CLAUDE.md - Project instructions for Claude"
echo "  ✓ .claude-project - Project configuration"
echo "  ✓ init-project.sh - Display script"
echo "  ✓ .claude-prompt.sh - Terminal integration"
[ -n "$BACKUP_DIR" ] && echo "  ✓ $BACKUP_DIR/ - Backup of original files"

echo ""
echo -e "${YELLOW}${BOLD}🎯 Terminal Title Bar Integration:${NC}"
echo ""
echo "To show '$PROJECT_NAME' in your terminal title:"
echo ""
echo "1. Copy prompt integration:"
echo -e "   ${GREEN}cp .claude-prompt.sh ~/.claude-prompt.sh${NC}"
echo ""
echo "2. Add to shell config:"
if [ -n "$BASH_VERSION" ]; then
    echo -e "   ${GREEN}echo 'source ~/.claude-prompt.sh' >> ~/.bashrc${NC}"
else
    echo -e "   ${GREEN}echo 'source ~/.claude-prompt.sh' >> ~/.zshrc${NC}"
fi
echo ""
echo "3. Reload shell:"
echo -e "   ${GREEN}source ~/.bashrc${NC}  # or ~/.zshrc"
echo ""

echo -e "${PURPLE}Test it now:${NC}"
echo -e "   ${GREEN}./init-project.sh${NC}"
if grep -q "info:" Makefile 2>/dev/null; then
    echo -e "   ${GREEN}make info${NC}"
fi
echo ""

if [ "$IS_GIT_REPO" = true ]; then
    echo -e "${BLUE}Don't forget to commit these changes:${NC}"
    echo -e "   ${GREEN}git add CLAUDE.md .claude-project${NC}"
    echo -e "   ${GREEN}git commit -m \"Add Claude Project Identifier\"${NC}"
fi

echo ""
echo -e "${GREEN}Happy coding with Claude Code! 🚀${NC}"