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
            # Copy SKILL.md (canonical name)
            if [[ -f "$skill_dir/SKILL.md" ]]; then
                cp "$skill_dir/SKILL.md" "$SCRIPT_DIR/skills/$skill_name/SKILL.md"
                echo "    ✓ skills/$skill_name/SKILL.md"
            fi
            # Copy any additional files (reference.md, examples.md, etc.)
            for extra_file in "$skill_dir"*; do
                if [[ -f "$extra_file" && "$(basename "$extra_file")" != "SKILL.md" ]]; then
                    cp "$extra_file" "$SCRIPT_DIR/skills/$skill_name/"
                    echo "    ✓ skills/$skill_name/$(basename "$extra_file")"
                fi
            done
            # Copy scripts directory if present
            if [[ -d "$skill_dir/scripts" ]]; then
                mkdir -p "$SCRIPT_DIR/skills/$skill_name/scripts"
                cp -r "$skill_dir/scripts/"* "$SCRIPT_DIR/skills/$skill_name/scripts/" 2>/dev/null || true
                echo "    ✓ skills/$skill_name/scripts/"
            fi
        fi
    done
fi

# Sync MCP servers config (mask API keys)
echo "==> Syncing MCP servers template..."
if command -v jq &> /dev/null && [[ -f "$HOME/.claude.json" ]]; then
    # Extract mcpServers and mask API keys/sensitive URLs
    jq '{mcpServers: .mcpServers} | walk(
      if type == "string" and (
        test("^(sk-|fc-|BS|ey)") or
        test("AIza") or
        test("^Bearer ") or
        test("Authorization:Bearer") or
        test("srv[0-9]+\\.hstgr")
      )
      then "YOUR_API_KEY_HERE"
      else . end
    )' "$HOME/.claude.json" > "$SCRIPT_DIR/config/mcp-servers.template.json"
    echo "    ✓ config/mcp-servers.template.json"
else
    if ! command -v jq &> /dev/null; then
        echo "    ⚠ jq not installed, skipping MCP sync"
    fi
fi

echo ""
echo "==> Sync complete!"
echo ""
echo "Next steps:"
echo "  cd $SCRIPT_DIR"
echo "  git status"
echo "  git add -A && git commit -m 'sync config' && git push"
