#!/bin/bash
set -e

if [ -z "$1" ]; then
  echo "Usage: $0 <iterations>"
  exit 1
fi

# Switch to ralph branch
echo "Switching to branch 'ralph'..."
git checkout ralph

for ((i=1; i<=$1; i++)); do
  echo ""
  echo "=========================================="
  echo "  ITERATION $i / $1"
  echo "=========================================="
  echo ""

  result=$(claude -p "
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
6. If MVP is complete, respond with: <promise>COMPLETE</promise>

## Rules
- ONE task only per iteration
- If any validation fails, fix it before committing
- No questions - make reasonable decisions autonomously
" \
    --allowedTools "Edit,Write,Bash,Read,Glob,Grep,Task,TodoWrite,Skill,mcp__supabase__list_tables,mcp__supabase__get_advisors,mcp__supabase__execute_sql,mcp__plugin_context7_context7__resolve-library-id,mcp__plugin_context7_context7__query-docs" \
    --dangerously-skip-permissions \
    --output-format text)

  echo "$result"

  if [[ "$result" == *"<promise>COMPLETE</promise>"* ]]; then
    echo ""
    echo "=========================================="
    echo "  MVP COMPLETE!"
    echo "=========================================="
    exit 0
  fi
done

echo ""
echo "Completed $1 iterations."
