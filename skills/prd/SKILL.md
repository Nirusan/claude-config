---
name: prd
description: Create a Product Requirements Document. Interactive session to define features, requirements, and scope.
triggers:
  - "/prd"
  - "create prd"
  - "créer un prd"
  - "define requirements"
  - "définir les besoins"
  - "write the prd"
  - "rédiger le prd"
tools: Read, Write, Grep, Glob, Task
context: fork
args:
  - name: feature
    description: Feature name for feature-specific PRD (creates in features/{name}/)
    required: false
---

# PRD Skill

Interactive session to create a Product Requirements Document.

## Usage

```
/prd                      # Main project PRD → memory-bank/prd.md
/prd --feature=dark-mode  # Feature PRD → memory-bank/features/dark-mode/prd.md
```

## Behavior

1. **Determine output location** based on `--feature` parameter
2. **Spawn the Product Manager agent** to conduct the requirements session
3. Agent reads existing context (brief.md) and asks clarifying questions
4. User and agent iterate until user says "generate", "create the prd", or similar
5. Create the PRD at the appropriate location

## Instructions

When this skill is invoked:

1. **Parse arguments**:
   - If `--feature=X` provided, set `feature_name = X`
   - Otherwise, `feature_name = null` (main project PRD)

2. **Determine paths**:
   ```
   If feature_name:
     output_dir = memory-bank/features/{feature_name}/
     output_file = memory-bank/features/{feature_name}/prd.md
   Else:
     output_dir = memory-bank/
     output_file = memory-bank/prd.md
   ```

3. **Check for existing context**:
   ```
   Read memory-bank/brief.md if it exists
   Read memory-bank/prd.md if it exists (for feature PRDs, understand main product)
   Read memory-bank/tech-stack.md if it exists
   Read CLAUDE.md if it exists
   ```

4. **Create output directory** if needed:
   ```bash
   mkdir -p {output_dir}
   ```

5. **Spawn the Product Manager agent**:
   Use the Task tool with `subagent_type: "product-manager"` (custom agent).

   Prompt for the agent:
   ```
   You are creating a PRD for: {feature_name or "the main product"}

   Existing context:
   - Brief: {summary of brief.md if exists}
   - Main PRD: {summary if feature PRD and main prd.md exists}
   - Tech Stack: {summary if exists}

   Your goal:
   1. Understand the scope (MVP vs future)
   2. Define user stories with acceptance criteria
   3. Document functional and non-functional requirements
   4. Prioritize using MoSCoW
   5. When ready, create {output_file}

   Start by confirming your understanding of what we're building, then ask about the main user flows.

   User's initial input: {user's message if any}
   ```

6. **Let the agent run** the interactive session

7. **Output**: PRD file at determined location

## Output Location

```
# Main project
memory-bank/
└── prd.md

# Feature-specific
memory-bank/
└── features/
    └── {feature-name}/
        └── prd.md
```

## PRD Template

The agent should create a PRD following this structure:

```markdown
# PRD: {Feature/Product Name}

## Overview
{One paragraph summary}

## Goals
- Primary: {main objective}
- Secondary: {supporting objectives}

## Non-Goals (Out of Scope)
- {Explicit exclusions}

## User Stories

### Core User Flows
1. **{Flow Name}**
   - As a {user}, I want to {action} so that {benefit}
   - Acceptance Criteria:
     - [ ] {criterion 1}
     - [ ] {criterion 2}

### Secondary Flows
{Same format}

## Functional Requirements

### {Feature Area 1}
| ID | Requirement | Priority | Notes |
|----|-------------|----------|-------|
| FR-1 | {requirement} | Must | {notes} |
| FR-2 | {requirement} | Should | {notes} |

## Non-Functional Requirements

| Category | Requirement | Target |
|----------|-------------|--------|
| Performance | Page load time | < 2s |
| Security | Authentication | {method} |

## Dependencies
- {External services, other features}

## Risks & Mitigations
| Risk | Impact | Mitigation |
|------|--------|------------|
| {risk} | H/M/L | {mitigation} |

## Success Metrics
- {Metric}: {target}

## Open Questions
- {Questions for tech team}
```

## Next Step

After creating the PRD, suggest:
> "PRD saved to `{output_file}`. Next:
> - `/tech-stack` to define the technical stack
> - Or `/implementation-plan` if stack is already decided"
