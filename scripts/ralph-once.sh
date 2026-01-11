#!/bin/bash

# Switch to ralph branch
echo "Switching to branch 'ralph'..."
git checkout ralph

claude -p "
## Context
@CLAUDE.md @memory-bank/mvp-implementation-plan.md @memory-bank/PRD.md @memory-bank/tech-stack.md @memory-bank/design-system.md @progress.txt

## Mode
AUTONOMOUS - no questions, no human validation, execute everything sequentially.

## Workflow
1. Run /next-task to identify the next incomplete task
2. Run /implement with that task (skip human-in-the-loop parts, execute directly)
3. Run /validate to verify lint, build, tests pass
4. Run /update-progress to document what was done
5. Run /git-add-commit-push to commit changes

## Rules
- ONE task only, then STOP
- If any validation fails, fix it before committing
- No questions - make reasonable decisions autonomously
" \
  --allowedTools "Edit,Write,Bash,Read,Glob,Grep,Task,TodoWrite,Skill,mcp__supabase__list_tables,mcp__supabase__get_advisors,mcp__supabase__execute_sql,mcp__plugin_context7_context7__resolve-library-id,mcp__plugin_context7_context7__query-docs" \
  --dangerously-skip-permissions \
  --output-format text
