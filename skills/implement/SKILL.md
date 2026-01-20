---
name: implement
description: Complete implementation workflow for a task - understand context, plan, implement, validate, review, and commit. Use when the user wants to implement a feature, fix a bug, or complete a specific development task.
allowed-tools: Read, Write, Edit, Bash, Glob, Grep, Task, TodoWrite, Skill, mcp__supabase__list_tables, mcp__supabase__get_advisors, mcp__supabase__execute_sql, mcp__plugin_context7_context7__resolve-library-id, mcp__plugin_context7_context7__query-docs
user-invocable: true
args:
  - name: feature
    description: Feature name to work on (reads from memory-bank/features/{name}/)
    required: false
---

# Implement a Task

## Phase 0: Determine Context

1. **Check for --feature parameter**:
   - If `--feature=X` provided, set `feature_name = X`
   - Otherwise, check if `memory-bank/features/` exists and has subdirectories
   - If features exist and no param, ask: "Which feature are you working on? (or 'main' for the main project)"

2. **Set paths based on context**:
   ```
   If feature_name and feature_name != 'main':
     plan_file = memory-bank/features/{feature_name}/plan.md
     progress_file = memory-bank/features/{feature_name}/progress.md
     prd_file = memory-bank/features/{feature_name}/prd.md
   Else:
     plan_file = memory-bank/plan.md
     progress_file = memory-bank/progress.md (or progress.txt)
     prd_file = memory-bank/prd.md
   ```

3. **Fallback search** (if main project files not found):
   - Plan: `**/*-implementation-plan.md`, `**/implementation-plan.md`, `**/*plan*.md`
   - Progress: `progress.txt`, `progress.md`, `PROGRESS.md`
   - PRD: `**/PRD.md`, `**/prd.md`

## Phase 1: Understand

1. Read `CLAUDE.md` for conventions
2. Read `memory-bank/tech-stack.md` for technical context
3. Read `{plan_file}` for the implementation plan
4. Read `{progress_file}` for current status
5. Identify the **next incomplete story** from the plan
6. Use **TodoWrite** to plan subtasks for this story
7. If task touches DB, read `database/schema.sql` or check Supabase schema

## Phase 2: Implement

1. Implement the current story (one story at a time!)
2. Follow CLAUDE.md conventions:
   - Functional/declarative, no classes
   - Minimize 'use client'
   - No barrel imports (import directly)
   - Promise.all for parallel fetches
   - Naming: kebab-case (folders), PascalCase (components), camelCase (functions)
3. Mark todos as completed as you go
4. If you need library documentation, use Context7

## Phase 2.5: Tests (if relevant)

If the story adds new user-facing functionality:
1. Create/update tests in `tests/` or alongside components
2. Follow existing patterns
3. Use data-testid attributes for E2E selectors

**Skip if:**
- Minor fix (typo, style, refactor)
- Internal change with no UI impact
- Existing tests already cover the case

## Phase 3: Validate

Run in order (stop on failure):
```bash
pnpm lint
pnpm build
pnpm test:e2e  # if E2E tests exist
```

If DB changes, check Supabase advisors (security/RLS)

## Phase 4: Code Review

Invoke `/security-check` skill to analyze changes.
Fix any critical issues identified.

## Phase 5: Update Progress

Update `{progress_file}`:
- Mark the completed story as done
- Move it from "Remaining" to "Completed"
- Update "Current Story" to the next one (or "None" if done)

## Phase 6: Commit

Commit with a descriptive message:
```bash
git add .
git commit -m "feat: [story description]

Story: #{story_number} from {feature_name or 'main'} plan

Co-Authored-By: Claude <noreply@anthropic.com>"
```

## Rules

- **ONE story per execution** - complete it fully before moving on
- **ALL validations must pass** before commit
- **Update progress immediately** after completing a story
- Never auto-post (human-in-the-loop)
- Use pnpm, not npm

## Feature Flag Examples

```bash
/implement                          # Asks which feature or uses main
/implement --feature=dark-mode      # Works on dark-mode feature
/implement --feature=main           # Explicitly works on main project
```
