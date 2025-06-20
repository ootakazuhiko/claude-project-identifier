#!/bin/bash
# Taskbar Display Demo
# Shows different taskbar states and ticker formats

# Colors
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
RED='\033[0;31m'
GRAY='\033[0;90m'
NC='\033[0m'
BOLD='\033[1m'

echo "=== Claude Project Taskbar Display Demo ==="
echo ""
echo "Different project states and ticker examples:"
echo ""

# Example 1: Waiting state
echo "1. Waiting for input (default):"
echo -e "   Terminal Title: ${CYAN}⏳ ITDO/main | dev | 14:23${NC}"
echo -e "   Prompt: ${CYAN}[⏳ ITDO]${NC} $ "
echo ""

# Example 2: Running state
echo "2. Command running:"
echo -e "   Terminal Title: ${YELLOW}🔄 ITDO/main | dev | 14:23${NC}"
echo -e "   Prompt: ${CYAN}[🔄 ITDO]${NC} $ npm test"
echo ""

# Example 3: Success state
echo "3. Command succeeded:"
echo -e "   Terminal Title: ${GREEN}✅ ITDO/main | dev | 14:24${NC}"
echo -e "   Prompt: ${CYAN}[✅ ITDO]${NC} $ "
echo ""

# Example 4: Error state
echo "4. Command failed:"
echo -e "   Terminal Title: ${RED}❌ ITDO/main | dev | 14:24${NC}"
echo -e "   Prompt: ${CYAN}[❌ ITDO]${NC} $ "
echo ""

# Example 5: Thinking state
echo "5. Claude thinking/processing:"
echo -e "   Terminal Title: ${YELLOW}🤔 ITDO/main | dev | 14:25${NC}"
echo -e "   Prompt: ${CYAN}[🤔 ITDO]${NC} $ "
echo ""

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "Ticker generation examples:"
echo ""

# Ticker examples
projects=(
    "test-claude-project:TEST"
    "my-awesome-app:AWSM"
    "Claude Project Identifier:CPI"
    "React Native App:RNA"
    "FastAPI Backend:FAPI"
    "Machine Learning Model:MLM"
    "vue:VUE"
    "django-rest-framework:DRF"
)

for project in "${projects[@]}"; do
    IFS=':' read -r name ticker <<< "$project"
    echo -e "   ${GRAY}$name${NC} → ${CYAN}${BOLD}[$ticker]${NC}"
done

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "Compact display options:"
echo ""

# Compact displays
echo "1. One-line status:"
echo -e "   ${CYAN}⏳[ITDO]${NC} ${GRAY}ITDO ERP System v2.0.0${NC} 14:26 ${GREEN}>${NC}"
echo ""

echo "2. Compact info (--compact):"
echo -e "   ${CYAN}⏳ ${BOLD}[ITDO]${NC} ${GRAY}ITDO ERP System v2.0.0${NC} ${GREEN}(main)${NC} ${YELLOW}[dev]${NC} ${GRAY}14:26${NC}"
echo -e "   ${GRAY}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

echo "3. Standard compact header:"
echo -e "   ${CYAN}${BOLD}⏳ [ITDO] ITDO ERP System${NC} ${GRAY}v2.0.0${NC}"
echo -e "   ${GRAY}────────────────────────────────────────${NC}"
echo -e "   ${GREEN}Type:${NC} ERP System  ${GREEN}Git:${NC} main (142 commits)  ${GREEN}Env:${NC} dev"
echo -e "   ${YELLOW}Cmds:${NC} npm {start|test|build}  make {info|help}"
echo -e "   ${GRAY}────────────────────────────────────────${NC}"
echo -e "   ${CYAN}Ready >${NC}"
echo ""

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "Usage examples:"
echo ""
echo "  # Show compact info"
echo "  ./init-project-compact.sh"
echo ""
echo "  # Show one-line status"
echo "  ./init-project-compact.sh --oneline"
echo ""
echo "  # Get ticker only"
echo "  ./init-project-compact.sh --ticker"
echo ""
echo "  # Update terminal title"
echo "  ./init-project-compact.sh --update-title"
echo ""
echo "  # Use taskbar integration"
echo "  source .claude-taskbar.sh"
echo "  claude_set_state running  # Change to running state"
echo "  claude_set_state success  # Change to success state"
echo ""