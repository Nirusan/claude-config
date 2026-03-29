---
name: test-driven-development
description: Enforce TDD (Red-Green-Refactor) for features, bug fixes, and refactoring. Use when writing new functionality, fixing bugs, or when the user explicitly asks for TDD.
triggers:
  - "/tdd"
  - "test-driven"
  - "write tests first"
  - "red green refactor"
allowed-tools: Read, Write, Edit, Bash, Glob, Grep, TodoWrite
user-invocable: true
---

# Test-Driven Development

**Iron rule: NO production code without a failing test first.**

## The Cycle: RED -> GREEN -> REFACTOR

### RED: Write a Failing Test

1. Write **one** minimal test for the next behavior to implement
2. Use clear naming that describes the behavior: `should reject empty email`, not `test1`
3. Test real behavior, not mocks (mocks only when unavoidable: external APIs, time, etc.)
4. One assertion per test — if the name contains "and", split it

### Verify RED (mandatory)

```bash
pnpm test
```

**Confirm all 3 conditions before proceeding:**
- [ ] The new test **fails** (not errors — fails)
- [ ] The failure message matches your expectation
- [ ] The failure is because the feature is **missing**, not because of a typo

If the test passes immediately: **delete it**. A test that never failed proves nothing.

### GREEN: Write Minimal Code

1. Write the **simplest** code that makes the test pass
2. No extra features, no "while I'm here" improvements
3. Don't optimize yet — just make it green

### Verify GREEN (mandatory)

```bash
pnpm test
```

**Confirm:**
- [ ] The new test passes
- [ ] All existing tests still pass
- [ ] No warnings or errors in output

### REFACTOR: Clean Up

1. Remove duplication
2. Improve naming
3. Extract helpers if needed
4. Run tests again to confirm nothing broke

### Then: Commit

One commit per RED-GREEN-REFACTOR cycle:
```bash
git add .
git commit -m "test: [behavior] + feat: [implementation]"
```

## Applying TDD to Bug Fixes

1. **RED**: Write a test that reproduces the bug (it should fail)
2. **Verify RED**: Confirm the test fails for the right reason
3. **GREEN**: Fix the bug with minimal code
4. **Verify GREEN**: Bug test passes, all other tests pass
5. **REFACTOR**: Clean up if needed

## When to Skip TDD

- Text-only changes (copy, translations)
- Pure config changes (env vars, tailwind config)
- Style-only changes (CSS, spacing, colors)
- Deleting unused code

## Red Flags — Restart the Cycle

Stop and go back to RED if:
- You wrote production code before writing a test
- A test passes immediately on creation
- You can't explain why the test should fail
- You're rationalizing "just this once"

If production code was written without a test: **delete the code**, write the test first, then reimplement from the test.

## Good Test Characteristics

| Property | Meaning |
|----------|---------|
| **Minimal** | One behavior per test |
| **Clear** | Name describes the behavior, not the implementation |
| **Fast** | No unnecessary setup, no real network calls |
| **Independent** | Tests don't depend on execution order |
| **Deterministic** | Same result every time, no flaky tests |

## Completion Checklist

Before marking the task as done:
- [ ] Every new function has a corresponding test
- [ ] Every test was observed failing before implementation
- [ ] Failures reflected missing features, not typos
- [ ] Implementation was minimal for each GREEN step
- [ ] All tests pass with no warnings
- [ ] Edge cases and error paths are covered
