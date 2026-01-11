#!/bin/bash
set -e

# Claude Code Configuration Installer
# Usage:
#   ./install.sh              # Install user-level config (default)
#   ./install.sh --user       # Install user-level config (~/.claude/)
#   ./install.sh --project    # Install project-level config (./.claude/)

REPO_URL="${REPO_URL:-https://raw.githubusercontent.com/Nirusan/claude-config/main}"

# Parse arguments
INSTALL_MODE="user"
for arg in "$@"; do
    case $arg in
        --project)
            INSTALL_MODE="project"
            shift
            ;;
        --user)
            INSTALL_MODE="user"
            shift
            ;;
        --help|-h)
            echo "Claude Code Configuration Installer"
            echo ""
            echo "Usage:"
            echo "  ./install.sh              Install user-level config (default)"
            echo "  ./install.sh --user       Install user-level config (~/.claude/)"
            echo "  ./install.sh --project    Install project-level config (./.claude/)"
            echo ""
            echo "User-level:    Applies to ALL projects on this machine"
            echo "Project-level: Applies only to the current project (no plugins)"
            exit 0
            ;;
    esac
done

# Set target directory based on mode
if [[ "$INSTALL_MODE" == "project" ]]; then
    CLAUDE_DIR="./.claude"
    echo "==> Installing Claude Code configuration (PROJECT-level)..."
    echo "    Target: $(pwd)/.claude/"
else
    CLAUDE_DIR="$HOME/.claude"
    echo "==> Installing Claude Code configuration (USER-level)..."
    echo "    Target: ~/.claude/"
fi

# Create directories
mkdir -p "$CLAUDE_DIR"/{commands,agents,skills/design-principles}
if [[ "$INSTALL_MODE" == "user" ]]; then
    mkdir -p "$CLAUDE_DIR/plugins/marketplaces"
fi

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
if [[ "$INSTALL_MODE" == "project" ]]; then
    # For project mode, CLAUDE.md goes to project root
    install_file "config/CLAUDE.md" "./CLAUDE.md"
    install_file "config/settings.json" "$CLAUDE_DIR/settings.json"
else
    install_file "config/CLAUDE.md" "$CLAUDE_DIR/CLAUDE.md"
    install_file "config/settings.json" "$CLAUDE_DIR/settings.json"
fi

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

# Install plugins (user-level only)
if [[ "$INSTALL_MODE" == "user" ]]; then
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
    cat > "$CLAUDE_DIR/plugins/known_marketplaces.json" << EOF
{
  "claude-plugins-official": {
    "source": {
      "source": "github",
      "repo": "anthropics/claude-plugins-official"
    },
    "installLocation": "$CLAUDE_DIR/plugins/marketplaces/claude-plugins-official"
  },
  "Mixedbread-Grep": {
    "source": {
      "source": "github",
      "repo": "mixedbread-ai/mgrep"
    },
    "installLocation": "$CLAUDE_DIR/plugins/marketplaces/Mixedbread-Grep"
  }
}
EOF
fi

# Summary
echo ""
echo "==> Installation complete!"
echo ""
if [[ "$INSTALL_MODE" == "project" ]]; then
    echo "Installed (PROJECT-level):"
    echo "  - ./CLAUDE.md (project root)"
    echo "  - ./.claude/settings.json"
else
    echo "Installed (USER-level):"
    echo "  - ~/.claude/CLAUDE.md"
    echo "  - ~/.claude/settings.json (model: opus, language: French)"
    echo "  - 2 plugin marketplaces"
    echo ""
    echo "Enabled plugins:"
    echo "  - mgrep (semantic search)"
    echo "  - frontend-design"
    echo "  - code-review"
    echo "  - typescript-lsp"
    echo "  - security-guidance"
    echo "  - context7"
fi
echo ""
echo "Also installed:"
echo "  - 7 custom commands (/validate, /implement, etc.)"
echo "  - 4 custom agents"
echo "  - 1 skill (design-principles)"
echo ""
echo "Note: Restart Claude Code for changes to take effect."
