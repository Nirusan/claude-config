---
name: implement
description: Complete implementation workflow for a task - understand context, plan, implement, validate, review, and commit. Use when the user wants to implement a feature, fix a bug, or complete a specific development task.
allowed-tools: Read, Write, Edit, Bash, Glob, Grep, Task, TodoWrite, Skill, mcp__supabase__list_tables, mcp__supabase__get_advisors, mcp__supabase__execute_sql, mcp__plugin_context7_context7__resolve-library-id, mcp__plugin_context7_context7__query-docs
user-invocable: true
---

# Implement a Task

## Phase 1: Understand

1. Read `CLAUDE.md` for conventions
2. Read `progress.txt` for current context
3. Use **TodoWrite** to plan subtasks
4. If task touches DB, read `database/schema.sql`

## Phase 2: Implement

1. Implement the requested task
2. Follow CLAUDE.md conventions:
   - Functional/declarative, no classes
   - Minimize 'use client'
   - Naming: kebab-case (folders), PascalCase (components), camelCase (functions)
3. Mark todos as completed as you go
4. If you need library documentation, use Context7

## Phase 2.5: Tests E2E (if relevant)

If the feature adds new user-facing functionality:
1. Create/update E2E tests in `tests/e2e/`
2. Follow existing patterns (auth.spec.ts, onboarding.spec.ts)
3. Use data-testid attributes for selectors

**Skip if:**
- Minor fix (typo, style, refactor)
- Internal change with no UI impact
- Existing tests already cover the case

## Phase 3: Validate

Run in order (stop on failure):
```bash
pnpm lint
pnpm build
pnpm test:e2e
```

If DB changes, check Supabase advisors (security/RLS)

## Phase 4: Code Review

Invoke `/security-check` skill to analyze changes.
Fix any critical issues identified.

## Phase 5: Finalize

1. Update `progress.txt` with what was done
2. Commit with a descriptive message:
   ```bash
   git add .
   git commit -m "feat: [description]

   Co-Authored-By: Claude <noreply@anthropic.com>"
   ```

## Rules

- ONE task per execution only
- ALL validations must pass before commit
- Never auto-post (human-in-the-loop)
- Use pnpm, not npm
