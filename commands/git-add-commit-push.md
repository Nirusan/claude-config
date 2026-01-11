---
allowed-tools: Bash(git:*)
argument-hint: [optional commit message]
description: Git add, commit (auto or custom message), and push to current branch
---

## Git Context

- Current branch: !`git branch --show-current`
- Status: !`git status --short`
- Changes summary: !`git diff HEAD --stat`
- Changes detail: !`git diff HEAD`

## Your Task

1. Run `git add .`
2. Create a commit with:
   - If a message is provided ("$ARGUMENTS"), use it directly
   - Otherwise, generate a concise message based on the changes above
3. Push to origin with current branch: `git push -u origin <branch>`

## Auto-generated Message Format
- First line: short summary (50 chars max)
- Blank line
- Body: details if needed
- End with: `Co-Authored-By: Claude <noreply@anthropic.com>`

Run these commands sequentially and confirm the result.
