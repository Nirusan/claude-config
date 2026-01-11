<div align="center">

![English](https://img.shields.io/badge/lang-English-blue?style=for-the-badge)
[![Français](https://img.shields.io/badge/lang-Français-white?style=for-the-badge)](README.fr.md)

</div>

# Claude Code Configuration

Personal Claude Code configuration for consistent development experience across machines.

## Prerequisites

- **git** - for cloning and syncing
- **curl** - for one-liner install
- **bash** - shell (macOS/Linux/WSL)

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
| **Code Style** | Functional/declarative, no classes |
| **Naming** | `kebab-case` folders, `camelCase` functions, `PascalCase` components |
| **React/Next.js** | Prefer Server Components, minimize `'use client'` |
| **UI** | Tailwind CSS + shadcn/ui |
| **Performance** | Optimize Web Vitals, WebP images, lazy loading |

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
| `enabledPlugins` | 6 plugins | Plugins activated by default |

---

### Custom Commands

Commands are invoked with `/command-name` in Claude Code.

| Command | When to Use | What it Does |
|---------|-------------|--------------|
| `/validate` | Before committing | Runs `pnpm lint` → `pnpm build` → `pnpm test:e2e` in sequence. Stops on first failure. |
| `/implement <task>` | Starting a new task | Full workflow: read docs → plan with todos → implement → validate → code review → commit |
| `/db-check` | After DB changes | Checks Supabase advisors for security issues (missing RLS) and performance problems |
| `/git-add-commit-push` | Ready to commit | Stages all, generates commit message from diff, pushes to current branch |
| `/next-task` | Between tasks | Reads MVP plan and progress file, identifies the next incomplete task |
| `/refresh-context` | Starting a session | Re-reads CLAUDE.md, progress.txt, schema.sql to understand project state |
| `/update-progress` | After completing work | Adds entry to progress.txt with date, files changed, what was done |

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

### Skills

Skills are detailed guides that Claude follows for specific domains. They're activated automatically when relevant.

| Skill | Purpose |
|-------|---------|
| `design-principles` | Enforces a precise, minimal design system inspired by Linear, Notion, and Stripe |

**`design-principles` includes:**
- 4px grid system for spacing
- Typography hierarchy (11px-32px scale)
- Shadow/elevation patterns
- Color usage rules (gray for structure, color for meaning)
- Anti-patterns to avoid (no bouncy animations, no gradient decorations)
- Dark mode considerations

---

### Plugins (user-level only)

Plugins extend Claude Code with additional capabilities.

| Plugin | What it Does |
|--------|--------------|
| `mgrep` | Semantic code search using embeddings (better than grep for concepts) |
| `frontend-design` | Generates distinctive, production-ready UI components |
| `code-review` | Automated code review with security and quality checks |
| `typescript-lsp` | TypeScript language server integration |
| `security-guidance` | Security best practices and vulnerability detection |
| `context7` | Fetches up-to-date library documentation |

---

### MCP Servers (Optional)

MCP (Model Context Protocol) servers extend Claude Code with external service integrations. Unlike plugins, MCP servers require separate API keys and are configured in `~/.claude.json`.

**Included template:** `config/mcp-servers.template.json`

| Server | Purpose | Auth Type |
|--------|---------|-----------|
| `brave-search` | Web search | API Key (get one at [brave.com/search/api](https://brave.com/search/api)) |
| `firecrawl` | Advanced web scraping | API Key (get one at [firecrawl.dev](https://firecrawl.dev)) |
| `supabase` | Database management | OAuth (no key needed) |

**Setup:**

1. Copy the template to your Claude config:
```bash
# First time - create new file
cp config/mcp-servers.template.json ~/.claude.json

# Or merge with existing config
cat config/mcp-servers.template.json
# Then manually add the mcpServers section to your ~/.claude.json
```

2. Replace the placeholder API keys:
```bash
# Edit ~/.claude.json and replace:
# - YOUR_BRAVE_API_KEY_HERE
# - YOUR_FIRECRAWL_API_KEY_HERE
```

3. Restart Claude Code

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
- `~/.claude/commands/*.md` → `commands/`
- `~/.claude/agents/*.md` → `agents/`
- `~/.claude/skills/` → `skills/`

### Optional: /sync-config command

Create a local command for quick syncing (gitignored, paths are user-specific):

```bash
cat > ~/.claude/commands/sync-config.md << 'EOF'
---
allowed-tools: Bash(*)
description: Sync local Claude config to GitHub repo
---

Run sync and show status:
```bash
cd ~/path/to/claude-config && ./sync.sh && git status
```
EOF
```

---

## Customization

### Adding a new command

1. Create `commands/my-command.md`:
```markdown
---
allowed-tools: Bash(*), Read, Write
description: What this command does
---

## Instructions for Claude

Explain what Claude should do when this command is invoked.
```

2. Run `./install.sh`
3. Use with `/my-command` in Claude Code

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

### Adding a new skill

1. Create `skills/my-skill/skill.md`:
```markdown
---
name: my-skill
description: What this skill covers
---

# Detailed guidelines...
```

2. Run `./install.sh`

---

## File Structure

```
claude-config/
├── README.md               # English documentation
├── README.fr.md            # French documentation
├── install.sh              # Installer (--user/--project)
├── sync.sh                 # Sync ~/.claude/ → repo
├── .gitignore
├── config/
│   ├── CLAUDE.md           # Code conventions
│   ├── settings.json       # Model, plugins, language
│   └── mcp-servers.template.json  # MCP servers template (requires API keys)
├── commands/
│   ├── validate.md         # Run lint/build/tests
│   ├── implement.md        # Full task workflow
│   ├── db-check.md         # Supabase advisors
│   ├── git-add-commit-push.md
│   ├── next-task.md        # Find next MVP task
│   ├── refresh-context.md  # Re-read project docs
│   └── update-progress.md  # Update progress file
├── agents/
│   ├── code-reviewer.md    # Code quality expert
│   ├── nextjs-developer.md # Next.js specialist
│   ├── supabase-developer.md # Database expert
│   └── prompt-engineer.md  # Prompt optimization
└── skills/
    └── design-principles/
        └── skill.md        # Design system guide
```

---

## License

MIT - Feel free to fork and customize.
