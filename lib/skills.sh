#!/bin/bash
# skills.sh - Install skill plugins

PLUGINS_DIR="$HOME/.hermes/plugins"
PROFILES_DIR="$HOME/profiles"

install_skills() {
    local profile="$1"
    local profile_dir="$SCRIPT_DIR/profiles/free/$profile"
    
    if [ ! -d "$profile_dir" ]; then
        echo -e "${RED}✗ Profile not found: $profile${NC}"
        exit 1
    fi
    
    # Read skills from profile
    local skills_file="$profile_dir/skills.json"
    if [ ! -f "$skills_file" ]; then
        echo -e "${RED}✗ skills.json not found for profile: $profile${NC}"
        exit 1
    fi
    
    # Install gstack (primary skill library)
    install_gstack
    
    # Link skills to profile
    link_skills "$profile"
}

install_gstack() {
    local gstack_dir="$PLUGINS_DIR/gstack"
    
    if [ -d "$gstack_dir" ]; then
        echo -e "${GREEN}✓ gstack already installed${NC}"
        return 0
    fi
    
    echo "Installing gstack..."
    
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
        
        # Create __init__.py
        cat > "$gstack_dir/__init__.py" << 'EOF'
from pathlib import Path

SKILLS = [
    "gstack", "autoplan", "benchmark", "browse", "canary", "careful",
    "codex", "context-restore", "context-save", "cso", "design-review",
    "devex-review", "freeze", "gstack-upgrade", "guard", "health",
    "investigate", "learn", "office-hours", "pair-agent", "plan-ceo-review",
    "plan-eng-review", "qa", "review", "ship", "skillify", "unfreeze",
]

def register(ctx) -> None:
    plugin_dir = Path(__file__).parent
    for skill_name in SKILLS:
        if skill_name == "gstack":
            skill_path = plugin_dir / "SKILL.md"
        else:
            skill_path = plugin_dir / skill_name / "SKILL.md"
        if skill_path.exists():
            ctx.register_skill(f"gstack:{skill_name}", skill_path, f"gstack {skill_name}")
EOF
        
        echo -e "${GREEN}✓ gstack installed (48 skills)${NC}"
    else
        echo -e "${RED}✗ Failed to clone gstack${NC}"
        return 1
    fi
}

link_skills() {
    local profile="$1"
    local gstack_dir="$PLUGINS_DIR/gstack"
    local skills_dir="$PROFILES_DIR/$profile/skills/gstack"
    
    if [ ! -d "$gstack_dir" ]; then
        return 1
    fi
    
    mkdir -p "$skills_dir"
    
    # Link main gstack skill
    mkdir -p "$skills_dir/gstack"
    ln -sf "$gstack_dir/SKILL.md" "$skills_dir/gstack/SKILL.md"
    
    # Link all sub-skills
    for skill_dir in "$gstack_dir"/*/; do
        skill_name=$(basename "$skill_dir")
        if [ -f "$skill_dir/SKILL.md" ]; then
            mkdir -p "$skills_dir/$skill_name"
            ln -sf "$skill_dir/SKILL.md" "$skills_dir/$skill_name/SKILL.md"
        fi
    done
    
    local skill_count=$(find "$skills_dir" -name "SKILL.md" | wc -l)
    echo -e "${GREEN}✓ $skill_count skills linked${NC}"
}
