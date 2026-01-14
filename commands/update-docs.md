# Update Project Documentation

Intelligently update project documentation based on recent changes and learnings.

## Scope

Update the following files **only if there are meaningful changes**:
1. `CLAUDE.md` (project root)
2. All files in `memory-bank/` **except** `brainstorm.md`

## Process

### Step 1: Analyze Current State

Read the current content of:
- `CLAUDE.md`
- All files in `memory-bank/` (skip `brainstorm.md`)

### Step 2: Identify Potential Updates

Review recent work in this conversation and codebase changes to identify:
- New patterns or conventions established
- New integrations or APIs added
- New components or features implemented
- Bug fixes that revealed important constraints
- Performance optimizations worth documenting
- Updated validation rules or business logic
- New environment variables required
- Changes to project structure

### Step 3: Evaluate Relevance (Critical)

For each potential update, ask yourself:

**For CLAUDE.md:**
- Does this help future Claude sessions understand the codebase?
- Is this a reusable pattern or one-off implementation?
- Would missing this information cause bugs or confusion?
- Is this already implied by existing documentation?

**For memory-bank/ files:**
- Does this change the project's direction or architecture?
- Is this a decision that should be remembered long-term?
- Does this update existing outdated information?

**DO NOT update if:**
- The information is trivial or obvious
- It duplicates existing content
- It's too specific to one implementation detail
- It would make the file harder to scan quickly
- The existing documentation already covers it adequately

### Step 4: Apply Updates

If and only if relevant updates exist:
1. Make minimal, focused edits
2. Maintain existing formatting and style
3. Keep CLAUDE.md concise and scannable
4. Preserve the structure of memory-bank files

### Step 5: Report

Summarize what was updated (or why nothing was updated).

## Output Format

```
## Documentation Update Report

### CLAUDE.md
- [Updated/No changes needed]
- Changes: [list if any]

### memory-bank/
- [filename]: [Updated/No changes needed] - [reason]
```

## Important Rules

- **Never** read or modify `memory-bank/brainstorm.md`
- Prefer editing existing sections over adding new ones
- Remove outdated information rather than accumulating cruft
- Keep CLAUDE.md under ~300 lines if possible
- Use the same language as the existing documentation
