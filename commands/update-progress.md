---
allowed-tools: Read, Edit, Write
argument-hint: [description of what was done]
description: Update progress.txt with completed tasks
---

## Update Progress File

### Step 1: Read Current progress.txt
Read `progress.txt` to understand the existing format.

### Step 2: Analyze Recent Changes
If no argument provided ("$ARGUMENTS"), analyze:
- `git diff HEAD~1 --name-only` to see modified files
- `git log -1 --oneline` for the last commit

### Step 3: Update the File

Add a new entry with this format:
```markdown
## [Date - YYYY-MM-DD HH:MM]

### Task: [Task name]

**Modified files:**
- `path/to/file1.ts` - [short description]
- `path/to/file2.ts` - [short description]

**What was done:**
- [Point 1]
- [Point 2]

**Tests:** ✅ Passed / ❌ X failures

---
```

### Rules
- Do not delete existing entries
- Add new entry at the TOP of the file (after title if present)
- Use current date/time
- If "$ARGUMENTS" is provided, use it as task description
- Keep descriptions concise

### Confirmation
Display a summary of what was added to the file.
