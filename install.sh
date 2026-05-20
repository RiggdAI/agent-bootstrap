#!/bin/bash
# agent-bootstrap - Configure Hermes agent profiles with skills
# Usage: curl -fsSL https://raw.githubusercontent.com/RiggdAI/agent-bootstrap/main/install.sh | bash
#        ./install.sh --profile=cto

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
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
AUTO_INSTALL=false
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
        --auto|-a)
            AUTO_INSTALL=true
            shift
            ;;
        --help|-h)
            echo "Usage: $0 [OPTIONS]"
            echo ""
            echo "Options:"
            echo "  --profile NAME   Profile to configure"
            echo "  --auto, -a       Auto-install recommended skills (non-interactive)"
            echo "  --help, -h       Show this help message"
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

# Step 2: Detect existing profiles
echo ""
echo -e "${YELLOW}Detecting profiles...${NC}"
profiles=$(detect_profiles)

if [ -z "$profiles" ]; then
    echo -e "${YELLOW}No existing profiles found in ~/profiles/${NC}"
    echo ""
    echo "Would you like to create a new profile?"
    read -p "Enter profile name: " PROFILE
    
    if [ -z "$PROFILE" ]; then
        echo -e "${RED}No profile name provided${NC}"
        exit 1
    fi
    
    create_profile "$PROFILE"
else
    # Show existing profiles
    echo ""
    echo "Existing profiles:"
    echo ""
    
    i=1
    profiles_arr=($profiles)
    for p in "${profiles_arr[@]}"; do
        skill_count=$(count_profile_skills "$p")
        printf "  %d. %-30s (%d skills)\n" "$i" "$p" "$skill_count"
        ((i++))
    done
    printf "  %d. Create new profile\n" "$i"
    echo ""
    
    # Select profile
    if [ -z "$PROFILE" ]; then
        read -p "Select profile [1-$i]: " choice
        
        if [ "$choice" -eq "$i" ]; then
            # Create new profile
            read -p "Enter profile name: " PROFILE
            create_profile "$PROFILE"
        elif [[ "$choice" =~ ^[0-9]+$ ]] && [ "$choice" -ge 1 ] && [ "$choice" -lt "$i" ]; then
            PROFILE="${profiles_arr[$((choice-1))]}"
        else
            echo -e "${RED}Invalid choice${NC}"
            exit 1
        fi
    fi
fi

echo ""
echo -e "${BLUE}═══════════════════════════════════════════${NC}"
echo -e "${BLUE}  Configuring: $PROFILE${NC}"
echo -e "${BLUE}═══════════════════════════════════════════${NC}"

# Step 3: Install gstack plugin
echo ""
echo -e "${YELLOW}Checking skill plugins...${NC}"
install_gstack

# Step 4: Get recommended skills
echo ""
echo -e "${YELLOW}Analyzing profile...${NC}"
recommended=$(get_recommended_skills "$PROFILE")

# Step 5: Let user select skills (or auto-install)
if [ "$AUTO_INSTALL" = true ]; then
    echo ""
    echo -e "${YELLOW}Auto-installing recommended skills:${NC}"
    for skill in $recommended; do
        echo "  - $skill"
    done
    selected="$recommended"
else
    selected=$(select_skills "$PROFILE" "$recommended")
fi

if [ -z "$selected" ]; then
    echo -e "${YELLOW}No skills selected${NC}"
    exit 0
fi

# Step 6: Install skills
echo ""
echo -e "${YELLOW}Installing skills...${NC}"
install_skills "$PROFILE" "$selected"

# Step 7: Summary
echo ""
echo -e "${GREEN}═══════════════════════════════════════════${NC}"
echo -e "${GREEN}  Done!${NC}"
echo -e "${GREEN}═══════════════════════════════════════════${NC}"
echo ""
echo "Profile: ~/profiles/$PROFILE/"
skill_count=$(count_profile_skills "$PROFILE")
echo "Skills:  $skill_count installed"
echo ""
echo "Run: hermes chat"
echo ""
