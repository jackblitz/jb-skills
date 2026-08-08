#!/bin/bash
set -e

# .jb/scripts/create-feature.sh
# Usage: ./create-feature.sh <title> <body> <milestone> [research_issue_id]

TITLE=$1
BODY=$2
MILESTONE=$3
RESEARCH_ID=$4

if [ -z "$TITLE" ] || [ -z "$BODY" ] || [ -z "$MILESTONE" ]; then
  echo "Usage: $0 <title> <body> <milestone> [research_issue_id]"
  exit 1
fi

if [ -n "$RESEARCH_ID" ]; then
  BODY="${BODY}"$'\n\n'"**Research**: #${RESEARCH_ID}"
fi

gh issue create --title "$TITLE" --body "$BODY" --milestone "$MILESTONE" --label "feature"
