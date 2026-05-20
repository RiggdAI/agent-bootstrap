#!/bin/bash
# configure.sh - Configure profile

PROFILES_DIR="$HOME/profiles"

create_profile() {
    local profile="$1"
    local target_dir="$PROFILES_DIR/$profile"
    
    if [ -d "$target_dir" ]; then
        echo -e "${YELLOW}Profile already exists: $profile${NC}"
        return 0
    fi
    
    echo "Creating profile: $profile"
    
    mkdir -p "$target_dir"
    mkdir -p "$target_dir/memories"
    mkdir -p "$target_dir/skills"
    
    # Create empty MEMORY.md
    touch "$target_dir/memories/MEMORY.md"
    
    # Create basic config.yaml
    cat > "$target_dir/config.yaml" << EOF
# Profile: $profile
# Created by agent-bootstrap
EOF
    
    echo -e "${GREEN}✓ Profile created: $target_dir${NC}"
}

ensure_profile_exists() {
    local profile="$1"
    local target_dir="$PROFILES_DIR/$profile"
    
    if [ ! -d "$target_dir" ]; then
        create_profile "$profile"
    fi
}
