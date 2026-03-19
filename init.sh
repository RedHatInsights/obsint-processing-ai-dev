#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPOS_MAP="$SCRIPT_DIR/project-repos.json"
REPOS_DIR="$SCRIPT_DIR/repos"

log() {
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] [init] $*"
}

log "Checking LSP dependencies..."

# TypeScript LSP
if ! command -v typescript-language-server &>/dev/null; then
  log "Installing typescript-language-server..."
  npm install -g typescript-language-server typescript
fi

log "LSP servers ready."
log "Initializing repos..."

# Clean existing repos for a fresh state
if [ -d "$REPOS_DIR" ]; then
  log "Removing existing repos directory..."
  rm -rf "$REPOS_DIR"
fi
mkdir -p "$REPOS_DIR"

# Clone all repos from project-repos.json
for REPO_KEY in $(jq -r 'keys[]' "$REPOS_MAP"); do
  REPO_URL=$(jq -r --arg key "$REPO_KEY" '.[$key].url' "$REPOS_MAP")
  REPO_NAME=$(basename "$REPO_URL" .git)
  REPO_PATH="$REPOS_DIR/$REPO_NAME"

  log "Cloning $REPO_KEY ($REPO_URL) into $REPO_PATH..."
  git clone "$REPO_URL" "$REPO_PATH"
  log "Done: $REPO_KEY"
done

log "All repos cloned. Ready to run."
