#!/bin/bash
# detect.sh - Detect Hermes installation and existing profiles

detect_hermes() {
    # Check for hermes command
    if command -v hermes &> /dev/null; then
        HERMES_PATH=$(command -v hermes)
        return 0
    fi
    
    # Check for hermes in common locations
    local locations=(
        "$HOME/.local/bin/hermes"
        "$HOME/.hermes/bin/hermes"
        "/usr/local/bin/hermes"
        "/opt/hermes/bin/hermes"
    )
    
    for loc in "${locations[@]}"; do
        if [ -x "$loc" ]; then
            HERMES_PATH="$loc"
            return 0
        fi
    done
    
    # Check for Hermes installation directory
    if [ -d "$HOME/.hermes" ] || [ -d "/opt/hermes" ]; then
        return 0
    fi
    
    return 1
}

get_hermes_version() {
    if command -v hermes &> /dev/null; then
        hermes --version 2>/dev/null || echo "unknown"
    else
        echo "unknown"
    fi
}

detect_profiles() {
    # Find existing profiles in ~/profiles/
    local profiles_dir="$HOME/profiles"
    local profiles=()
    
    if [ -d "$profiles_dir" ]; then
        for dir in "$profiles_dir"/*/; do
            if [ -d "$dir" ]; then
                local name=$(basename "$dir")
                # Skip hidden directories and gstack namespace
                if [[ ! "$name" =~ ^\. ]] && [ "$name" != "gstack" ]; then
                    profiles+=("$name")
                fi
            fi
        done
    fi
    
    echo "${profiles[@]}"
}

get_profile_skills() {
    local profile="$1"
    local skills_dir="$HOME/profiles/$profile/skills"
    local skills=()
    
    if [ -d "$skills_dir" ]; then
        # Find all SKILL.md files
        while IFS= read -r -d '' skill_file; do
            local skill_dir=$(dirname "$skill_file")
            local skill_name=$(basename "$skill_dir")
            skills+=("$skill_name")
        done < <(find "$skills_dir" -name "SKILL.md" -print0 2>/dev/null)
    fi
    
    echo "${skills[@]}"
}

count_profile_skills() {
    local profile="$1"
    local skills_dir="$HOME/profiles/$profile/skills"
    
    if [ -d "$skills_dir" ]; then
        find "$skills_dir" -name "SKILL.md" 2>/dev/null | wc -l
    else
        echo 0
    fi
}
