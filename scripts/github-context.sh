#!/usr/bin/env bash

# github-context.sh — pull the right project documentation into an LLM's context.
# One command per document so an agent can fetch exactly what it needs.
# `task <n>` prints the ticket AND every doc it references, so an agent
# starting from an issue number gets full context in a single call.

set -euo pipefail

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

usage() {
    cat <<'EOF'
Usage: github-context.sh <command> [args]

Commands:
  north-star                Print the Project North Star (doc issue)
  tech-stack                Print the Technical Blueprint (doc issue)
  research <Milestone>      Print a milestone's research (doc issue)
  release-plan              Print the open release-plan tracking issue
  milestone <number|title>  Print a GitHub Milestone's title and description
  task <issue-number>       Print a task ticket PLUS every doc it references
  all                       Print north-star, tech-stack, and release-plan together
EOF
}

section() {
    printf '\n===== %s =====\n\n' "$1"
}

print_issue() {
    gh issue view "$1" --json title,body -q '"# " + .title + "\n\n" + .body'
}

release_plan() {
    local num
    num=$(gh issue list --label release-plan --state open --json number -q '.[0].number')
    if [[ -z "$num" ]]; then
        echo "Error: no open issue labeled 'release-plan'. Run jb-release-planner first." >&2
        exit 1
    fi
    print_issue "$num"
}

cmd=${1:-}
case "$cmd" in
    north-star)
        exec "$SCRIPT_DIR/github-docs.sh" get "North Star"
        ;;
    tech-stack)
        exec "$SCRIPT_DIR/github-docs.sh" get "Tech Stack"
        ;;
    research)
        milestone=${2:?Usage: github-context.sh research <Milestone>}
        exec "$SCRIPT_DIR/github-docs.sh" get "Research - ${milestone}"
        ;;
    release-plan)
        release_plan
        ;;
    milestone)
        exec "$SCRIPT_DIR/github-milestone.sh" view "${2:?Usage: github-context.sh milestone <number|title>}"
        ;;
    task)
        num=${2:?Usage: github-context.sh task <issue-number>}
        ticket=$(print_issue "$num")
        section "TASK TICKET (#$num)"
        printf '%s\n' "$ticket"
        # Pull down every doc issue the ticket references (#N in the body
        # that matches an open issue labeled 'docs').
        doc_nums=$(gh issue list --label docs --state open --json number --jq '.[].number')
        refs=$(printf '%s' "$ticket" | grep -oE '#[0-9]+' | tr -d '#' | sort -un)
        for ref in $refs; do
            if printf '%s\n' "$doc_nums" | grep -qx "$ref"; then
                section "ATTACHED DOC (#$ref)"
                print_issue "$ref"
            fi
        done
        ;;
    all)
        section "PROJECT NORTH STAR"
        "$SCRIPT_DIR/github-docs.sh" get "North Star"
        section "TECHNICAL BLUEPRINT"
        "$SCRIPT_DIR/github-docs.sh" get "Tech Stack"
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
