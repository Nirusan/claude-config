---
name: implementation-plan
description: Create a detailed implementation plan with stories. Also creates an empty progress.md for tracking.
triggers:
  - "/implementation-plan"
  - "/plan"
  - "create implementation plan"
  - "créer le plan"
  - "create the plan"
  - "plan d'implémentation"
  - "break down into stories"
  - "découper en stories"
tools: Read, Write, Grep, Glob, Task
context: fork
args:
  - name: feature
    description: Feature name for feature-specific plan (creates in features/{name}/)
    required: false
---

# Implementation Plan Skill

Create a detailed implementation plan broken down into stories, plus an empty progress tracker.

## Usage

```
/implementation-plan                      # Main project → memory-bank/plan.md
/implementation-plan --feature=dark-mode  # Feature → memory-bank/features/dark-mode/plan.md
/plan                                     # Alias for /implementation-plan
/plan --feature=dark-mode                 # Alias with feature
```

## Behavior

1. **Determine output location** based on `--feature` parameter
2. **Spawn the Architect agent** to create the plan
3. Agent reads PRD and tech-stack, then breaks down into implementable stories
4. Agent creates both `plan.md` and `progress.md`

## Instructions

When this skill is invoked:

1. **Parse arguments**:
   - If `--feature=X` provided, set `feature_name = X`
   - Otherwise, `feature_name = null` (main project plan)

2. **Determine paths**:
   ```
   If feature_name:
     output_dir = memory-bank/features/{feature_name}/
     plan_file = memory-bank/features/{feature_name}/plan.md
     progress_file = memory-bank/features/{feature_name}/progress.md
     prd_file = memory-bank/features/{feature_name}/prd.md (if exists, else main prd.md)
   Else:
     output_dir = memory-bank/
     plan_file = memory-bank/plan.md
     progress_file = memory-bank/progress.md
     prd_file = memory-bank/prd.md
   ```

3. **Check for existing context**:
   ```
   Read {prd_file} - REQUIRED (fail if not found)
   Read memory-bank/tech-stack.md - REQUIRED (fail if not found)
   Read memory-bank/brief.md if it exists
   Read CLAUDE.md if it exists
   ```

4. **Validate prerequisites**:
   If PRD or tech-stack doesn't exist, inform user:
   > "Missing prerequisites. Please run `/prd` and `/tech-stack` first."

5. **Create output directory** if needed:
   ```bash
   mkdir -p {output_dir}
   ```

6. **Spawn the Architect agent**:
   Use the Task tool with `subagent_type: "architect"` (custom agent).

   Prompt for the agent:
   ```
   You are creating an implementation plan for: {feature_name or "the main product"}

   Context:
   - PRD: {full content of prd_file}
   - Tech Stack: {full content of tech-stack.md}
   - Brief: {summary if exists}

   Your goal:
   1. Break down the PRD into implementable stories
   2. Order stories by dependency (foundational work first)
   3. Keep stories small (completable in one session)
   4. Include specific tasks and acceptance criteria per story
   5. Add technical notes to help the implementer
   6. Map ALL files that will be created or modified before listing tasks
   7. Ensure every task meets the granularity guidelines below
   8. Self-review the plan before presenting it

   ## Task Granularity

   Each task in the plan should take **2-5 minutes** to implement. If a task feels bigger, break it down further.

   ### What a good task looks like:
   - One clear action: "Write test for email validation" or "Add validateEmail function"
   - Specific files mentioned: "Create `lib/validators.ts`"
   - Expected outcome clear: "Test should fail because validateEmail doesn't exist yet"
   - Follows TDD: test → verify fail → implement → verify pass → commit

   ### What a bad task looks like:
   - "Implement user authentication" (too vague, too large)
   - "Handle edge cases" (which edge cases?)
   - "Add validation" (what validation? where? what rules?)

   ### Red flags in plans — fix before proceeding:
   - Vague instructions without specific files or code
   - References to undefined functions or types
   - Steps that describe intent without showing what to do
   - Tasks that would take more than 10 minutes

   ## File Mapping

   Before listing tasks, document ALL files that will be created or modified:

   | File | Action | Responsibility |
   |------|--------|---------------|
   | `lib/validators.ts` | Create | Email and form validation functions |
   | `tests/validators.test.ts` | Create | Tests for all validators |
   | `app/auth/page.tsx` | Modify | Add email validation to signup form |

   This prevents surprises during implementation and helps `/dispatch` identify independent work.

   ## Plan Self-Review

   Before presenting the plan to the user, check:
   1. **Spec coverage**: Can every requirement from the PRD map to at least one task?
   2. **Placeholder scan**: Any "TBD", "TODO", or vague descriptions? Replace with specifics
   3. **Dependency order**: Are tasks ordered so each can be implemented without forward references?
   4. **Type consistency**: Do function/variable names match across tasks?
   5. **File mapping complete**: Is every file that will be touched listed?

   Fix issues inline before presenting.

   Create TWO files:
   1. {plan_file} - The implementation plan
   2. {progress_file} - Empty progress tracker with story checklist

   Output the plan now. Do not ask questions - you have all the context needed.
   ```

