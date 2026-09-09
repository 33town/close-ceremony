#!/usr/bin/env bash
# Installs the /close Claude Code slash command into ~/.claude/commands/.
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
COMMANDS_DIR="$HOME/.claude/commands"

echo "== close installer =="

mkdir -p "$COMMANDS_DIR"
cp "$REPO_DIR/commands/close.md" "$COMMANDS_DIR/close.md"
echo "Installed $COMMANDS_DIR/close.md"

echo ""
echo "Done. /close is now available in every Claude Code project."
