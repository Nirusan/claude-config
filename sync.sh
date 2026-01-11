#!/bin/bash
set -e

# Sync local ~/.claude/ config back to this repo
# Usage: ./sync.sh

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLAUDE_DIR="$HOME/.claude"

echo "==> Syncing ~/.claude/ → repo..."

# Sync CLAUDE.md
if [[ -f "$CLAUDE_DIR/CLAUDE.md" ]]; then
    cp "$CLAUDE_DIR/CLAUDE.md" "$SCRIPT_DIR/config/CLAUDE.md"
    echo "    ✓ config/CLAUDE.md"
fi

# Sync settings.json
if [[ -f "$CLAUDE_DIR/settings.json" ]]; then
    cp "$CLAUDE_DIR/settings.json" "$SCRIPT_DIR/config/settings.json"
    echo "    ✓ config/settings.json"
fi

# Sync commands
if [[ -d "$CLAUDE_DIR/commands" ]]; then
    for file in "$CLAUDE_DIR/commands"/*.md; do
        if [[ -f "$file" ]]; then
            filename=$(basename "$file")
            # Skip sync-config (local only)
            if [[ "$filename" != "sync-config.md" ]]; then
                cp "$file" "$SCRIPT_DIR/commands/$filename"
                echo "    ✓ commands/$filename"
            fi
        fi
    done
fi

# Sync agents
if [[ -d "$CLAUDE_DIR/agents" ]]; then
    for file in "$CLAUDE_DIR/agents"/*.md; do
        if [[ -f "$file" ]]; then
            filename=$(basename "$file")
            cp "$file" "$SCRIPT_DIR/agents/$filename"
            echo "    ✓ agents/$filename"
        fi
    done
fi

# Sync skills
if [[ -d "$CLAUDE_DIR/skills/design-principles" ]]; then
    if [[ -f "$CLAUDE_DIR/skills/design-principles/skill.md" ]]; then
        cp "$CLAUDE_DIR/skills/design-principles/skill.md" "$SCRIPT_DIR/skills/design-principles/skill.md"
        echo "    ✓ skills/design-principles/skill.md"
    fi
fi

echo ""
echo "==> Sync complete!"
echo ""
echo "Next steps:"
echo "  cd $SCRIPT_DIR"
echo "  git status"
echo "  git add -A && git commit -m 'sync config' && git push"
