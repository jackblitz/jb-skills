#!/bin/bash

# JB Skills Installer
# Uses symlinks to allow real-time updates to skills in the hub.
# Compatible with Linux and macOS. For Windows, use Git Bash or WSL.

set -e

SKILLS_HUB_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILLS_DIR="$SKILLS_HUB_ROOT/skills"
SCRIPTS_DIR="$SKILLS_HUB_ROOT/scripts"

show_help() {
    echo "Usage: $0 [OPTION]"
    echo "Options:"
    echo "  --local    Install skills as symlinks in the current workspace"
    echo "             and copy helper scripts to ./.jb/scripts"
    echo "  --global   Install skills as symlinks in the global config directories"
    echo "  --scripts  Copy only the helper scripts to ./.jb/scripts"
    echo "  --help     Show this help message"
}

copy_scripts() {
    local dest="$PWD/.jb/scripts"
    echo "Copying helper scripts to $dest..."
    mkdir -p "$dest"
    cp "$SCRIPTS_DIR"/*.sh "$dest/"
    chmod +x "$dest"/*.sh
    echo "Helper scripts installed. Commit .jb/scripts so agents and CI can use them."
}

link_skills() {
    local dest_dirs=("$@")
    local dest skill skill_name

    for dest in "${dest_dirs[@]}"; do
        # Refuse to install through a symlinked skills dir — links would land
        # wherever it points instead of the global/local space we intend.
        if [[ -L "$dest" ]]; then
            echo "Error: $dest is a symlink (-> $(readlink "$dest"))." >&2
            echo "Remove it or replace it with a real directory, then re-run." >&2
            exit 1
        fi
        mkdir -p "$dest"
    done

    for skill in "$SKILLS_DIR"/*/; do
        skill="${skill%/}"
        skill_name=$(basename "$skill")

        echo "Linking $skill_name..."
        for dest in "${dest_dirs[@]}"; do
            # -n: replace an existing link rather than creating a nested one inside it
            ln -sfn "$skill" "$dest/$skill_name"
        done
    done
}

install_local() {
    echo "Installing skills locally in current workspace..."

    # OpenCode discovers <root>/.agents/skills/<name>/SKILL.md and
    # <root>/.opencode/skills/...; Claude Code uses <root>/.claude/skills/...
    link_skills "$PWD/.agents/skills" "$PWD/.claude/skills"
    copy_scripts

    echo "Successfully installed skills locally."
}

install_global() {
    echo "Installing skills globally..."

    link_skills "$HOME/.agents/skills" "$HOME/.claude/skills"

    echo "Successfully installed skills globally."
    echo "Note: helper scripts are per-project. Run '$0 --scripts' inside each"
    echo "project repo to copy them to ./.jb/scripts."
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
    --scripts)
        copy_scripts
        ;;
    *)
        echo "Invalid option: $1"
        show_help
        exit 1
        ;;
esac
