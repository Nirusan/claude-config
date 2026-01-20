---
name: next-task
description: Identify the next incomplete task from the implementation plan. Use when the user asks "what's next", "next task", "c'est quoi la suite", or wants to know what to work on next.
allowed-tools: Read, Glob
user-invocable: true
args:
  - name: feature
    description: Feature name to check (reads from memory-bank/features/{name}/)
    required: false
---

# Identify Next Task

## Step 0: Determine Context

1. **Check for --feature parameter**:
   - If `--feature=X` provided, set `feature_name = X`
   - Otherwise, check if `memory-bank/features/` exists

2. **If features exist and no param specified**:
   - List available features
   - Ask: "Which feature? (or 'main' for the main project, or 'all' to see overview)"

3. **Set paths based on context**:
   ```
   If feature_name and feature_name != 'main':
     plan_file = memory-bank/features/{feature_name}/plan.md
     progress_file = memory-bank/features/{feature_name}/progress.md
   Else:
     plan_file = memory-bank/plan.md (or *-implementation-plan.md)
     progress_file = memory-bank/progress.md (or progress.txt)
   ```

## Step 1: Read Plan

Find and read the implementation plan file at `{plan_file}`.

Fallback search if not found:
- `memory-bank/mvp-implementation-plan.md`
- `docs/implementation-plan.md`
- Any `*plan*.md` file in the project

## Step 2: Read Progress

Find and read the progress tracking file at `{progress_file}`.

Fallback search:
- `progress.txt`
- `PROGRESS.md`

## Step 3: Analyze

Compare the plan with progress to identify:
1. The **current phase** (e.g., Phase 2 - Core Features)
2. **Completed stories** in this phase
3. The **next story** to work on
4. Any **blockers or dependencies**

## Step 4: Display Result

Output format:
```
## Progress: {feature_name or 'Main Project'}

**Current phase**: {Phase name}
**Completed**: {X}/{Y} stories

---

## Next Story

### Story {N}: {Title}

**Goal**: {What this achieves}

**Tasks**:
- [ ] {task 1}
- [ ] {task 2}

**Files likely to change**:
- `path/to/file1.ts`
- `path/to/file2.ts`

**Dependencies**: {Any prerequisites}

---

Run `/implement --feature={name}` to start working on this story.
```

## Step 5: Handle Completion

If all stories are complete:
```
## {feature_name or 'Main Project'} Complete!

All {N} stories have been implemented.

**Completed**:
- [x] Story 1: {title}
- [x] Story 2: {title}
...

**Next steps**:
- Run `/validate` for final checks
- Consider creating a new feature with `/prd --feature=new-feature`
```

## Feature Flag Examples

```bash
/next-task                          # Asks which feature or uses main
/next-task --feature=dark-mode      # Shows next task for dark-mode
/next-task --feature=main           # Shows next task for main project
/next-task --feature=all            # Shows overview of all features
```

## Overview Mode (--feature=all)

When `--feature=all`:
```
## Project Overview

### Main Project
- Status: {X}/{Y} stories complete
- Next: Story {N} - {title}

### Feature: dark-mode
- Status: {X}/{Y} stories complete
- Next: Story {N} - {title}

### Feature: user-auth
- Status: Complete!

---

Run `/next-task --feature=X` for details on a specific feature.
```
