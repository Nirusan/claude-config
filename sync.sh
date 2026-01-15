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

# Sync skills (all subdirectories)
if [[ -d "$CLAUDE_DIR/skills" ]]; then
    for skill_dir in "$CLAUDE_DIR/skills"/*/; do
        if [[ -d "$skill_dir" ]]; then
            skill_name=$(basename "$skill_dir")
            mkdir -p "$SCRIPT_DIR/skills/$skill_name"
            # Copy SKILL.md or skill.md
            for skill_file in "SKILL.md" "skill.md"; do
                if [[ -f "$skill_dir/$skill_file" ]]; then
                    cp "$skill_dir/$skill_file" "$SCRIPT_DIR/skills/$skill_name/$skill_file"
                    echo "    ✓ skills/$skill_name/$skill_file"
                fi
            done
        fi
    done
fi

echo ""
echo "==> Sync complete!"
echo ""
echo "Next steps:"
echo "  cd $SCRIPT_DIR"
echo "  git status"
echo "  git add -A && git commit -m 'sync config' && git push"
