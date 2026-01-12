---
allowed-tools: Read, Edit, Write, Glob
argument-hint: [description of what was done]
description: Update progress.txt AND mvp-implementation-plan.md with completed tasks
---

## Update Progress Files

Update BOTH tracking files to keep them synchronized:
1. `progress.txt` - Detailed task log
2. `memory-bank/mvp-implementation-plan.md` - Checkbox status

### Step 1: Read Current Files

Read both files:
- `progress.txt`
- `memory-bank/mvp-implementation-plan.md`

### Step 2: Analyze Recent Changes

If no argument provided ("$ARGUMENTS"), analyze:
- `git diff HEAD~1 --name-only` to see modified files
- `git log -1 --oneline` for the last commit

### Step 3: Update progress.txt

Add/update entry following the existing format in the file.

**Rules for progress.txt:**
- Add new completed tasks under the current phase section
- Mark tasks as `[x]` when completed
- Add date prefix for new task groups (e.g., `#### 2026-01-13: Task name`)
- Keep "Next Tasks" section updated
- Do NOT mark manual validation items as complete (those require human testing)

### Step 4: Update mvp-implementation-plan.md

Update the checkbox status:
- `- [ ]` → `- [x]` for completed **implementation** tasks
- Keep `- [ ]` for **validation** tasks that require manual testing
- Validation sections have "(tests manuels)" in the title - leave those unchecked unless human confirmed

**Important distinction:**
- **Implementation tasks** = Code exists → Can be checked ✅
- **Validation tasks** = Requires human testing → Stay unchecked until manually verified

### Step 5: Confirmation

Display a summary:
```
## Progress Updated

### progress.txt
- Added: [what was added]

### mvp-implementation-plan.md
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
