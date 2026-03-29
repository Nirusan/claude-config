---
name: skill-router
description: Automatically loaded at session start. Maps tasks to the right skill. Do not invoke manually.
user-invocable: false
---

# Skill Router

Before starting any task, check if a skill applies. If one does, invoke it. This is not optional.

## Decision Tree

```
User request
│
├── Wants to build something new?
│   └── /brainstorm → /implementation-plan → /implement
│
├── Wants to implement from an existing plan?
│   └── /implement (reads plan + progress, picks next story)
│
├── Wants to know what's next?
│   └── /next-task (reads progress, shows next story)
│
├── Wants to write a PRD?
│   └── /prd (invokes product-manager agent)
│
├── Wants to define the tech stack?
│   └── /tech-stack (invokes architect agent)
│
├── Bug or issue to fix?
│   └── /debug (systematic 4-phase investigation)
│
├── Writing new functionality?
│   └── /tdd (RED-GREEN-REFACTOR, tests first)
│
├── Multiple independent tasks?
│   └── /dispatch (parallel subagents)
│
├── Wants to validate code?
│   └── /validate (lint + build + tests)
│   └── /validate-quick (lint only)
│
├── Ready to commit and push?
│   └── /git-add-commit-push
│   └── /validate-update-push (validate + update docs + push)
│
├── Security-sensitive code (auth, API, DB, payments)?
│   └── /security-check (red-team audit)
│
├── Database changes?
│   └── /db-check (schema + RLS review)
│
├── SEO-related page changes?
│   └── /seo-check (SEO audit)
│
├── Needs to update docs or progress?
│   └── /update-docs or /update-progress
│
├── Marketing / content task?
│   └── /copywriting, /content-strategy, /email-sequence,
│       /launch-strategy, /marketing-ideas, /page-cro
│
└── None of the above?
    └── Proceed normally
```

## Auto-Invoke Agents (no manual trigger needed)

These agents and tools MUST be used automatically when working in their domain. Do not wait for the user to ask.

### Frontend / UI Work
**When:** Creating or modifying any visual component, page, or layout.
**Action — choose based on scope:**
- **Gemini MCP** (default for significant UI work): Use `create_frontend`, `modify_frontend`, `snippet_frontend` as defined in CLAUDE.md. Never write frontend/UI code yourself for full pages, sections, or complex components.
- **frontend-design plugin** (small scope): For minor UI tweaks, small isolated components, or when Gemini MCP is unavailable. Claude writes the code itself, guided by the plugin's aesthetic principles.

**Pre-check:** Verify `design-system.md` exists at project root. If missing, run `generate_vibes` first (required for both approaches).

**Post-check (visual verification):** After any frontend change, verify the result in the browser before committing:
1. Ensure `pnpm dev` is running
2. Navigate to the affected page via **chrome-devtools** (`navigate_page`)
3. Take a snapshot (`take_snapshot`) and verify the result visually
4. If something looks off, fix it and re-check — do not commit broken UI

### Next.js / React Code
**When:** Working on App Router, Server Components, Server Actions, API routes, or any Next.js-specific code.
**Action:** Spawn the **nextjs-developer** agent for implementation guidance on async APIs, data fetching patterns, caching strategies, and performance best practices.

### Supabase / Database
**When:** Writing queries, creating migrations, setting up auth, or configuring RLS policies.
**Action:** Spawn the **supabase-developer** agent for correct client initialization (server vs client), RLS patterns, and query optimization.

### SEO-Sensitive Changes
**When:** Creating or modifying user-facing pages, changing routes, updating metadata, or adding images.
**Action:** Spawn the **seo-specialist** agent to audit the changes (metadata, headings, structured data, Core Web Vitals).

### Code Review (post-implementation)
**When:** After completing any implementation task (story, feature, bug fix).
**Action:** Spawn the **code-reviewer** agent with fresh eyes on the diff. This is already part of `/implement` Phase 4 but applies to all code changes, not just plan-based work.

## Key Rules

1. **Process skills first** — brainstorm, debug, tdd come BEFORE implementation
2. **Don't skip brainstorm for "simple" tasks** — simple tasks are where assumptions cause the most waste
3. **TDD for all new functionality** — no production code without a failing test first
4. **Debug before guessing** — if a bug is unclear, use /debug instead of trial-and-error
5. **Validate before committing** — always run /validate or /validate-quick before commit
6. **Security check on sensitive code** — auth, payments, user input, API routes, DB queries

## Skill Quick Reference

| Skill | Trigger | When |
|-------|---------|------|
| brainstorm | `/brainstorm` | New feature or idea to explore |
| prd | `/prd` | Define product requirements |
| tech-stack | `/tech-stack` | Define or review technical stack |
| implementation-plan | `/implementation-plan` | Break feature into stories |
| implement | `/implement` | Execute next story from plan |
| next-task | `/next-task` | See what's next in the plan |
| tdd | `/tdd` | Write tests first, then code |
| debug | `/debug` | Investigate a bug systematically |
| dispatch | `/dispatch` | Parallel work on independent tasks |
| validate | `/validate` | Full validation (lint + build + tests) |
| validate-quick | `/validate-quick` | Quick lint check |
| security-check | `/security-check` | Red-team security audit |
| db-check | `/db-check` | Database schema + RLS review |
| seo-check | `/seo-check` | SEO audit on page changes |
| git-add-commit-push | `/git-add-commit-push` | Commit and push |
| validate-update-push | `/validate-update-push` | Validate + update docs + push |
| update-progress | `/update-progress` | Update progress file |
| update-docs | `/update-docs` | Update documentation |
| refresh-context | `/refresh-context` | Reload project context |
