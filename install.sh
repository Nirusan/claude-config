#!/bin/bash
set -e

# Claude Code Configuration Installer
# Usage: curl -sSL https://raw.githubusercontent.com/USERNAME/claude-config/main/install.sh | bash

REPO_URL="${REPO_URL:-https://raw.githubusercontent.com/nirusan/claude-config/main}"
CLAUDE_DIR="$HOME/.claude"

echo "==> Installing Claude Code configuration..."

# Create directories
mkdir -p "$CLAUDE_DIR"/{commands,agents,skills/design-principles,plugins/marketplaces}

# Detect if running from local clone or remote
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [[ -f "$SCRIPT_DIR/config/CLAUDE.md" ]]; then
    echo "==> Installing from local clone..."
    LOCAL_INSTALL=true
else
    echo "==> Installing from remote..."
    LOCAL_INSTALL=false
fi

# Function to copy or download file
install_file() {
    local src="$1"
    local dest="$2"

    if [[ "$LOCAL_INSTALL" == true ]]; then
        cp "$SCRIPT_DIR/$src" "$dest"
    else
        curl -sSL "$REPO_URL/$src" -o "$dest"
    fi
}

# Install config files
echo "==> Copying config files..."
install_file "config/CLAUDE.md" "$CLAUDE_DIR/CLAUDE.md"
install_file "config/settings.json" "$CLAUDE_DIR/settings.json"

# Install commands
echo "==> Installing commands..."
for cmd in validate implement db-check git-add-commit-push next-task refresh-context update-progress; do
    install_file "commands/$cmd.md" "$CLAUDE_DIR/commands/$cmd.md"
done

# Install agents
echo "==> Installing agents..."
for agent in code-reviewer nextjs-developer prompt-engineer supabase-developer; do
    install_file "agents/$agent.md" "$CLAUDE_DIR/agents/$agent.md"
done

# Install skills
echo "==> Installing skills..."
install_file "skills/design-principles/skill.md" "$CLAUDE_DIR/skills/design-principles/skill.md"

# Install plugins from GitHub
echo "==> Installing plugins..."

# Clone or update claude-plugins-official
OFFICIAL_PLUGINS_DIR="$CLAUDE_DIR/plugins/marketplaces/claude-plugins-official"
if [[ -d "$OFFICIAL_PLUGINS_DIR/.git" ]]; then
    echo "    Updating claude-plugins-official..."
    git -C "$OFFICIAL_PLUGINS_DIR" pull --quiet
else
    echo "    Cloning claude-plugins-official..."
    git clone --depth 1 --quiet https://github.com/anthropics/claude-plugins-official.git "$OFFICIAL_PLUGINS_DIR"
fi

# Clone or update Mixedbread-Grep (mgrep)
MGREP_DIR="$CLAUDE_DIR/plugins/marketplaces/Mixedbread-Grep"
if [[ -d "$MGREP_DIR/.git" ]]; then
    echo "    Updating Mixedbread-Grep..."
    git -C "$MGREP_DIR" pull --quiet
else
    echo "    Cloning Mixedbread-Grep..."
    git clone --depth 1 --quiet https://github.com/mixedbread-ai/mgrep.git "$MGREP_DIR"
fi

# Create known_marketplaces.json
cat > "$CLAUDE_DIR/plugins/known_marketplaces.json" << 'EOF'
{
  "claude-plugins-official": {
    "source": {
      "source": "github",
      "repo": "anthropics/claude-plugins-official"
    },
    "installLocation": "$HOME/.claude/plugins/marketplaces/claude-plugins-official"
  },
  "Mixedbread-Grep": {
    "source": {
      "source": "github",
      "repo": "mixedbread-ai/mgrep"
    },
    "installLocation": "$HOME/.claude/plugins/marketplaces/Mixedbread-Grep"
  }
}
EOF

# Fix paths in known_marketplaces.json
sed -i.bak "s|\$HOME|$HOME|g" "$CLAUDE_DIR/plugins/known_marketplaces.json"
rm -f "$CLAUDE_DIR/plugins/known_marketplaces.json.bak"

echo ""
echo "==> Installation complete!"
echo ""
echo "Installed:"
echo "  - Global CLAUDE.md"
echo "  - settings.json (model: opus, language: French)"
echo "  - 7 custom commands"
echo "  - 4 custom agents"
echo "  - 1 skill (design-principles)"
echo "  - 2 plugin marketplaces"
echo ""
echo "Enabled plugins:"
echo "  - mgrep (semantic search)"
echo "  - frontend-design"
echo "  - code-review"
echo "  - typescript-lsp"
echo "  - security-guidance"
echo "  - context7"
echo ""
echo "Note: Restart Claude Code for changes to take effect."
