---
name: update-progress
description: Update progress tracking files (progress.txt and implementation plan). Use after completing tasks, implementing features, or when the user wants to record progress.
allowed-tools: Read, Edit, Write, Glob
user-invocable: true
---

# Update Progress Files

Keep tracking files synchronized with completed work.

## Step 1: Find Implementation Plan

Search for: `**/*-implementation-plan.md` or `**/*-implementation-plan.txt`

If no implementation plan exists, skip to Step 3.

## Step 2: Read Current Files

Read:
- The implementation plan file (if found)
- `progress.txt` or `progress.md` (whichever exists)

## Step 3: Analyze Recent Changes

If no description provided, analyze:
- `git diff HEAD~1 --name-only` for modified files
- `git log -1 --oneline` for the last commit

## Step 4: Update progress.txt/.md

Follow the existing format:
- Add new completed tasks under the current phase
- Mark tasks as `[x]` when completed
- Add date prefix for new task groups
- Keep "Next Tasks" section updated
- Do NOT mark manual validation items as complete

## Step 5: Update Implementation Plan (if exists)

Update checkbox status:
- `- [ ]` to `- [x]` for completed **implementation** tasks
- Keep `- [ ]` for **validation** tasks (require manual testing)

**Important:**
- **Implementation tasks** = Code exists -> Can be checked
- **Validation tasks** = Requires human testing -> Stay unchecked

## Step 6: Confirmation

```
## Progress Updated

### Progress file
- Updated: [filename]
- Added: [what was added]

### Implementation plan
- File: [filename or "Not found - skipped"]
- Checked: [X items]
- Still pending: [Y items]

### Manual validation required:
- [ ] Item 1
- [ ] Item 2
```
