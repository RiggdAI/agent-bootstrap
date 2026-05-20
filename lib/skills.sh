#!/bin/bash
# skills.sh - Install skill plugins

PLUGINS_DIR="$HOME/.hermes/plugins"
PROFILES_DIR="$HOME/profiles"

# Available gstack skills (from garrytan/gstack)
GSTACK_SKILLS=(
    "office-hours:Product ideation and brainstorming"
    "plan-eng-review:Engineering plan review"
    "plan-ceo-review:CEO-level strategy review"
    "review:Pre-landing PR review"
    "qa:QA testing with browser"
    "ship:Deploy workflow"
    "investigate:Root cause debugging"
    "health:Code quality dashboard"
    "design-review:Visual QA and polish"
    "devex-review:Developer experience audit"
    "canary:Post-deploy monitoring"
    "careful:Safety guardrails"
    "freeze:Restrict edits to directory"
    "context-save:Save working context"
    "context-restore:Restore saved context"
    "learn:Manage project learnings"
    "retro:Weekly retrospective"
    "cso:Security audit"
    "benchmark:Performance regression detection"
    "make-pdf:Generate PDF from markdown"
    "scrape:Pull data from web pages"
    "skillify:Codify scrape into skill"
    "browse:Headless browser for testing"
)

# Template to skills mapping
declare -A TEMPLATE_SKILLS=(
    ["ai-engineer"]="office-hours plan-eng-review review qa ship investigate health"
    ["ai-gary-tan"]="office-hours plan-eng-review review ship investigate health design-review devex-review"
    ["chief-technology-officer"]="office-hours plan-ceo-review plan-eng-review review ship investigate health retro cso"
    ["chief-technology-officer-2"]="office-hours plan-ceo-review plan-eng-review review ship investigate health retro cso"
    ["research-agent"]="office-hours investigate learn browse scrape"
    ["instagram-agent"]="office-hours browse scrape skillify design-review qa"
)

install_gstack() {
    local gstack_dir="$PLUGINS_DIR/gstack"
    
    if [ -d "$gstack_dir" ]; then
        echo -e "${GREEN}✓ gstack already installed${NC}"
        return 0
    fi
    
    echo "Installing gstack plugin..."
    
    mkdir -p "$PLUGINS_DIR"
    
    if git clone https://github.com/garrytan/gstack.git "$gstack_dir" 2>/dev/null; then
        # Create plugin manifest
        cat > "$gstack_dir/plugin.yaml" << 'EOF'
name: gstack
version: 1.1.0
description: AI Engineering Workflow - 47+ skills for software development
author: "Garry Tan"
source: https://github.com/garrytan/gstack
EOF
        
        echo -e "${GREEN}✓ gstack installed${NC}"
    else
        echo -e "${RED}✗ Failed to clone gstack${NC}"
        return 1
    fi
}

get_recommended_skills() {
    local profile="$1"
    
    # Match profile name to template
    local template=""
    for t in "${!TEMPLATE_SKILLS[@]}"; do
        if [[ "$profile" == *"$t"* ]] || [[ "$t" == *"$profile"* ]]; then
            template="$t"
            break
        fi
    done
    
    if [ -n "$template" ]; then
        echo "${TEMPLATE_SKILLS[$template]}"
    else
        # Default recommendation
        echo "office-hours review qa ship investigate health"
    fi
}

list_available_skills() {
    echo ""
    echo "Available skills from gstack:"
    echo ""
    local i=1
    for skill_desc in "${GSTACK_SKILLS[@]}"; do
        local skill="${skill_desc%%:*}"
        local desc="${skill_desc#*:}"
        printf "  %2d. %-20s %s\n" "$i" "$skill" "$desc"
        ((i++))
    done
    echo ""
}

select_skills() {
    local profile="$1"
    local recommended="$2"
    local selected=()
    
    # Convert recommended to array
    read -ra recommended_arr <<< "$recommended"
    
    echo ""
    echo -e "${YELLOW}Recommended skills for '$profile':${NC}"
    for skill in "${recommended_arr[@]}"; do
        echo "  - $skill"
    done
    echo ""
    
    echo "Options:"
    echo "  1. Install recommended skills"
    echo "  2. Select skills manually"
    echo "  3. Install all skills"
    echo ""
    read -p "Enter choice [1-3]: " choice
    
    case $choice in
        1)
            selected=("${recommended_arr[@]}")
            ;;
        2)
            list_available_skills
            echo "Enter skill numbers (space-separated, e.g., 1 3 5 7):"
            read -p "> " numbers
            
            for num in $numbers; do
                if [[ "$num" =~ ^[0-9]+$ ]] && [ "$num" -ge 1 ] && [ "$num" -le ${#GSTACK_SKILLS[@]} ]; then
                    local skill_desc="${GSTACK_SKILLS[$((num-1))]}"
                    local skill="${skill_desc%%:*}"
                    selected+=("$skill")
                fi
            done
            ;;
        3)
            for skill_desc in "${GSTACK_SKILLS[@]}"; do
                selected+=("${skill_desc%%:*}")
            done
            ;;
        *)
            selected=("${recommended_arr[@]}")
            ;;
    esac
    
    echo "${selected[@]}"
}

install_skills() {
    local profile="$1"
    local skills="$2"
    local gstack_dir="$PLUGINS_DIR/gstack"
    local skills_dir="$PROFILES_DIR/$profile/skills/gstack"
    
    if [ ! -d "$gstack_dir" ]; then
        echo -e "${RED}✗ gstack not installed${NC}"
        return 1
    fi
    
    mkdir -p "$skills_dir"
    
    local count=0
    local existing=0
    
    read -ra skills_arr <<< "$skills"
    
    for skill in "${skills_arr[@]}"; do
        local skill_source="$gstack_dir/$skill/SKILL.md"
        local skill_target="$skills_dir/$skill/SKILL.md"
        
        # Handle main gstack skill
        if [ "$skill" = "gstack" ]; then
            skill_source="$gstack_dir/SKILL.md"
        fi
        
        if [ -f "$skill_source" ]; then
            # Check if already exists (don't overwrite)
            if [ -L "$skill_target" ] || [ -f "$skill_target" ]; then
                ((existing++))
            else
                mkdir -p "$skills_dir/$skill"
                ln -sf "$skill_source" "$skill_target"
                ((count++))
            fi
        fi
    done
    
    if [ $count -gt 0 ]; then
        echo -e "${GREEN}✓ Installed $count new skills${NC}"
    fi
    
    if [ $existing -gt 0 ]; then
        echo -e "${YELLOW}  $existing skills already existed (skipped)${NC}"
    fi
}

get_gstack_skills_list() {
    local skills=""
    for skill_desc in "${GSTACK_SKILLS[@]}"; do
        skills+="${skill_desc%%:*} "
    done
    echo "$skills"
}
