---
name: systematic-debugging
description: Structured 4-phase debugging process. Use when a bug is unclear, a fix has failed twice, or you're stuck on a problem instead of guessing randomly.
triggers:
  - "/debug"
  - "debug this"
  - "investigate this bug"
  - "find the root cause"
  - "why is this broken"
allowed-tools: Read, Write, Edit, Bash, Glob, Grep, TodoWrite, Agent
user-invocable: true
---

# Systematic Debugging

**Iron rule: NO fixes without root cause investigation first.**

Guessing at fixes creates new bugs. Follow the 4 phases in order.

## Phase 1: Reproduce and Investigate

1. **Read the error carefully** — full message, stack trace, exit codes
2. **Reproduce consistently** — find the exact steps that trigger the bug
3. **Check recent changes** — `git log --oneline -10` and `git diff` for what changed
4. **Trace the data flow** — follow the data backward from the error to its origin
5. **Add diagnostic logging** at boundary layers if the flow is unclear

**Output of this phase:** A clear statement of what happens vs what should happen, and where in the code the divergence starts.

## Phase 2: Pattern Analysis

1. **Find working examples** — is there similar code that works? What's different?
2. **Compare working vs broken** — document every difference
3. **Map dependencies** — what does the broken code depend on? Are those dependencies healthy?
4. **Check assumptions** — is the data shaped the way you think? Are types correct? Are env vars set?

**Output of this phase:** A list of differences and suspicious areas.

## Phase 3: Hypothesis and Testing

1. **Formulate a specific hypothesis** — "The bug happens because X returns Y when it should return Z"
2. **Test one variable at a time** — change only one thing per attempt
3. **Verify with evidence** — don't assume a fix worked, run the reproduction steps again
4. **If the hypothesis is wrong** — go back to Phase 1 with new information, don't guess again

**Critical rule: After 3 failed fix attempts, stop.** The problem is likely architectural, not a simple bug. Reassess the approach entirely instead of attempting fix #4.

## Phase 4: Fix and Verify

1. **Write a failing test** that reproduces the bug (TDD)
2. **Apply a single, targeted fix** — minimal change
3. **Run the test** — confirm it passes
4. **Run the full test suite** — confirm no regressions
5. **Remove diagnostic logging** added in Phase 1
6. **Commit** with a clear message explaining the root cause

```bash
git commit -m "fix: [what was fixed]

Root cause: [why it was broken]
Fix: [what was changed and why]"
```

## Red Flags — Restart from Phase 1

- You're proposing a fix before tracing the data flow
- You're changing multiple things at once
- Each fix reveals a new problem elsewhere
- You're wrapping code in try/catch to hide errors
- You're adding workarounds instead of fixing root causes

## Anti-Patterns

| Bad | Good |
|-----|------|
| "Let me try adding a null check" | "Let me trace where this null comes from" |
| Changing 3 things at once | Changing 1 thing, testing, then deciding next |
| "It works now" (without understanding why) | "It works because X was causing Y" |
| Suppressing the error | Fixing the source of the error |
| Googling the error and copy-pasting a fix | Understanding the error, then finding a solution |

## When to Escalate

Ask the user for help when:
- You've exhausted 3 hypotheses and none were correct
- The bug involves external services you can't inspect
- The fix requires an architectural decision (not a code fix)
- Reproduction depends on specific data or environment you don't have access to
