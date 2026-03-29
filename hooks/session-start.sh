#!/bin/bash
set -euo pipefail

# SessionStart hook: inject skill-router context into Claude's session
# Triggered on: startup, clear, compact

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILL_FILE="$SCRIPT_DIR/../skills/skill-router/SKILL.md"

# Resolve from installed location (~/.claude/skills/skill-router/SKILL.md)
if [[ ! -f "$SKILL_FILE" ]]; then
    SKILL_FILE="$HOME/.claude/skills/skill-router/SKILL.md"
fi

if [[ ! -f "$SKILL_FILE" ]]; then
    exit 0
fi

# Read and JSON-escape the skill content
CONTENT=$(cat "$SKILL_FILE")
# Escape for JSON: backslashes, quotes, newlines, tabs
CONTENT=$(printf '%s' "$CONTENT" | sed -e 's/\\/\\\\/g' -e 's/"/\\"/g' -e 's/\t/\\t/g' | awk '{printf "%s\\n", $0}' | sed 's/\\n$//')

# Output context for Claude Code
printf '{"hookSpecificOutput":{"additionalContext":"%s"}}' "$CONTENT"

exit 0
