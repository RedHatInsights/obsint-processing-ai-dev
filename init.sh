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

log "All repos cloned."

# Download BrowserMCP extension if not present
EXTENSIONS_DIR="$SCRIPT_DIR/extensions"
BROWSERMCP_DIR="$EXTENSIONS_DIR/browsermcp"

if [ ! -d "$BROWSERMCP_DIR" ]; then
  log "Downloading BrowserMCP extension..."
  mkdir -p "$EXTENSIONS_DIR"
  CRX_FILE="$EXTENSIONS_DIR/browsermcp.crx"
  curl -L -o "$CRX_FILE" "https://clients2.google.com/service/update2/crx?response=redirect&prodversion=131.0&acceptformat=crx2,crx3&x=id%3Dbjfgambnhccakkhmkepdoekmckoijdlc%26uc"
  mkdir -p "$BROWSERMCP_DIR"
  unzip -o "$CRX_FILE" -d "$BROWSERMCP_DIR" -x '_metadata/*'
  rm -f "$CRX_FILE"
  log "BrowserMCP extension downloaded and unpacked."
else
  log "BrowserMCP extension already present."
fi

# Start memory server
log "Starting memory server..."
cd "$SCRIPT_DIR/memory-server"
docker compose up -d --build
log "Waiting for memory server health check..."
for i in $(seq 1 30); do
  if curl -sf http://localhost:8080/health > /dev/null 2>&1; then
    log "Memory server is healthy."
    break
  fi
  if [ "$i" -eq 30 ]; then
    log "WARNING: Memory server failed to start within 30s. Check docker compose logs."
  fi
  sleep 1
done
cd "$SCRIPT_DIR"

log "Ready to run."