7. **Agent creates both files**

## Output Location

```
# Main project
memory-bank/
├── plan.md
└── progress.md

# Feature-specific
memory-bank/
└── features/
    └── {feature-name}/
        ├── plan.md
        └── progress.md
```

## Plan Template

```markdown
# Implementation Plan: {Feature/Product Name}

## Overview
{Summary of what we're building and technical approach}

## Prerequisites
- {Any setup needed before starting}

## File Map

| File | Action | Responsibility |
|------|--------|---------------|
| `path/to/file.ts` | Create/Modify | {What this file does or what changes} |

## Stories

### Phase 1: Foundation
| # | Story | Description | Complexity |
|---|-------|-------------|------------|
| 1 | {title} | {what to implement} | S/M/L |
| 2 | {title} | {what to implement} | S/M/L |

### Phase 2: Core Features
| # | Story | Description | Complexity |
|---|-------|-------------|------------|
| 3 | {title} | {what to implement} | S/M/L |

### Phase 3: Polish & Edge Cases
| # | Story | Description | Complexity |
|---|-------|-------------|------------|
| N | {title} | {what to implement} | S/M/L |

## Story Details

### Story 1: {Title}
**Goal**: {What this achieves}

**Tasks**:
- [ ] {Specific implementation task}
- [ ] {Specific implementation task}
- [ ] {Write tests for X}

**Acceptance Criteria**:
- [ ] {User-facing criterion}
- [ ] {Technical criterion}

**Technical Notes**:
- {Pattern to follow}
- {Gotcha to avoid}
- {Reference to similar code if brownfield}

**Files likely to change**:
- `path/to/file.ts`
- `path/to/other.ts`

---

### Story 2: {Title}
{Same format}

---

## Dependencies
- Story 2 depends on Story 1 (needs X component)
- Story 4 depends on Story 3 (needs API endpoint)

## Risks & Mitigations
| Risk | Mitigation |
|------|------------|
| {Technical risk} | {How to handle} |

## Definition of Done
- [ ] All tasks completed
- [ ] Tests passing
- [ ] Code reviewed (if applicable)
- [ ] No TypeScript errors
- [ ] Acceptance criteria met
```

## Progress Template

```markdown
# Progress: {Feature/Product Name}

## Status: Not Started

## Current Story
None

## Completed
(none yet)

## In Progress
(none yet)

## Remaining
- [ ] Story 1: {title}
- [ ] Story 2: {title}
- [ ] Story 3: {title}
- [ ] Story 4: {title}
...

## Notes
{Any blockers, decisions, or observations during implementation}
```

## Next Step

After creating the plan, output:
> "Plan created with {N} stories:
> - `{plan_file}`
> - `{progress_file}`
>
> Run `/implement` to start building (or `/implement --feature={name}` for features)."
