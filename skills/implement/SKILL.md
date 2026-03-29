---
name: implement
description: Complete implementation workflow for a task - understand context, plan, implement, validate, review, and commit. Use when the user wants to implement a feature, fix a bug, or complete a specific development task.
triggers:
  - "/implement"
  - "implement"
  - "implémenter"
  - "let's implement"
  - "start coding"
  - "on code"
  - "développer"
allowed-tools: Read, Write, Edit, Bash, Glob, Grep, Task, TodoWrite, Skill, Agent, mcp__supabase__list_tables, mcp__supabase__get_advisors, mcp__supabase__execute_sql, mcp__plugin_context7_context7__resolve-library-id, mcp__plugin_context7_context7__query-docs
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

3. **Fallback search** (if main project files not found, in priority order):
   - Plan:
     1. `memory-bank/*-implementation-plan.md` or `memory-bank/implementation-plan.md`
     2. `*-implementation-plan.md` or `implementation-plan.md` (project root)
     3. `docs/*-implementation-plan.md` or `docs/implementation-plan.md`
     4. First `**/*implementation-plan*.md` found elsewhere
   - Progress: `progress.txt`, `progress.md`, `PROGRESS.md` (project root first, then memory-bank/)
   - PRD: `memory-bank/prd.md`, `memory-bank/PRD.md`, `prd.md`, `PRD.md`

   **If multiple matches**: Ask the user which file to use.

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

## Phase 2.5: Tests (TDD)

Follow the `/tdd` skill for all new functionality:
1. **RED**: Write a failing test for the behavior you're about to implement
2. **Verify RED**: Run `pnpm test` — confirm the test fails for the right reason
3. **GREEN**: Write minimal code to pass the test
4. **Verify GREEN**: Run `pnpm test` — confirm all tests pass

**Skip TDD only for:**
- Text-only changes (copy, translations)
- Pure config changes (env vars, tailwind config)
- Style-only changes (CSS, spacing, colors)
- Deleting unused code

These are the same exceptions as the `/tdd` skill.

## Phase 3: Validate

Run in order (stop on failure):
```bash
pnpm lint
pnpm build
pnpm test:e2e  # if E2E tests exist
```

If DB changes, check Supabase advisors (security/RLS)

## Phase 4: Code Review

Spawn the `code-reviewer` agent as a sub-agent to review changes with fresh eyes.
Pass the current branch name so it can diff against main.
Fix any critical (🔴) issues it identifies before proceeding.

If the changes touch auth, API routes, DB queries, user input handling, or payments, also invoke `/security-check` for a deeper audit.

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

## Handling Blockers

When blocked during implementation, follow this protocol:

### Status: DONE
Proceed to Phase 3 (Validate).

### Status: DONE_WITH_CONCERNS
Note concerns in the commit message. Proceed to validation but flag concerns to the user after commit.

### Status: NEEDS_CONTEXT
Stop implementation. Ask the user for the missing information. Do NOT guess or assume. Resume only after receiving the answer.

### Status: BLOCKED
Assess the blocker type and respond:
- **Missing dependency/API**: Ask user how to proceed
- **Unclear requirement**: Go back to the plan, re-read the story. If still unclear, ask user
- **Test failure you can't resolve**: Use `/debug` to investigate systematically
- **Architectural issue**: Escalate to user — this may require plan revision

Never force through a blocker. Never skip a story because it's hard.

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
