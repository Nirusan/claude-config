<div align="center">

**🌐 Language / Langue**

![English](https://img.shields.io/badge/English-blue?style=for-the-badge&logo=readme&logoColor=white)
[![Français](https://img.shields.io/badge/Français_→-gray?style=for-the-badge&logo=readme&logoColor=white)](README.fr.md)

</div>

# Claude Code Configuration

Personal Claude Code configuration for consistent development experience across machines.

> ⚠️ **Warning**: This will **overwrite** your existing `~/.claude/` configuration. A backup is automatically created at `~/.claude-backup-YYYYMMDD-HHMMSS/` before installation.

## Prerequisites

- **git** - for cloning and syncing
- **curl** - for one-liner install
- **bash** - shell (macOS/Linux/WSL)
- **jq** (optional) - for merging settings during updates

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
# One-liner
curl -sSL https://raw.githubusercontent.com/Nirusan/claude-config/main/install.sh | bash -s -- --project

# Or from clone
git clone https://github.com/Nirusan/claude-config.git /tmp/claude-config
cd /path/to/your/project
/tmp/claude-config/install.sh --project
```

### In Docker

```dockerfile
# User-level (recommended) - use --yes to skip confirmation
RUN curl -sSL https://raw.githubusercontent.com/Nirusan/claude-config/main/install.sh | bash -s -- --yes

# Project-level
WORKDIR /app
RUN curl -sSL https://raw.githubusercontent.com/Nirusan/claude-config/main/install.sh | bash -s -- --project --yes
```

## Installation Modes

| Mode | Flag | Target | Plugins | Use Case |
|------|------|--------|---------|----------|
| **User** | `--user` (default) | `~/.claude/` | Yes | Personal machine, all projects |
| **Project** | `--project` | `./.claude/` | No | Shared team config, CI/CD |

### Options

| Flag | Description |
|------|-------------|
| `--yes` or `-y` | Skip confirmation prompt (for CI/Docker) |

### Existing config protection

If you already have a Claude config, the installer will:
1. **Warn you** (EN/FR) that your config will be overwritten
2. **Ask for confirmation** (press `y` to continue, any other key to abort)
3. **Create a backup** at `~/.claude-backup-YYYYMMDD-HHMMSS/`
4. **Merge your settings** (requires `jq`):
   - `enabledPlugins` — your existing plugins are preserved
   - `permissions.allow` — your custom allowed commands are preserved

To restore your previous config:
```bash
cp -rP ~/.claude-backup-YYYYMMDD-HHMMSS/* ~/.claude/
```

### How configurations combine

Claude Code merges configurations from multiple levels:

```
~/.claude/CLAUDE.md        (user preferences - applies everywhere)
     +
./CLAUDE.md                (project rules - this repo only)
     +
./.claude/settings.json    (project settings)
     =
Final configuration
```

Project-level can override or extend user-level settings.

---

## What's Included

### Global Configuration

#### `config/CLAUDE.md` - Code Conventions

Defines coding standards applied to all projects:

| Rule | Description |
|------|-------------|
| **Package Manager** | Always use `pnpm`, never npm or yarn |
| **Language** | English for code, commits, docs |
| **TypeScript** | Strict mode, avoid `any` (use `unknown` or generics) |
| **Imports** | Absolute imports with `@/` alias, no relative paths |
| **Code Style** | Functional/declarative, no classes |
| **Naming** | `kebab-case` folders, `camelCase` functions, `PascalCase` components |
| **React/Next.js** | Prefer Server Components, minimize `'use client'` |
| **State Management** | Use Zustand over React Context for global state |
| **Data Fetching** | Prefer Server Actions over API Routes |
| **UI** | Tailwind CSS + shadcn/ui |
| **Performance** | Optimize Web Vitals, WebP images, lazy loading |
| **No Barrel Imports** | Import directly (`lucide-react/icons/Check`) not from index |
| **No Waterfalls** | `Promise.all()` for parallel fetches, never sequential `await` |
| **Deduplication** | `React.cache()` for functions called multiple times in a render |

#### `config/settings.json` - Claude Settings

```json
{
  "model": "opus",
  "language": "French",
  "permissions": { "allow": ["Bash(pnpm ...)"] },
  "enabledPlugins": { "mgrep": true, "frontend-design": true, ... }
}
```

| Setting | Value | Description |
|---------|-------|-------------|
| `model` | `opus` | Use Claude Opus (most capable) |
| `language` | `French` | Claude responds in French |
| `permissions` | pnpm commands | Auto-allow pnpm dev/build/test/etc. |
| `enabledPlugins` | 7 plugins | Plugins activated by default |

---

### Skills

Skills are the unified format for Claude Code (Dec 2025), replacing the old commands system. They can be invoked manually with `/skill-name` or auto-discovered by Claude based on context.

| Skill | Trigger | What it Does |
|-------|---------|--------------|
| `/validate` | Before committing | Runs `pnpm lint` → `pnpm build` → `pnpm test:e2e` in sequence |
| `/validate-quick` | Quick CI check | Runs only `pnpm lint` and `pnpm build` (skips E2E tests) |
| `/implement <task>` | Starting a new task | Full workflow: read docs → plan → implement → validate → review → commit |
| `/db-check` | After DB changes | Checks Supabase advisors for security issues and performance |
| `/security-check` | Before committing | Red-team security audit of recent changes |
| `/git-add-commit-push` | Ready to commit | Stages all, generates commit message, pushes |
| `/next-task` | Between tasks | Reads MVP plan, identifies next incomplete task |
| `/refresh-context` | Starting a session | Re-reads project docs (CLAUDE.md, progress.txt) |
| `/update-progress` | After work | Adds entry to progress.txt with date and changes |
| `/update-docs` | After major changes | Updates project documentation |
| `/validate-update-push` | End of session | Validates, updates progress, commits and pushes |
| `/permissions-allow` | Setup | Applies standard development permissions |
| `/design-principles` | UI work | Enforces minimal design system (Linear/Notion/Stripe style) |

**Auto-discovery:** Skills like `db-check` and `security-check` are triggered automatically when relevant (e.g., after database migrations or before commits with security-sensitive changes).

**Example:**
```
> /implement Add dark mode toggle to settings page

Claude will:
1. Read project docs (CLAUDE.md, progress.txt)
2. Create todo list with subtasks
3. Implement the feature
4. Run lint/build/tests
5. Review the code
6. Update progress.txt
7. Commit with descriptive message
```

---

### Custom Agents

Agents are specialized assistants that Claude spawns for specific tasks. They're triggered automatically based on context or explicitly via the Task tool.

| Agent | Expertise | Triggered When |
|-------|-----------|----------------|
| `code-reviewer` | Code quality, security, best practices | After code changes, during `/implement` |
| `nextjs-developer` | Next.js 14+, App Router, RSC, Server Actions | Working on Next.js code |
| `supabase-developer` | PostgreSQL, Auth, RLS policies | Database queries, auth issues |
| `prompt-engineer` | Claude API prompts, context extraction | Writing AI suggestion prompts |

**What agents provide:**
- `code-reviewer`: Checks for security vulnerabilities, code smells, suggests improvements
- `nextjs-developer`: Knows async APIs (`await cookies()`), proper data fetching patterns
- `supabase-developer`: Writes RLS policies, optimizes queries, handles auth flows
- `prompt-engineer`: Optimizes prompts for Twitter/Reddit/LinkedIn response generation

---

### Plugins (user-level only)

Plugins extend Claude Code with additional capabilities.

| Plugin | What it Does |
|--------|--------------|
| `mgrep` | Semantic code search using embeddings (better than grep for concepts) |
| `frontend-design` | Generates distinctive, production-ready UI components |
| `code-review` | Automated code review with security and quality checks |
| `code-simplifier` | Simplifies and refines code for clarity and maintainability |
| `typescript-lsp` | TypeScript language server integration |
| `security-guidance` | Security best practices and vulnerability detection |
| `context7` | Fetches up-to-date library documentation |

---

### MCP Servers

MCP (Model Context Protocol) servers extend Claude Code with external service integrations. They are **automatically merged** into `~/.claude.json` during installation (existing servers are preserved).

| Server | Purpose | Auth |
|--------|---------|------|
| `brave-search` | Web search | API Key ([brave.com/search/api](https://brave.com/search/api)) |
| `firecrawl` | Advanced web scraping | API Key ([firecrawl.dev](https://firecrawl.dev)) |
| `supabase` | Database management | OAuth (no key needed) |
| `exa` | AI-powered web search | OAuth (no key needed) |
| `context7` | Library documentation | None (free) |
| `chrome-devtools` | Browser automation | None (local) |
| `gemini-design-mcp` | Design with Gemini | API Key |
| `n8n-mcp` | Workflow automation | API Key + URL |

**After installation:**

Edit `~/.claude.json` to add your API keys:
```bash
# Replace YOUR_API_KEY_HERE placeholders with actual keys
nano ~/.claude.json
```

**Note:** The `~/.claude.json` file contains API keys and should **never** be committed to version control.

---

## Updating

### Pull latest from repo

```bash
cd /path/to/claude-config
git pull
./install.sh
```

### Sync local changes to repo

If you modify config locally in `~/.claude/`, sync it back:

```bash
cd /path/to/claude-config
./sync.sh                                    # Copy ~/.claude/ → repo
git add -A && git commit -m "sync" && git push
```

**What gets synced:**
- `~/.claude/CLAUDE.md` → `config/CLAUDE.md`
- `~/.claude/settings.json` → `config/settings.json`
- `~/.claude/agents/*.md` → `agents/`
- `~/.claude/skills/*/SKILL.md` → `skills/`
- MCP servers template from `~/.claude.json`

### Optional: /sync-config skill

A `/sync-config` skill is included but gitignored (paths are user-specific). Create your own:

```bash
mkdir -p ~/.claude/skills/sync-config
cat > ~/.claude/skills/sync-config/SKILL.md << 'EOF'
---
name: sync-config
description: Sync local Claude config to GitHub repo
triggers: ["/sync-config"]
tools: Bash
---

Run: `cd ~/Sites/claudeCode && ./sync.sh && git status`
EOF
```

---

## Customization

### Adding a new skill

1. Create `skills/my-skill/SKILL.md`:
```markdown
---
name: my-skill
description: What this skill does
triggers:
  - "/my-skill"
  - "run my skill"
tools: Bash, Read, Write
context: fork
---

## Instructions for Claude

Explain what Claude should do when this skill is invoked.
```

2. Run `./install.sh`
3. Use with `/my-skill` or let Claude auto-discover via triggers

### Adding a new agent

1. Create `agents/my-agent.md`:
```markdown
---
name: my-agent
description: When to use this agent
tools: Read, Write, Bash
model: sonnet
---

You are an expert in X. Your role is to...
```

2. Run `./install.sh`


---

### Automation Scripts

Scripts for running Claude Code autonomously.

| Script | Purpose |
|--------|---------|
| `scripts/ralph.sh <n>` | Run N autonomous iterations (loop) |
| `scripts/ralph-once.sh` | Run 1 autonomous task then stop |

**What they do:**
1. Switch to `ralph` branch
2. Run `/next-task` → `/implement` → `/validate` → `/update-progress` → `/git-add-commit-push`
3. Repeat (ralph.sh) or stop (ralph-once.sh)

**Requirements:**
- `memory-bank/` folder with project docs (coming soon to this repo)
- `progress.txt` to track completed work

---

## File Structure

```
claude-config/
├── README.md               # English documentation
├── README.fr.md            # French documentation
├── install.sh              # Installer (--user/--project)
├── sync.sh                 # Sync ~/.claude/ → repo
├── .gitignore
├── scripts/
│   ├── ralph.sh            # Autonomous loop (N iterations)
│   └── ralph-once.sh       # Autonomous single task
├── config/
│   ├── CLAUDE.md           # Code conventions
│   ├── settings.json       # Model, plugins, language
│   └── mcp-servers.template.json  # MCP servers (auto-merged)
├── agents/
│   ├── code-reviewer.md    # Code quality expert
│   ├── nextjs-developer.md # Next.js specialist
│   ├── supabase-developer.md # Database expert
│   └── prompt-engineer.md  # Prompt optimization
└── skills/                 # Unified format (Dec 2025)
    ├── validate/SKILL.md
    ├── validate-quick/SKILL.md
    ├── implement/SKILL.md
    ├── db-check/SKILL.md
    ├── security-check/SKILL.md
    ├── git-add-commit-push/SKILL.md
    ├── next-task/SKILL.md
    ├── refresh-context/SKILL.md
    ├── update-progress/SKILL.md
    ├── update-docs/SKILL.md
    ├── validate-update-push/SKILL.md
    ├── permissions-allow/SKILL.md
    └── design-principles/SKILL.md
```

---

## License

MIT - Feel free to fork and customize.
