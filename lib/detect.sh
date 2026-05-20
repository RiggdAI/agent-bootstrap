#!/bin/bash
# detect.sh - Detect Hermes installation

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
