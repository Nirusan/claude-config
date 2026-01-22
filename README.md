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

Skills are the unified format for Claude Code (Dec 2025), replacing the old commands system. They can be invoked manually with `/skill-name` or auto-discovered by Claude based on context. All skills support **French triggers** for auto-discovery.

#### BMAD Lite Workflow (Product Discovery → Implementation)

| Skill | Triggers | What it Does |
|-------|----------|--------------|
| `/brainstorm` | "brainstorm", "réfléchissons", "explorer cette idée" | Interactive ideation session → creates `memory-bank/brief.md` |
| `/prd` | "create prd", "créer un prd", "définir les besoins" | Define requirements → creates `memory-bank/prd.md` |
| `/tech-stack` | "define tech stack", "définir la stack" | Architecture decisions → creates `memory-bank/tech-stack.md` |
| `/implementation-plan` | "/plan", "créer le plan", "découper en stories" | Break down into stories → creates `memory-bank/plan.md` + `progress.md` |

**BMAD Lite Flow:**
```
/brainstorm → /prd → /tech-stack → /implementation-plan → /implement
```

#### Development Skills

| Skill | Triggers | What it Does |
|-------|----------|--------------|
| `/validate` | "valider", "run tests" | Runs `pnpm lint` → `pnpm build` → `pnpm test:e2e` in sequence |
| `/implement` | "implémenter", "on code" | Full workflow: read docs → plan → implement → validate → review → commit |
| `/next-task` | "what's next", "c'est quoi la suite" | Reads plan, identifies next incomplete task |
| `/refresh-context` | "on en est où", "rafraîchir le contexte" | Re-reads project docs (CLAUDE.md, progress.md) |
| `/update-progress` | "update progress", "maj progrès" | Updates progress.md with completed work |
| `/git-add-commit-push` | "commit", "push", "pousser" | Stages all, generates commit message, pushes |
| `/validate-update-push` | End of session | Validates, updates progress, commits and pushes |

#### Utility Skills

| Skill | Triggers | What it Does |
|-------|----------|--------------|
| `/db-check` | After DB changes | Checks Supabase advisors for security issues and performance |
| `/security-check` | Before committing | Red-team security audit of recent changes |
| `/seo-check` | When working on pages | SEO audit: metadata, structure, Core Web Vitals, accessibility |
| `/permissions-allow` | Setup | Applies standard development permissions |
| `/design-principles` | UI work | Enforces minimal design system (Linear/Notion/Stripe style) |
| `/validate-quick` | Before commits | Quick pass/fail validation (lint + build) |
| `/sync-config` | Manual only | Syncs local `~/.claude/` config to GitHub repo |

**Auto-discovery:** Skills like `db-check`, `security-check`, and `seo-check` are triggered automatically when relevant (e.g., after database migrations, before commits with security-sensitive changes, or when working on pages/content).

**Feature-specific workflows:** Skills support `--feature=X` flag to work in `memory-bank/features/{name}/` subdirectories:
```bash
/prd --feature=dark-mode        # Creates memory-bank/features/dark-mode/prd.md
/implement --feature=dark-mode  # Works on dark-mode feature plan
```

**Example:**
```
> /implement Add dark mode toggle to settings page

Claude will:
1. Read project docs (CLAUDE.md, progress.md)
2. Create todo list with subtasks
3. Implement the feature
4. Run lint/build/tests
5. Review the code
6. Update progress.md
7. Commit with descriptive message
```

---

### Custom Agents

Agents are specialized assistants that Claude spawns for specific tasks. They're triggered automatically based on context or explicitly via the Task tool.

#### BMAD Lite Agents (Product Discovery)

| Agent | Model | Expertise | Used By |
|-------|-------|-----------|---------|
| `analyst` | inherit | Problem discovery, market analysis, ideation | `/brainstorm` |
| `product-manager` | inherit | Requirements, user stories, prioritization | `/prd` |
| `architect` | opus | Tech stack decisions, system design, implementation planning | `/tech-stack`, `/implementation-plan` |

#### Development Agents

| Agent | Model | Expertise | Triggered When |
|-------|-------|-----------|----------------|
| `code-reviewer` | inherit | Code quality, security, best practices | After code changes, during `/implement` |
| `nextjs-developer` | inherit | Next.js 14+, App Router, RSC, Server Actions | Working on Next.js code |
| `supabase-developer` | inherit | PostgreSQL, Auth, RLS policies | Database queries, auth issues |
| `prompt-engineer` | inherit | Claude API prompts, context extraction | Writing AI suggestion prompts |
| `seo-specialist` | inherit | SEO optimization, Core Web Vitals, accessibility | Creating/modifying pages, content work |

**What agents provide:**
- `analyst`: Asks probing questions, challenges assumptions, creates product briefs
- `product-manager`: Defines MVP scope, writes user stories with acceptance criteria
- `architect`: Makes pragmatic tech decisions, breaks features into implementable stories
- `code-reviewer`: Checks for security vulnerabilities, code smells, suggests improvements
- `nextjs-developer`: Knows async APIs (`await cookies()`), proper data fetching patterns
- `supabase-developer`: Writes RLS policies, optimizes queries, handles auth flows
- `prompt-engineer`: Optimizes prompts for Twitter/Reddit/LinkedIn response generation

**Model inheritance:** All agents use `model: inherit` (uses current session model) except `architect` which uses `opus` for complex architectural decisions.

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

### Using /sync-config skill

The `/sync-config` skill is now included by default. It runs the sync script and shows git status:

```bash
/sync-config
```

**Note:** The skill uses `disable-model-invocation: true` so it won't be triggered automatically - you must invoke it manually.

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
model: inherit
---

You are an expert in X. Your role is to...
```

2. Run `./install.sh`

**Note:** Use `model: inherit` to use the current session model, or `model: opus` for complex tasks requiring maximum capability.


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
│   ├── analyst.md          # BMAD: Problem discovery, ideation
│   ├── product-manager.md  # BMAD: Requirements, user stories
│   ├── architect.md        # BMAD: Tech stack, implementation plans
│   ├── code-reviewer.md    # Code quality expert
│   ├── nextjs-developer.md # Next.js specialist
│   ├── supabase-developer.md # Database expert
│   ├── prompt-engineer.md  # Prompt optimization
│   └── seo-specialist.md   # SEO optimization expert
└── skills/                 # Unified format (Dec 2025)
    ├── brainstorm/SKILL.md       # BMAD: Ideation → brief.md
    ├── prd/SKILL.md              # BMAD: Requirements → prd.md
    ├── tech-stack/SKILL.md       # BMAD: Architecture → tech-stack.md
    ├── implementation-plan/SKILL.md  # BMAD: Stories → plan.md
    ├── implement/SKILL.md
    ├── validate/SKILL.md
    ├── validate-quick/SKILL.md   # Quick pass/fail check
    ├── db-check/SKILL.md
    ├── security-check/SKILL.md
    ├── seo-check/SKILL.md        # SEO audit
    ├── git-add-commit-push/SKILL.md
    ├── next-task/SKILL.md
    ├── refresh-context/SKILL.md
    ├── update-progress/SKILL.md
    ├── validate-update-push/SKILL.md
    ├── permissions-allow/SKILL.md
    ├── design-principles/SKILL.md
    └── sync-config/SKILL.md      # Sync config to repo
```

---

## License

MIT - Feel free to fork and customize.
