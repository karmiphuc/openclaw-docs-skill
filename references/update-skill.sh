#!/bin/bash
# OpenClaw Skill Auto-Update Script
# Fetches latest from canonical sources and updates local skill files

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILL_DIR="$(dirname "$SCRIPT_DIR")"
LOG_FILE="$HOME/.openclaw/logs/skill-update.log"

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*" >> "$LOG_FILE"
}

error_exit() {
    log "ERROR: $1"
    echo "ERROR: $1" >&2
    exit 1
}

log "Starting OpenClaw skill update..."

# Fetch latest CLI docs
log "Fetching OpenClaw CLI reference from docs.openclaw.ai..."
curl -sSL "https://docs.openclaw.ai/cli" -o "$SKILL_DIR/references/commands.md" 2>/dev/null || {
    log "Warning: Could not fetch CLI docs, keeping existing"
}

# Fetch complete documentation index
log "Fetching documentation index..."
curl -sSL "https://docs.openclaw.ai/llms.txt" -o "$SKILL_DIR/references/docs-index.md" 2>/dev/null || {
    log "Warning: Could not fetch docs index"
}

# Re-generate config reference from local openclaw
log "Generating config reference from local installation..."
if command -v openclaw &> /dev/null; then
    # Export current config structure
    openclaw config get --json > "$SKILL_DIR/references/local-config.json" 2>/dev/null || true

    # Update SKILL.md with latest local examples
    {
        echo "# Auto-generated at $(date)"
        echo "Version: $(openclaw --version 2>/dev/null || echo 'unknown')"
        echo "Gateway port: $(openclaw config get gateway.port 2>/dev/null || echo 'unknown')"
        echo "Agents: $(openclaw agents list --json 2>/dev/null | jq -r '.[].id' 2>/dev/null | tr '\n' ',' | sed 's/,$//')"
        echo "Channels: $(openclaw channels list --json 2>/dev/null | jq -r '.[].id' 2>/dev/null | tr '\n' ',' | sed 's/,$//')"
    } > "$SKILL_DIR/references/local-state.md"
fi

# Touch skill directory to update modification time
touch "$SKILL_DIR"

log "OpenClaw skill update complete."

echo "Skill updated successfully. See $LOG_FILE for details."
