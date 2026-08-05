#!/usr/bin/env bash

# github-milestone.sh — GitHub Milestone helpers.
# gh has no native milestone command, so these wrap the REST API.

set -euo pipefail

usage() {
    cat <<'EOF'
Usage: github-milestone.sh <command> [args]

Commands:
  create <title> <description>   Create a milestone
  list                           List milestones (number, state, title)
  view <number|title>            Print a milestone's title and description
  close <number>                 Close a milestone
EOF
}

repo() {
    gh repo view --json nameWithOwner -q .nameWithOwner
}

cmd=${1:-}
case "$cmd" in
    create)
        title=${2:?Usage: github-milestone.sh create <title> <description>}
        description=${3:?Usage: github-milestone.sh create <title> <description>}
        gh api "repos/$(repo)/milestones" -f title="$title" -f description="$description" \
            --jq '"Created milestone #\(.number): \(.title)\n\(.html_url)"'
        ;;
    list)
        gh api "repos/$(repo)/milestones?state=all&per_page=100" \
            --jq '.[] | "#\(.number)\t\(.state)\t\(.title)\t(\(.open_issues) open / \(.closed_issues) closed)"'
        ;;
    view)
        target=${2:?Usage: github-milestone.sh view <number|title>}
        if [[ "$target" =~ ^[0-9]+$ ]]; then
            gh api "repos/$(repo)/milestones/$target" \
                --jq '"# Milestone #\(.number): \(.title) [\(.state)]\n\n\(.description)"'
        else
            gh api "repos/$(repo)/milestones?state=all&per_page=100" \
                | jq -r --arg t "$target" \
                    '.[] | select(.title == $t) | "# Milestone #\(.number): \(.title) [\(.state)]\n\n\(.description)"' \
                | grep . || { echo "Error: no milestone titled '$target'." >&2; exit 1; }
        fi
        ;;
    close)
        number=${2:?Usage: github-milestone.sh close <number>}
        gh api -X PATCH "repos/$(repo)/milestones/$number" -f state=closed \
            --jq '"Closed milestone #\(.number): \(.title)"'
        ;;
    ""|-h|--help)
        usage
        ;;
    *)
        echo "Unknown command: $cmd" >&2
        usage >&2
        exit 1
        ;;
esac
