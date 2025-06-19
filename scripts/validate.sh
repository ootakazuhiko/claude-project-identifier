#!/bin/bash

# Template validation script

echo "Validating templates..."

ERRORS=0

# Check if template files exist
for file in templates/CLAUDE.md.template templates/.claude-project.template templates/init-project.sh.template; do
    if [ ! -f "$file" ]; then
        echo "ERROR: Missing template file: $file"
        ((ERRORS++))
    fi
done

# Validate JSON syntax in .claude-project.template
if command -v jq >/dev/null 2>&1; then
    if ! jq empty templates/.claude-project.template 2>/dev/null; then
        echo "ERROR: Invalid JSON in .claude-project.template"
        ((ERRORS++))
    fi
fi

if [ $ERRORS -eq 0 ]; then
    echo "All templates are valid!"
    exit 0
else
    echo "Found $ERRORS errors"
    exit 1
fi
