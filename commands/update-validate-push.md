# Update, Validate & Push

Sequential workflow to update documentation, validate the build, and push changes.

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

### Step 3: Git Add, Commit & Push
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
- Git: [Committed and pushed / Skipped]
```
