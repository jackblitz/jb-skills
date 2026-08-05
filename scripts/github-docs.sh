#!/usr/bin/env bash

# github-docs.sh — the project knowledge base, stored as GitHub issues.
# Each doc is one open issue titled "Doc: <Name>" and labeled 'docs'.
# Docs never live as .md files in the repo; core docs are pinned for
# visibility, and task tickets reference docs by issue number so agents
# pull them down together (see github-context.sh task).

set -euo pipefail

LABEL="docs"

usage() {
    cat <<'EOF'
Usage: github-docs.sh <command> [args]

Commands:
  get <Name>            Print a doc's markdown (e.g. "North Star")
  put <Name> [file]     Create/update a doc from file (or stdin if omitted/-)
  list                  List all docs (issue number + name)
  url <Name>            Print the doc's issue URL
  number <Name>         Print the doc's issue number (for #N references)

Naming conventions:
  "North Star"                  the project vision (pinned)
  "Tech Stack"                  the technical blueprint (pinned)
  "Research - <Milestone>"      research for one milestone
EOF
}

ensure_label() {
    gh label create "$LABEL" --description "Project documentation (knowledge base)" \
        --color 0E8A16 2>/dev/null || true
}

find_number() {
    gh issue list --label "$LABEL" --state open --json number,title \
        | jq -r --arg t "Doc: $1" '.[] | select(.title == $t) | .number' | head -1
}

cmd=${1:-}
case "$cmd" in
    get)
        name=${2:?Usage: github-docs.sh get <Name>}
        num=$(find_number "$name")
        if [[ -z "$num" ]]; then
            echo "Error: no doc titled 'Doc: $name'. Available docs:" >&2
            gh issue list --label "$LABEL" --state open --json title \
                --jq '.[] | "  " + .title' >&2
            exit 1
        fi
        gh issue view "$num" --json body -q .body
        ;;
    put)
        name=${2:?Usage: github-docs.sh put <Name> [file]}
        src=${3:--}
        content=$(cat -- "$src")
        ensure_label
        num=$(find_number "$name")
        if [[ -n "$num" ]]; then
            gh issue edit "$num" --body "$content" >/dev/null
            echo "Updated doc '$name' (#$num): $(gh issue view "$num" --json url -q .url)"
        else
            url=$(gh issue create --title "Doc: $name" --label "$LABEL" --body "$content")
            echo "Created doc '$name': $url"
            # Keep the core docs visible at the top of the issue list.
            # GitHub allows max 3 pinned issues; failure is non-fatal.
            case "$name" in
                "North Star"|"Tech Stack")
                    gh issue pin "${url##*/}" 2>/dev/null || true
                    ;;
            esac
        fi
        ;;
    list)
        gh issue list --label "$LABEL" --state open --json number,title \
            --jq '.[] | "#\(.number)\t\(.title | sub("^Doc: "; ""))"'
        ;;
    url)
        name=${2:?Usage: github-docs.sh url <Name>}
        num=$(find_number "$name")
        [[ -n "$num" ]] || { echo "Error: no doc titled 'Doc: $name'." >&2; exit 1; }
        gh issue view "$num" --json url -q .url
        ;;
    number)
        name=${2:?Usage: github-docs.sh number <Name>}
        num=$(find_number "$name")
        [[ -n "$num" ]] || { echo "Error: no doc titled 'Doc: $name'." >&2; exit 1; }
        echo "$num"
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
