#!/bin/bash

# JB Skills Installer
# Uses symlinks to allow real-time updates to skills in the hub.
# Compatible with Linux and macOS. For Windows, use Git Bash or WSL.

set -e

SKILLS_HUB_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILLS_DIR="$SKILLS_HUB_ROOT/skills"

show_help() {
    echo "Usage: $0 [OPTION]"
    echo "Options:"
    echo "  --local    Install skills as symlinks in the current workspace"
    echo "  --global   Install skills as symlinks in the global config directories"
    echo "  --help     Show this help message"
}

install_local() {
    echo "Installing skills locally in current workspace..."
    
    Opencode_local="$PWD/.agents/skills/local"
    Claude_local="$PWD/.claude/skills/local"
    
    mkdir -p "$Opencode_local" "$Claude_local"
    
    # Symlink every skill in the hub to both local directories
    for skill in "$SKILLS_DIR"/*/; do
        skill_name=$(basename "$skill")
        
        echo "Linking $skill_name..."
        ln -sf "$skill" "$Opencode_local/$skill_name"
        ln -sf "$skill" "$Claude_local/$skill_name"
    done
    
    echo "Successfully installed skills locally."
}

install_global() {
    echo "Installing skills globally..."
    
    Opencode_global="$HOME/.agents/skills/local"
    Claude_global="$HOME/.claude/skills/local"
    
    mkdir -p "$Opencode_global" "$Claude_global"
    
    # Symlink every skill in the hub to both global directories
    for skill in "$SKILLS_DIR"/*/; do
        skill_name=$(basename "$skill")
        
        echo "Linking $skill_name..."
        ln -sf "$skill" "$Opencode_global/$skill_name"
        ln -sf "$skill" "$Claude_global/$skill_name"
    done
    
    echo "Successfully installed skills globally."
}

if [[ "$1" == "--help" || -z "$1" ]]; then
    show_help
    exit 0
fi

case "$1" in
    --local)
        install_local
        ;;
    --global)
        install_global
        ;;
    *)
        echo "Invalid option: $1"
        show_help
        exit 1
        ;;
esac
