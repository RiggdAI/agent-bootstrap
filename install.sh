#!/bin/bash
# agent-bootstrap - Configure Hermes agent profiles with skills
# Usage: curl -fsSL https://get.riggd.ai | bash
#        ./install.sh --profile=cto

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo ""
echo "╔═══════════════════════════════════════════╗"
echo "║        Riggd Agent Bootstrap              ║"
echo "╚═══════════════════════════════════════════╝"
echo ""

# Source libraries
source "$SCRIPT_DIR/lib/detect.sh"
source "$SCRIPT_DIR/lib/skills.sh"
source "$SCRIPT_DIR/lib/configure.sh"

# Parse arguments
PROFILE=""
while [[ $# -gt 0 ]]; do
    case $1 in
        --profile=*)
            PROFILE="${1#*=}"
            shift
            ;;
        --profile)
            PROFILE="$2"
            shift 2
            ;;
        --help|-h)
            echo "Usage: $0 [OPTIONS]"
            echo ""
            echo "Options:"
            echo "  --profile NAME   Profile to install (default: ai-engineer)"
            echo "  --help, -h       Show this help message"
            echo ""
            echo "Available profiles: ai-engineer, cto, research-agent"
            exit 0
            ;;
        *)
            echo -e "${RED}Unknown option: $1${NC}"
            exit 1
            ;;
    esac
done

# Step 1: Detect Hermes
echo -e "${YELLOW}Detecting environment...${NC}"
if ! detect_hermes; then
    echo ""
    echo -e "${RED}✗ Hermes not found${NC}"
    echo ""
    echo "Please install Hermes first:"
    echo "  pip install hermes-agent"
    echo ""
    echo "Or visit: https://hermes-agent.dev"
    echo ""
    echo "After installation, run this script again."
    exit 1
fi
echo -e "${GREEN}✓ Hermes found${NC}"

# Step 2: Select profile
if [ -z "$PROFILE" ]; then
    echo ""
    echo "Choose profile to configure:"
    echo "  1. AI Engineer (default)"
    echo "  2. CTO / Technical Lead"
    echo "  3. Research Agent"
    echo ""
    read -p "Enter choice [1-3]: " choice
    
    case $choice in
        1) PROFILE="ai-engineer" ;;
        2) PROFILE="cto" ;;
        3) PROFILE="research-agent" ;;
        *) PROFILE="ai-engineer" ;;
    esac
fi

echo ""
echo -e "${YELLOW}Installing profile: $PROFILE${NC}"

# Step 3: Install skills
install_skills "$PROFILE"

# Step 4: Configure profile
configure_profile "$PROFILE"

echo ""
echo -e "${GREEN}✓ Done!${NC}"
echo ""
echo "Profile configured at: ~/profiles/$PROFILE/"
echo "Run: hermes chat"
echo ""
