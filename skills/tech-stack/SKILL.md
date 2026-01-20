---
name: tech-stack
description: Define the technical stack and architecture for a project. Interactive session with the Architect agent.
triggers:
  - "/tech-stack"
  - "define tech stack"
  - "choose the stack"
  - "architecture discussion"
tools: Read, Write, Grep, Glob, Bash, Task
context: fork
---

# Tech Stack Skill

Interactive session to define the technical stack and key architecture decisions.

## Usage

```
/tech-stack   # Creates memory-bank/tech-stack.md
```

## Behavior

1. **Spawn the Architect agent** to conduct the technical discussion
2. Agent reads existing context (prd.md, brief.md) and analyzes requirements
3. Agent asks about constraints, scale, team skills, integrations
4. User and agent iterate until user says "generate", "finalize", or similar
5. Create `memory-bank/tech-stack.md`

## Instructions

When this skill is invoked:

1. **Check for existing context**:
   ```
   Read memory-bank/brief.md if it exists
   Read memory-bank/prd.md if it exists
   Read CLAUDE.md for user preferences (already includes stack preferences)
   Read package.json if it exists (brownfield project)
   ```

2. **Spawn the Architect agent**:
   Use the Task tool with `subagent_type: "architect"` (custom agent).

   Prompt for the agent:
   ```
   You are defining the technical stack for this project.

   Existing context:
   - Brief: {summary of brief.md if exists}
   - PRD: {summary of prd.md if exists}
   - User preferences from CLAUDE.md: Next.js, Tailwind, shadcn/ui, Supabase, pnpm
   - Existing package.json: {summary if exists - brownfield detection}

   Your goal:
   1. Understand technical requirements from the PRD
   2. Ask about constraints (hosting, budget, team, integrations)
   3. Propose a stack that fits the requirements
   4. Document key architecture decisions (ADRs)
   5. When ready, create memory-bank/tech-stack.md

   If this is a brownfield project (package.json exists), focus on matching existing patterns.

   Start by summarizing the technical needs you see from the PRD, then ask about any constraints.

   User's initial input: {user's message if any}
   ```

3. **Let the agent run** the interactive session

4. **Output**: `memory-bank/tech-stack.md`

## Output Location

```
memory-bank/
└── tech-stack.md
```

## Tech Stack Template

The agent should create a document following this structure:

```markdown
# Tech Stack

## Overview
{One paragraph rationale for the overall approach}

## Frontend
| Layer | Choice | Rationale |
|-------|--------|-----------|
| Framework | Next.js 14+ | App Router, RSC, Server Actions |
| Styling | Tailwind CSS + shadcn/ui | Rapid development, consistent design |
| State | Zustand | Simple, performant global state |
| Forms | React Hook Form + Zod | Type-safe validation |

## Backend
| Layer | Choice | Rationale |
|-------|--------|-----------|
| API | Next.js Server Actions | Colocation, type safety |
| Database | Supabase (PostgreSQL) | Auth + DB + Realtime + Storage |
| Auth | Supabase Auth | Built-in, secure, multiple providers |
| Storage | Supabase Storage | Integrated with auth |

## Infrastructure
| Layer | Choice | Rationale |
|-------|--------|-----------|
| Hosting | Vercel | Native Next.js support |
| CI/CD | GitHub Actions | Standard, integrated |
| Monitoring | Vercel Analytics | Built-in |

## Key Libraries
| Purpose | Library | Version |
|---------|---------|---------|
| Icons | lucide-react | latest |
| Date handling | date-fns | latest |
| {purpose} | {library} | {version} |

## Architecture Decisions

### ADR-1: {Decision Title}
- **Context**: {Why this decision was needed}
- **Decision**: {What we decided}
- **Alternatives considered**: {What else we looked at}
- **Consequences**: {Trade-offs we're accepting}

### ADR-2: {Decision Title}
{Same format}

## Data Model (High-Level)

### Core Entities
- **{Entity}**: {description, key fields}
- **{Entity}**: {description, key fields}

### Relationships
- {Entity A} → {Entity B}: {relationship type, description}

## Security Considerations
- Authentication: {approach}
- Authorization: {RLS, middleware, etc.}
- Data validation: {where and how}

## Performance Considerations
- Caching strategy: {approach}
- Image optimization: {approach}
- Bundle size: {considerations}
```

## Default Stack (from user preferences)

When no specific requirements contradict, default to:
- **Frontend**: Next.js 14+, Tailwind, shadcn/ui, Zustand
- **Backend**: Supabase (PostgreSQL, Auth, Storage)
- **Hosting**: Vercel
- **Package Manager**: pnpm

## Next Step

After creating the tech-stack, suggest:
> "Tech stack saved to `memory-bank/tech-stack.md`. Run `/implementation-plan` to create the development plan."
