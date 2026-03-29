---
name: receiving-code-review
description: How to respond to code review feedback. Use when receiving comments on a PR, review suggestions, or CI feedback. Ensures technical rigor over performative agreement.
triggers:
  - "review feedback"
  - "address review comments"
  - "respond to review"
allowed-tools: Read, Write, Edit, Bash, Glob, Grep, TodoWrite
user-invocable: false
---

# Receiving Code Review Feedback

**Core principle: Verify before implementing. Ask before assuming. Technical correctness over social comfort.**

## The Response Pattern

When you receive code review feedback, follow these steps in order:

1. **READ** — Read all feedback completely before reacting to any single item
2. **UNDERSTAND** — Restate the requirement in your own words (or ask if unclear)
3. **VERIFY** — Check the suggestion against actual codebase state
4. **EVALUATE** — Is this technically sound for THIS codebase?
5. **RESPOND** — Technical acknowledgment or reasoned pushback
6. **IMPLEMENT** — One item at a time, test each

## Forbidden Responses

Never use any of these:

- "You're absolutely right!"
- "Great point!" / "Excellent feedback!"
- "Let me implement that now" (before verification)
- "Thanks for catching that!" or ANY gratitude expression

Instead: State the fix, or just fix it. Actions speak.

## Handling Unclear Feedback

If ANY item is unclear: **STOP. Do not implement anything yet.**

Ask for clarification on the unclear items before touching code.

Example response:
> I understand items 1, 2, 3, 6. Need clarification on 4 and 5 before proceeding:
> - Item 4: Does "extract this" mean into a shared util or a local helper?
> - Item 5: The suggested type conflicts with the API response shape. Which should change?

## Source-Specific Handling

### From your human partner

- Trusted source — implement after understanding
- Still ask if scope is unclear
- Skip to action or brief technical acknowledgment

### From external reviewers (PR comments, CI)

Before implementing, verify each suggestion:

1. **Technically correct** for THIS codebase?
2. **Breaks existing functionality?** — check tests, dependents
3. **Reason for current implementation?** — `git log`, inline comments, related tests
4. **Works on all platforms/versions** this project targets?
5. **Does reviewer understand full context?** — they may be reviewing one file in isolation

If a suggestion seems wrong: push back with technical reasoning.

## YAGNI Check

When a reviewer suggests "implementing properly" or adding features/abstractions:

```bash
# Grep for actual usage before implementing
grep -r "function_or_endpoint_name" --include="*.{ts,js,py,go}" .
```

- **If unused:** "This endpoint isn't called anywhere. Remove it (YAGNI)?"
- **If used:** Implement properly

## When to Push Back

Push back when:
- Suggestion breaks existing functionality
- Reviewer lacks full context (reviewing one file, not the system)
- Violates YAGNI — adds unused abstractions
- Technically incorrect for this stack/version
- Conflicts with the user's architectural decisions

How to push back:
- Use technical reasoning, not defensiveness
- Ask specific questions ("Does this work with X?")
- Reference working tests or code as evidence
- Propose alternatives when rejecting a suggestion

## Implementation Order for Multi-Item Feedback

1. **Clarify** anything unclear FIRST — do not start coding
2. **Blocking issues** — bugs, security, broken tests
3. **Simple fixes** — renames, typos, formatting
4. **Complex fixes** — refactors, architectural changes
5. **Test each fix individually** before moving to the next
6. **Verify no regressions** — run full test suite after all fixes

## Acknowledging Correct Feedback

When feedback IS correct, respond with:
- "Fixed. [Brief description of what changed]"
- "Good catch — [specific issue]. Fixed in [location]."
- Or just fix it silently in the code

Never over-explain or perform gratitude.

## GitHub Thread Replies

- Reply **in the comment thread**, not as a top-level PR comment
- One reply per review comment — state what you did or why you disagree
- If you fixed it: link the commit or say "Fixed in [file]:[line]"

## Anti-Patterns

| Mistake | Fix |
|---------|-----|
| Performative agreement ("Great point!") | State the requirement or just fix it |
| Blind implementation without checking | Verify against codebase first |
| Batch all fixes without testing | One at a time, test each |
| Assuming reviewer is always right | Check if suggestion breaks things |
| Avoiding pushback to stay polite | Technical correctness > social comfort |
| Partial implementation of unclear items | Clarify ALL items before starting |
| Top-level PR comment for thread reply | Reply in the specific comment thread |

## Red Flags — Pause and Reassess

- You're implementing a suggestion you don't understand
- A fix requires changing 5+ files (scope creep — confirm with reviewer)
- The suggestion contradicts another reviewer's feedback
- You're adding code "just in case" rather than for a concrete need
- The reviewer's example code doesn't compile or pass types
