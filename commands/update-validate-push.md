# Update, Validate & Push

Sequential workflow to update documentation, validate the build, update progress, and push changes.

## Workflow

Execute these steps **in order**, stopping if any step fails:

### Step 1: Update Documentation
Run `/update-docs` to intelligently update:
- `CLAUDE.md` (if meaningful changes exist)
- `memory-bank/` files (except `brainstorm.md`)

If no updates are needed, continue to the next step.

### Step 2: Validate
Run `/validate` to ensure:
- Lint passes (`pnpm lint`)
- Build passes (`pnpm build`)
- E2E tests pass (`pnpm test:e2e`)

**If validation fails:**
1. Report the error clearly
2. Ask the user: "Validation failed. Do you want me to fix this issue?"
3. Wait for user response before proceeding
4. If user agrees, fix the issue and re-run validation
5. If user declines, stop the workflow

### Step 3: Update Progress (Conditional)

**First, check if this applies:**
- Search for `*-implementation-plan.md` or `*-implementation-plan.txt` in the project
- If NO implementation plan exists → Skip this step entirely

**If implementation plan exists:**
- Determine if the work done in this session relates to a task in the plan
- If yes → Run `/update-progress` to update:
  - The implementation plan file (check off completed tasks)
  - `progress.txt` or `progress.md`
- If the work was unrelated to the plan → Skip this step

### Step 4: Git Add, Commit & Push
Run `/git-add-commit-push` to:
- Stage all changes
- Create a commit with an appropriate message
- Push to current branch

## Error Handling

At any step, if something unexpected happens:
1. Explain what went wrong
2. Ask the user how to proceed
3. Never force through errors silently

## Output

After completion, summarize:
```
## Summary
- Documentation: [Updated X files / No updates needed]
- Validation: [Passed / Fixed N issues]
- Progress: [Updated / Skipped (no plan) / Skipped (unrelated work)]
- Git: [Committed and pushed / Skipped]
```
