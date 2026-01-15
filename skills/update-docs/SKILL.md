---
name: update-docs
description: Intelligently update project documentation (CLAUDE.md, memory-bank/) based on recent changes. Use after implementing features, establishing new patterns, or when documentation needs to reflect current state.
allowed-tools: Read, Write, Edit, Glob
user-invocable: true
---

# Update Project Documentation

Update documentation **only if there are meaningful changes**.

## Scope

1. `CLAUDE.md` (project root)
2. All files in `memory-bank/` **except** `brainstorm.md`

## Process

### Step 1: Analyze Current State

Read the current content of target files.

### Step 2: Identify Potential Updates

Review recent work to identify:
- New patterns or conventions established
- New integrations or APIs added
- New components or features implemented
- Bug fixes that revealed important constraints
- Updated validation rules or business logic
- New environment variables required
- Changes to project structure

### Step 3: Evaluate Relevance

**For CLAUDE.md:**
- Does this help future sessions understand the codebase?
- Is this a reusable pattern or one-off implementation?
- Would missing this information cause bugs or confusion?

**DO NOT update if:**
- The information is trivial or obvious
- It duplicates existing content
- It's too specific to one implementation detail
- The existing documentation already covers it

### Step 4: Apply Updates

If relevant updates exist:
1. Make minimal, focused edits
2. Maintain existing formatting and style
3. Keep CLAUDE.md concise and scannable

## Output Format

```
## Documentation Update Report

### CLAUDE.md
- [Updated/No changes needed]
- Changes: [list if any]

### memory-bank/
- [filename]: [Updated/No changes needed] - [reason]
```

## Rules

- **Never** read or modify `memory-bank/brainstorm.md`
- Prefer editing existing sections over adding new ones
- Keep CLAUDE.md under ~300 lines if possible
