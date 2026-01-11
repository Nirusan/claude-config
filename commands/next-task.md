---
allowed-tools: Read, Glob
description: Identify the next incomplete task from the MVP plan
---

## Identify Next Task

### Step 1: Read MVP Plan
Find and read the implementation plan file:
- `memory-bank/mvp-implementation-plan.md`
- or `docs/implementation-plan.md`
- or any `*plan*.md` file in the project

### Step 2: Read Progress
Find and read the progress tracking file:
- `progress.txt`
- or `PROGRESS.md`
- or any progress tracking file

### Step 3: Analyze

Compare the plan with progress to identify:
1. The **current phase** (e.g., Phase 3 - Opportunity Detection)
2. **Completed tasks** in this phase
3. The **next task** to work on

### Step 4: Display Result

Output format:
```
## MVP Progress

📍 Current phase: [Phase name]
✅ Completed: X/Y tasks

## Next Task

**[Task name]**

Description: [What needs to be done]

Likely files:
- `path/to/file1.ts`
- `path/to/file2.ts`

Dependencies: [Tasks or files this depends on]
```

If MVP is complete, clearly indicate it.
