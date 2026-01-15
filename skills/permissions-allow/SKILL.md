---
name: permissions-allow
description: Apply standard development permissions to the current project by creating .claude/settings.local.json with pre-approved tools and bash commands. Use when setting up a new project or when the user wants to configure Claude permissions.
allowed-tools: Write, Read
user-invocable: true
---

# Apply Standard Development Permissions

Create or update `.claude/settings.local.json` with pre-approved tools for efficient development.

## Instructions

Create `.claude/` directory if needed, then write `settings.local.json` with:

```json
{
  "permissions": {
    "allow": [
      "Read", "Write", "Edit", "Glob", "Grep", "WebFetch", "WebSearch",
      "NotebookEdit", "Task", "Skill", "TodoWrite",
      "mcp__ide__getDiagnostics", "mcp__ide__executeCode",
      "mcp__context7__resolve-library-id", "mcp__context7__query-docs",
      "mcp__plugin_context7_context7__resolve-library-id",
      "mcp__plugin_context7_context7__query-docs",
      "mcp__brave-search__brave_web_search", "mcp__brave-search__brave_local_search",
      "mcp__firecrawl__firecrawl_scrape", "mcp__firecrawl__firecrawl_map",
      "mcp__firecrawl__firecrawl_search", "mcp__firecrawl__firecrawl_crawl",
      "mcp__firecrawl__firecrawl_check_crawl_status", "mcp__firecrawl__firecrawl_extract",
      "mcp__supabase__search_docs", "mcp__supabase__list_organizations",
      "mcp__supabase__list_projects", "mcp__supabase__get_project",
      "mcp__supabase__list_tables", "mcp__supabase__list_extensions",
      "mcp__supabase__list_migrations", "mcp__supabase__get_logs",
      "mcp__supabase__get_advisors", "mcp__supabase__get_project_url",
      "mcp__supabase__generate_typescript_types",
      "Bash(pnpm:*)", "Bash(npm:*)", "Bash(node:*)", "Bash(npx:*)",
      "Bash(git:*)", "Bash(gh:*)", "Bash(docker:*)",
      "Bash(cat:*)", "Bash(ls:*)", "Bash(pwd:*)", "Bash(mkdir:*)",
      "Bash(cp:*)", "Bash(mv:*)", "Bash(touch:*)", "Bash(chmod:*)",
      "Bash(curl:*)", "Bash(which:*)", "Bash(supabase:*)", "Bash(vercel:*)",
      "Bash(playwright:*)", "Bash(tsc:*)", "Bash(eslint:*)", "Bash(prettier:*)",
      "Bash(grep:*)", "Bash(find:*)", "Bash(tail:*)", "Bash(head:*)",
      "Bash(python:*)", "Bash(python3:*)", "Bash(pip:*)", "Bash(pip3:*)"
    ],
    "ask": [
      "Edit(../)**", "Edit(~/**)", "Edit(//**)",
      "Write(../)**", "Write(~/**)", "Write(//**)",
      "Bash(rm:*)", "Bash(rmdir:*)", "Bash(rm -rf:*)",
      "mcp__supabase__execute_sql", "mcp__supabase__apply_migration",
      "mcp__supabase__delete_branch"
    ]
  }
}
```

## What's Included

### Allowed (no confirmation)
- Core tools, IDE integration, Context7, Brave Search, Firecrawl
- Supabase read operations
- Common bash commands (pnpm, npm, git, docker, etc.)

### Ask-list (requires confirmation)
- Editing/writing files outside project
- Destructive commands (rm, rmdir)
- Supabase write operations
