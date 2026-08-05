#!/usr/bin/env bash

# github-context.sh — pull the right project documentation into an LLM's context.
# One command per document so an agent can fetch exactly what it needs.

set -euo pipefail

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

usage() {
    cat <<'EOF'
Usage: github-context.sh <command> [args]

Commands:
  north-star                Print the Project North Star (wiki: North-Star)
  tech-stack                Print the Technical Blueprint (wiki: Tech-Stack)
  research <Milestone>      Print a milestone's research (wiki: Research-<Milestone>)
  release-plan              Print the open release-plan tracking issue
  milestone <number|title>  Print a GitHub Milestone's title and description
  task <issue-number>       Print a task issue (body includes doc links)
  all                       Print north-star, tech-stack, and release-plan together
EOF
}

section() {
    printf '\n===== %s =====\n\n' "$1"
}

release_plan() {
    local num
    num=$(gh issue list --label release-plan --state open --json number -q '.[0].number')
    if [[ -z "$num" ]]; then
        echo "Error: no open issue labeled 'release-plan'. Run jb-release-planner first." >&2
        exit 1
    fi
    gh issue view "$num" --json title,body -q '"# " + .title + "\n\n" + .body'
}

cmd=${1:-}
case "$cmd" in
    north-star)
        exec "$SCRIPT_DIR/github-wiki.sh" get North-Star
        ;;
    tech-stack)
        exec "$SCRIPT_DIR/github-wiki.sh" get Tech-Stack
        ;;
    research)
        milestone=${2:?Usage: github-context.sh research <Milestone>}
        exec "$SCRIPT_DIR/github-wiki.sh" get "Research-${milestone// /-}"
        ;;
    release-plan)
        release_plan
        ;;
    milestone)
        exec "$SCRIPT_DIR/github-milestone.sh" view "${2:?Usage: github-context.sh milestone <number|title>}"
        ;;
    task)
        num=${2:?Usage: github-context.sh task <issue-number>}
        gh issue view "$num" --json title,body -q '"# " + .title + "\n\n" + .body'
        ;;
    all)
        section "PROJECT NORTH STAR"
        "$SCRIPT_DIR/github-wiki.sh" get North-Star
        section "TECHNICAL BLUEPRINT"
        "$SCRIPT_DIR/github-wiki.sh" get Tech-Stack
        section "RELEASE PLAN"
        release_plan
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
