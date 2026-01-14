---
allowed-tools: Read, Edit, Write, Glob
argument-hint: [description of what was done]
description: Update progress files (progress.txt/.md and *-implementation-plan.md)
---

## Update Progress Files

Update tracking files to keep them synchronized.

### Step 1: Find Implementation Plan

Search for implementation plan file:
```bash
# Look for *-implementation-plan.md or *-implementation-plan.txt in memory-bank/ or root
```

Use Glob to find: `**/*-implementation-plan.md` or `**/*-implementation-plan.txt`

If no implementation plan exists, skip to Step 3 (progress file only).

### Step 2: Read Current Files

Read:
- The implementation plan file (if found)
- `progress.txt` or `progress.md` (whichever exists)

### Step 3: Analyze Recent Changes

If no argument provided ("$ARGUMENTS"), analyze:
- `git diff HEAD~1 --name-only` to see modified files
- `git log -1 --oneline` for the last commit

### Step 4: Update progress.txt/.md

Add/update entry following the existing format in the file.

**Rules:**
- Add new completed tasks under the current phase section
- Mark tasks as `[x]` when completed
- Add date prefix for new task groups (e.g., `#### 2026-01-13: Task name`)
- Keep "Next Tasks" section updated
- Do NOT mark manual validation items as complete (those require human testing)

### Step 5: Update Implementation Plan (if exists)

Update the checkbox status:
- `- [ ]` → `- [x]` for completed **implementation** tasks
- Keep `- [ ]` for **validation** tasks that require manual testing
- Validation sections have "(tests manuels)" or "(manual)" in the title - leave those unchecked unless human confirmed

**Important distinction:**
- **Implementation tasks** = Code exists → Can be checked ✅
- **Validation tasks** = Requires human testing → Stay unchecked until manually verified

### Step 6: Confirmation

Display a summary:
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

### Rules
- NEVER check validation items automatically
- Keep both files synchronized
- Use current date/time
- If "$ARGUMENTS" is provided, use it as task description
- If no implementation plan found, only update progress file
