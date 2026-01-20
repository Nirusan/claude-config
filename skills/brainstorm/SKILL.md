---
name: brainstorm
description: Explore and validate product ideas through structured brainstorming. Creates a product brief.
triggers:
  - "/brainstorm"
  - "brainstorm"
  - "let's brainstorm"
  - "explore this idea"
  - "help me think through"
tools: Read, Write, WebSearch, WebFetch, Grep, Glob, Task
context: fork
---

# Brainstorm Skill

Interactive ideation and product discovery session. Outputs a structured product brief.

## Behavior

1. **Spawn the Analyst agent** to conduct the brainstorming session
2. Agent asks targeted questions about the problem, users, and opportunity
3. User and agent iterate until user says "generate", "create the brief", or similar
4. Create `memory-bank/brief.md`

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

## Next Step

After creating the brief, suggest:
> "Brief saved to `memory-bank/brief.md`. When ready to define requirements, run `/prd`."
