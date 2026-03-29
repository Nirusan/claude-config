---
name: brainstorm
description: Explore and validate product ideas through structured brainstorming. Creates a product brief.
triggers:
  - "/brainstorm"
  - "brainstorm"
  - "brainstormer"
  - "let's brainstorm"
  - "réfléchissons"
  - "explore this idea"
  - "explorer cette idée"
  - "help me think through"
  - "aide-moi à réfléchir"
tools: Read, Write, WebSearch, WebFetch, Grep, Glob, Task
context: fork
---

# Brainstorm Skill

Interactive ideation and product discovery session. Outputs a structured product brief.

## Hard Gate

Do NOT write any code, scaffold any project, or take any implementation action until:
1. A design has been presented to the user
2. The user has explicitly approved the design
3. A design doc has been written and committed

This applies to EVERY project regardless of perceived simplicity. "Simple" projects are where unexamined assumptions cause the most waste.

## Behavior

1. **Spawn the Analyst agent** to conduct the brainstorming session
2. Agent asks targeted questions about the problem, users, and opportunity
3. **Scope detection**: If the request describes multiple independent subsystems (e.g., "build a platform with chat, file storage, billing, and analytics"), flag this immediately. Help decompose into sub-projects before brainstorming the first one in detail.
4. User and agent iterate until user says "generate", "create the brief", or similar
5. Create `memory-bank/brief.md`

## Instructions

When this skill is invoked:

1. **Check for existing context**:
   ```
   Read memory-bank/brief.md if it exists
   Read memory-bank/prd.md if it exists
   Read CLAUDE.md if it exists
   ```

2. **Spawn the Analyst agent**:
   Use the Task tool with `subagent_type: "analyst"` (custom agent).

   Prompt for the agent:
   ```
   You are conducting a brainstorming session to help the user explore and validate their product idea.

   Context found: {summarize any existing docs}

   Your goal:
   1. Understand the problem they're trying to solve
   2. Identify who has this problem
   3. Explore existing solutions and gaps
   4. Help them articulate a clear value proposition
   5. When they're ready, create memory-bank/brief.md

   Start by asking about the problem they want to solve. Be proactive but collaborative.

   User's initial input: {user's message if any}
   ```

3. **Let the agent run** the interactive session

4. **Output**: `memory-bank/brief.md`

## Design Doc

After the user approves the design:
1. Save the validated design to `memory-bank/brief.md` (already done)
2. Commit the design doc to git: `git add memory-bank/brief.md && git commit -m "docs: add product brief for {name}"`
3. This ensures the design is versioned and recoverable

## Output Location

```
memory-bank/
└── brief.md
```

## Brief Template

The agent should create a brief following this structure:

```markdown
# Product Brief: {Name}

## Problem Statement
{Clear, concise description of the problem}

## Target User
{Who they are, their context, their pain}

## Current Alternatives
{What exists today and why it falls short}

## Proposed Solution
{High-level concept, not implementation details}

## Key Differentiator
{The one thing that makes this worth building}

## Success Criteria
{How we'll know if this works}

## Open Questions
{Things to resolve in PRD phase}

## Out of Scope
{What this is NOT trying to solve}
```

## Spec Self-Review

Before presenting the brief to the user, review it with fresh eyes:
1. **Placeholder scan**: Any "TBD", "TODO", or vague requirements? Fix them
2. **Internal consistency**: Do sections contradict each other?
3. **Scope check**: Is this focused enough for a single implementation plan?
4. **Ambiguity check**: Could any requirement be interpreted two different ways? Pick one and make it explicit

Fix issues inline, then present to the user.

## User Review Gate

After writing the brief, explicitly ask the user to review:
> "Brief written and committed. Please review it and let me know if you want changes before we move to the PRD or implementation plan."

Wait for the user's response. Only proceed once approved.

## Next Step

After creating the brief, suggest:
> "Brief saved to `memory-bank/brief.md`. When ready to define requirements, run `/prd`."
