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
## Context Files (READ THESE FIRST)
@CLAUDE.md @memory-bank/mvp-implementation-plan.md @memory-bank/PRD.md @memory-bank/tech-stack.md @memory-bank/design-system.md @progress.txt

## Mode
AUTONOMOUS EXECUTION - No questions, no human validation, execute everything in ONE session.

## Your Mission
Complete ONE task from the MVP plan, from start to finish, in this single execution.

## Step 1: Identify Next Task
Read \`memory-bank/mvp-implementation-plan.md\` and \`progress.txt\` to find the next incomplete task.
Display what you found in this format:
\`\`\`
## Next Task: [Task name]
Phase: [Phase number and name]
Description: [Brief description]
\`\`\`

## Step 2: Implement the Task
1. Use TodoWrite to break down the task into subtasks
2. Read any existing related files before writing new code
3. Follow CLAUDE.md conventions strictly:
   - Functional/declarative, no classes
   - Minimize 'use client' - prefer Server Components
   - Naming: kebab-case (folders), PascalCase (components), camelCase (functions)
   - Use @/ absolute imports
4. If you need library docs, use Context7 MCP
5. Mark todos as completed as you progress

## Step 3: Write E2E Tests (if applicable)
If the feature adds user-facing functionality:
- Create/update tests in \`tests/e2e/\`
- Use data-testid attributes
- Follow existing patterns

Skip if: minor fix, internal change, or already covered.

## Step 4: Validate
Run these commands in sequence. FIX any errors before proceeding:
\`\`\`bash
pnpm lint      # Fix lint errors
pnpm build     # Fix type errors
pnpm test:e2e  # Fix failing tests
\`\`\`

If validation fails, fix the issues and re-run until ALL pass.

## Step 5: Update Progress
Update \`progress.txt\` with:
- Date and what was completed
- Any notes about the implementation

## Step 6: Commit and Push
\`\`\`bash
git add -A
git commit -m \"feat: [description]

Co-Authored-By: Claude <noreply@anthropic.com>\"
git push origin ralph
\`\`\`

## Step 7: Check Completion
If ALL tasks in the MVP plan are complete, respond with: <promise>COMPLETE</promise>

## Critical Rules
- Complete ALL steps in this single execution
- Fix ALL validation errors before committing
- ONE task only, then stop
- Make autonomous decisions - no questions
- Use pnpm, never npm
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
