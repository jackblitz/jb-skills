#!/usr/bin/env bash

# github-wiki.sh — read/write the project's GitHub Wiki from the CLI.
# The wiki is a plain git repo (<repo>.wiki.git); gh has no wiki API,
# so pages are read and written through a temporary clone.

set -euo pipefail

usage() {
    cat <<'EOF'
Usage: github-wiki.sh <command> [args]

Commands:
  get <Page>            Print the markdown of a wiki page (e.g. North-Star)
  put <Page> [file]     Create/update a page from file (or stdin if omitted/-)
  list                  List all wiki pages
  url <Page>            Print the browser URL of a wiki page

Page names use hyphens instead of spaces (GitHub Wiki convention),
e.g. "Research-User-Auth" for a page titled "Research User Auth".
EOF
}

repo_url() {
    gh repo view --json url -q .url
}

clone_wiki() {
    WIKI_DIR=$(mktemp -d)
    trap 'rm -rf "$WIKI_DIR"' EXIT
    if ! git clone --quiet "$(repo_url).wiki.git" "$WIKI_DIR" 2>/dev/null; then
        echo "Error: could not clone the project wiki." >&2
        echo "A GitHub Wiki must be initialized once by creating its first page" >&2
        echo "in the browser: $(repo_url)/wiki (click 'Create the first page')." >&2
        echo "Enable the wiki feature first if needed: gh repo edit --enable-wiki" >&2
        exit 1
    fi
}

cmd=${1:-}
case "$cmd" in
    get)
        page=${2:?Usage: github-wiki.sh get <Page>}
        clone_wiki
        if [[ ! -f "$WIKI_DIR/${page}.md" ]]; then
            echo "Error: wiki page '$page' not found. Available pages:" >&2
            (cd "$WIKI_DIR" && ls -1 -- *.md 2>/dev/null | sed 's/\.md$//' | sed 's/^/  /') >&2
            exit 1
        fi
        cat "$WIKI_DIR/${page}.md"
        ;;
    put)
        page=${2:?Usage: github-wiki.sh put <Page> [file]}
        src=${3:--}
        content=$(cat -- "$src")
        clone_wiki
        printf '%s\n' "$content" > "$WIKI_DIR/${page}.md"
        git -C "$WIKI_DIR" add -- "${page}.md"
        if git -C "$WIKI_DIR" diff --cached --quiet; then
            echo "No changes to wiki page '$page'."
        else
            git -C "$WIKI_DIR" commit --quiet -m "docs: update ${page}"
            git -C "$WIKI_DIR" push --quiet
            echo "Updated wiki page '$page': $(repo_url)/wiki/${page}"
        fi
        ;;
    list)
        clone_wiki
        (cd "$WIKI_DIR" && ls -1 -- *.md 2>/dev/null | sed 's/\.md$//')
        ;;
    url)
        page=${2:?Usage: github-wiki.sh url <Page>}
        echo "$(repo_url)/wiki/${page}"
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
