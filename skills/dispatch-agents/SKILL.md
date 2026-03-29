---
name: dispatch-agents
description: Orchestrate multiple subagents in parallel for independent tasks. Use when a feature has multiple unrelated parts that can be worked on simultaneously, or when multiple test failures affect different subsystems.
triggers:
  - "/dispatch"
  - "parallel agents"
  - "dispatch agents"
  - "work in parallel"
allowed-tools: Read, Glob, Grep, Agent, TodoWrite
user-invocable: true
---

# Dispatching Parallel Agents

Delegate independent tasks to multiple subagents working concurrently instead of solving everything sequentially.

## When to Use This

- Multiple unrelated failures across different files/subsystems
- A feature with independent parts (e.g., API + UI + tests that don't depend on each other)
- Investigation tasks that can be scoped to separate domains

## When NOT to Use This

- Tasks share state or modify the same files
- Failures are related (fixing one might fix the others)
- You need full system understanding before acting
- Exploratory debugging (use `/debug` instead)

## The Process

### Step 1: Identify Independent Domains

Group work by what's broken or what needs building. Each domain must be:
- **Self-contained** — understandable without the other domains
- **Non-overlapping** — agents won't edit the same files
- **Clear in scope** — specific goal, not "fix stuff"

### Step 2: Create Focused Agent Prompts

Each agent gets a prompt with:

1. **Context** — what the project is, what stack is used, relevant CLAUDE.md rules
2. **Specific scope** — exactly which files/modules to work on
3. **Clear goal** — what "done" looks like
4. **Constraints** — what NOT to touch, what patterns to follow

**Good prompt:**
> "Fix the authentication tests in `tests/auth.test.ts`. The `signIn` function now returns `{ user, session }` instead of just `user` (changed in `lib/auth.ts` line 42). Update the test expectations to match the new return type. Run `pnpm test tests/auth.test.ts` to verify."

**Bad prompt:**
> "Fix the failing tests."

### Step 3: Dispatch in Parallel

Use the Agent tool to launch all agents concurrently in a single message:

```
Agent 1: [Domain A task with full context]
Agent 2: [Domain B task with full context]
Agent 3: [Domain C task with full context]
```

### Step 4: Review and Integrate

Once all agents complete:
1. **Check for conflicts** — did any agents modify the same files?
2. **Run the full test suite** — `pnpm test` to verify everything works together
3. **Review each agent's changes** — quick sanity check on quality
4. **Fix integration issues** — if agents' changes don't compose well

## Agent Dispatch Checklist

Before dispatching, verify:
- [ ] Tasks are truly independent (no shared file modifications)
- [ ] Each prompt has enough context to work autonomously
- [ ] Each prompt specifies which files to work on
- [ ] Each prompt includes the verification command to run
- [ ] No agent needs the output of another agent to start

## Practical Examples

### Multiple Test Failures (different modules)

```
Agent 1: "Fix tests in tests/auth.test.ts — signIn return type changed from User to { user, session }"
Agent 2: "Fix tests in tests/billing.test.ts — Stripe API mock needs updating for v2 webhook format"
Agent 3: "Fix tests in tests/dashboard.test.ts — new required prop 'organizationId' on DashboardLayout"
```

### Feature with Independent Parts

```
Agent 1: "Create the database migration and RLS policies for the 'notifications' table"
Agent 2: "Build the NotificationBell component following the design system"
Agent 3: "Write the Server Action for marking notifications as read"
```

## Limits

- **3-5 agents max** — more than that and integration becomes the bottleneck
- **Don't dispatch implementation agents in parallel on the same feature** if they might conflict — use sequential execution instead
- **Always run the full test suite after integration** — parallel work can create subtle incompatibilities
