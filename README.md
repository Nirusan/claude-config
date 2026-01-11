# Claude Code Configuration

Personal Claude Code configuration for consistent development experience across machines.

## Quick Install

### From GitHub (after pushing)

```bash
curl -sSL https://raw.githubusercontent.com/nirusan/claude-config/main/install.sh | bash
```

### From local clone

```bash
git clone git@github.com:nirusan/claude-config.git
cd claude-config
./install.sh
```

### In Docker

```dockerfile
RUN curl -sSL https://raw.githubusercontent.com/nirusan/claude-config/main/install.sh | bash
```

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

### Plugins

| Plugin | Source | Description |
|--------|--------|-------------|
| `mgrep` | mixedbread-ai/mgrep | Semantic search |
| `frontend-design` | anthropics/claude-plugins-official | UI component design |
| `code-review` | anthropics/claude-plugins-official | Code review automation |
| `typescript-lsp` | anthropics/claude-plugins-official | TypeScript language server |
| `security-guidance` | anthropics/claude-plugins-official | Security best practices |
| `context7` | anthropics/claude-plugins-official | Library documentation |

## Updating

To sync changes from this repo:

```bash
cd ~/.claude-config  # or wherever you cloned it
git pull
./install.sh
```

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
├── install.sh
├── .gitignore
├── config/
│   ├── CLAUDE.md          # Global preferences
│   └── settings.json      # Model, plugins, language
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

Private configuration. Do not distribute without permission.
