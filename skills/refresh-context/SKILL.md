---
name: refresh-context
description: Re-read project documentation (CLAUDE.md, progress.txt, memory-bank/) to refresh context. Use when starting a new session, after a break, or when the user says "refresh", "reload context", "what's the current state", or "on en est où".
allowed-tools: Read, Glob
user-invocable: true
---

# Refresh Project Context

Re-read all key documentation files to understand the project.

## Files to Read (in order)

1. **CLAUDE.md** (project root)
   - Code conventions
   - Tech stack
   - Rules to follow

2. **memory-bank/** (if present, exclude brainstorm.md)
   - `prd.md` / `PRD.md` - Product Requirements
   - `tech-stack.md` - Detailed stack
   - `design-system.md` - UI/UX guidelines
   - `plan.md` - Implementation plan

3. **Implementation plan** (fallback search in priority order if not in memory-bank/)
   1. `memory-bank/*-implementation-plan.md` or `memory-bank/implementation-plan.md`
   2. `*-implementation-plan.md` or `implementation-plan.md` (project root)
   3. `docs/*-implementation-plan.md` or `docs/implementation-plan.md`
   4. First `**/*implementation-plan*.md` found elsewhere

4. **Progress file** (fallback search in priority order)
   1. `progress.txt`, `progress.md`, `PROGRESS.md` (project root)
   2. `memory-bank/progress.txt`, `memory-bank/progress.md`

5. **database/schema.sql** (if present)
   - Database structure

## Files to Ignore

- `brainstorm.md` - Research/ideation, not relevant for implementation
- `node_modules/`
- `.next/`

## Summary Output

After reading, display:
```
## Context Loaded

**Project:** [Name]
**Stack:** [Next.js, Supabase, etc.]
**Current phase:** [Phase X - Name]

**Key conventions:**
- [Convention 1]
- [Convention 2]

**Suggested next action:**
[What seems to be the logical next step]
```
