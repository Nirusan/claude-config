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
SKIP_CONFIRM="false"
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
        --yes|-y)
            SKIP_CONFIRM="true"
            shift
            ;;
        --help|-h)
            echo "Claude Code Configuration Installer"
            echo ""
            echo "Usage:"
            echo "  ./install.sh              Install user-level config (default)"
            echo "  ./install.sh --user       Install user-level config (~/.claude/)"
            echo "  ./install.sh --project    Install project-level config (./.claude/)"
            echo "  ./install.sh --yes|-y     Skip confirmation prompt"
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

# Backup existing config if present
BACKUP_DIR="$HOME/.claude-backup-$(date +%Y%m%d-%H%M%S)"
if [[ -d "$CLAUDE_DIR" && "$(ls -A "$CLAUDE_DIR" 2>/dev/null)" ]]; then
    echo ""
    echo "⚠️  WARNING / ATTENTION"
    echo "────────────────────────────────────────"
    echo "EN: An existing Claude config was found at $CLAUDE_DIR"
    echo "    This script will OVERWRITE your current configuration."
    echo "    Your enabledPlugins will be MERGED (preserved)."
    echo "    A backup will be created at: $BACKUP_DIR"
    echo ""
    echo "FR: Une configuration Claude existante a été trouvée dans $CLAUDE_DIR"
    echo "    Ce script va ÉCRASER votre configuration actuelle."
    echo "    Vos enabledPlugins seront FUSIONNÉS (préservés)."
    echo "    Une sauvegarde sera créée dans : $BACKUP_DIR"
    echo "────────────────────────────────────────"
    echo ""
    if [[ "$SKIP_CONFIRM" != "true" ]]; then
        # Read from /dev/tty to work with curl | bash
        read -p "Continue? / Continuer ? [y/N] " -n 1 -r < /dev/tty
        echo ""
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            echo "Aborted. / Abandon."
            exit 1
        fi
    else
        echo "(--yes flag: skipping confirmation / option --yes : confirmation ignorée)"
    fi
    echo "==> Backing up existing config to $BACKUP_DIR..."
    cp -rP "$CLAUDE_DIR" "$BACKUP_DIR"
    echo "    Backup complete. Restore with: cp -rP $BACKUP_DIR ~/.claude"
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

    # Remove existing file/symlink to avoid write errors (e.g., Docker symlinks)
    rm -f "$dest" 2>/dev/null || true

    if [[ "$LOCAL_INSTALL" == true ]]; then
        cp "$SCRIPT_DIR/$src" "$dest"
    else
        curl -sSL "$REPO_URL/$src" -o "$dest"
    fi
}

# Function to merge enabledPlugins from existing settings.json
merge_enabled_plugins() {
    local settings_file="$1"
    local backup_settings="$BACKUP_DIR/settings.json"

    # Only merge if backup exists and has enabledPlugins
    if [[ ! -f "$backup_settings" ]]; then
        return
    fi

    # Check if jq is available
    if command -v jq &> /dev/null; then
        # Use jq to merge enabledPlugins (existing plugins take precedence for conflicts)
        local merged
        merged=$(jq -s '.[0].enabledPlugins as $new | .[1].enabledPlugins as $old | .[0] | .enabledPlugins = ($new + $old)' "$settings_file" "$backup_settings" 2>/dev/null)
        if [[ -n "$merged" ]]; then
            echo "$merged" > "$settings_file"
            echo "    Merged existing enabledPlugins with new settings"
        fi
    else
        echo "    Note: Install 'jq' to automatically merge enabledPlugins"
        echo "    Your previous plugins are preserved in: $backup_settings"
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
    # Merge existing enabledPlugins from backup
    merge_enabled_plugins "$CLAUDE_DIR/settings.json"
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
    CURRENT_DATE=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
    cat > "$CLAUDE_DIR/plugins/known_marketplaces.json" << EOF
{
  "claude-plugins-official": {
    "source": {
      "source": "github",
      "repo": "anthropics/claude-plugins-official"
    },
    "installLocation": "$CLAUDE_DIR/plugins/marketplaces/claude-plugins-official",
    "lastUpdated": "$CURRENT_DATE"
  },
  "Mixedbread-Grep": {
    "source": {
      "source": "github",
      "repo": "mixedbread-ai/mgrep"
    },
    "installLocation": "$CLAUDE_DIR/plugins/marketplaces/Mixedbread-Grep",
    "lastUpdated": "$CURRENT_DATE"
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
echo "Optional: Configure MCP servers (brave-search, firecrawl, supabase)"
echo "  See: config/mcp-servers.template.json"
echo "  Requires API keys - see README for setup instructions"
echo ""
echo "Note: Restart Claude Code for changes to take effect."
