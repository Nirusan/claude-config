---
name: git-add-commit-push
description: Stage all changes, create a commit with auto-generated or custom message, and push to current branch. Use when the user says "commit", "push", "save changes", or wants to finalize their work.
allowed-tools: Bash(git:*)
user-invocable: true
---

# Git Add, Commit & Push

## Context

- Current branch: !`git branch --show-current`
- Status: !`git status --short`
- Changes summary: !`git diff HEAD --stat`
- Changes detail: !`git diff HEAD`

## Instructions

1. Run `git add .`
2. Create a commit:
   - If user provided a message, use it directly
   - Otherwise, generate a concise message based on the changes above
3. Push to origin: `git push -u origin <branch>`

## Auto-generated Message Format

- First line: short summary (50 chars max)
- Blank line
- Body: details if needed
- End with: `Co-Authored-By: Claude <noreply@anthropic.com>`

Run commands sequentially and confirm the result.
