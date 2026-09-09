#!/usr/bin/env bash
set -euo pipefail

COMMANDS_DIR="$HOME/.claude/commands"

rm -f "$COMMANDS_DIR/close.md"
echo "Removed $COMMANDS_DIR/close.md"
