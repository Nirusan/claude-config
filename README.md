# Claude Code Configuration

Personal Claude Code configuration for consistent development experience across machines.

## Quick Install

### User-level (all projects on this machine)

```bash
# One-liner
curl -sSL https://raw.githubusercontent.com/Nirusan/claude-config/main/install.sh | bash

# Or from clone
git clone https://github.com/Nirusan/claude-config.git
cd claude-config
./install.sh --user
```

### Project-level (current project only)

```bash
# From clone
git clone https://github.com/Nirusan/claude-config.git /tmp/claude-config
cd /path/to/your/project
/tmp/claude-config/install.sh --project

# Or one-liner
curl -sSL https://raw.githubusercontent.com/Nirusan/claude-config/main/install.sh | bash -s -- --project
```

### In Docker

```dockerfile
# User-level (recommended)
RUN curl -sSL https://raw.githubusercontent.com/Nirusan/claude-config/main/install.sh | bash

# Project-level
WORKDIR /app
RUN curl -sSL https://raw.githubusercontent.com/Nirusan/claude-config/main/install.sh | bash -s -- --project
```

## Installation Modes

| Mode | Flag | Target | Plugins | Use Case |
|------|------|--------|---------|----------|
| **User** | `--user` (default) | `~/.claude/` | Yes | Personal machine, all projects |
| **Project** | `--project` | `./.claude/` | No | Shared team config, CI/CD |

### User-level (`--user`)

- Installs to `~/.claude/`
- Applies to **all projects** on this machine
- Includes plugins (mgrep, frontend-design, etc.)
- Best for: personal dev machines

### Project-level (`--project`)

- Installs to `./.claude/` in current directory
- Applies **only to this project**
- No plugins (those are user-level only)
- `CLAUDE.md` goes to project root
- Best for: team projects, CI/CD, Docker

### How they combine

Claude Code merges configurations:

```
~/.claude/CLAUDE.md        (user preferences)
     +
./CLAUDE.md                (project rules)
     +
./.claude/settings.json    (project settings)
     =
Final configuration
```

Project-level can override or extend user-level settings.

## What's Included

### Global Configuration

| File | Description |
|------|-------------|
| `config/CLAUDE.md` | Global preferences (pnpm, code style, naming conventions) |
| `config/settings.json` | Model (opus), language (French), enabled plugins |

### Custom Commands

| Command | Description |
|---------|-------------|
| `/validate` | Run lint, build, and E2E tests in sequence |
| `/implement` | Full implementation workflow with validation |
| `/db-check` | Check Supabase advisors (security, performance) |
| `/git-add-commit-push` | Git workflow with auto-generated messages |
| `/next-task` | Find next incomplete task from MVP plan |
| `/refresh-context` | Re-read project documentation |
| `/update-progress` | Update progress.txt with completed tasks |

### Custom Agents

| Agent | Description |
|-------|-------------|
| `code-reviewer` | Expert code review for quality and security |
| `nextjs-developer` | Next.js 14+ specialist (App Router, RSC, Server Actions) |
| `supabase-developer` | Supabase expert (PostgreSQL, Auth, RLS) |
| `prompt-engineer` | Prompt optimization for Claude API |

### Skills

| Skill | Description |
|-------|-------------|
| `design-principles` | Minimal design system inspired by Linear, Notion, Stripe |

### Plugins (user-level only)

| Plugin | Source | Description |
|--------|--------|-------------|
| `mgrep` | mixedbread-ai/mgrep | Semantic search |
| `frontend-design` | anthropics/claude-plugins-official | UI component design |
| `code-review` | anthropics/claude-plugins-official | Code review automation |
| `typescript-lsp` | anthropics/claude-plugins-official | TypeScript language server |
| `security-guidance` | anthropics/claude-plugins-official | Security best practices |
| `context7` | anthropics/claude-plugins-official | Library documentation |

## Updating

### Pull latest from repo

```bash
cd /path/to/claude-config
git pull
./install.sh           # or ./install.sh --project
```

### Sync local changes to repo

If you modify config locally in `~/.claude/`, sync it back to the repo:

```bash
cd /path/to/claude-config
./sync.sh                                    # Copy ~/.claude/ → repo
git add -A && git commit -m "sync" && git push
```

**What gets synced:**
- `~/.claude/CLAUDE.md` → `config/CLAUDE.md`
- `~/.claude/settings.json` → `config/settings.json`
- `~/.claude/commands/*.md` → `commands/`
- `~/.claude/agents/*.md` → `agents/`
- `~/.claude/skills/` → `skills/`

### Optional: /sync-config command

Create a local Claude Code command for quick syncing:

```bash
# Create ~/.claude/commands/sync-config.md
cat > ~/.claude/commands/sync-config.md << 'EOF'
---
allowed-tools: Bash(*)
description: Sync local Claude config to GitHub repo
---

Run sync and show status:
\`\`\`bash
cd ~/path/to/claude-config && ./sync.sh && git status
\`\`\`
EOF
```

Then use `/sync-config` in Claude Code. This command is gitignored since paths are user-specific.

## Customization

Edit files in this repo, then run `./install.sh` to apply changes.

### Adding a new command

1. Create `commands/my-command.md`
2. Run `./install.sh`
3. Use with `/my-command` in Claude Code

### Adding a new agent

1. Create `agents/my-agent.md`
2. Run `./install.sh`

## File Structure

```
claude-config/
├── README.md
├── install.sh              # Installer with --user/--project flags
├── sync.sh                 # Sync ~/.claude/ back to repo
├── .gitignore
├── config/
│   ├── CLAUDE.md           # Global preferences
│   └── settings.json       # Model, plugins, language
├── commands/
│   ├── validate.md
│   ├── implement.md
│   ├── db-check.md
│   ├── git-add-commit-push.md
│   ├── next-task.md
│   ├── refresh-context.md
│   └── update-progress.md
├── agents/
│   ├── code-reviewer.md
│   ├── nextjs-developer.md
│   ├── supabase-developer.md
│   └── prompt-engineer.md
└── skills/
    └── design-principles/
        └── skill.md
```

## License

MIT - Feel free to fork and customize.
