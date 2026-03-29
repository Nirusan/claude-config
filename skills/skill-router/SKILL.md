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
