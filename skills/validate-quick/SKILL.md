---
name: validate-quick
description: Quick validation check that returns pass/fail status. Use for fast CI-style checks without detailed output. Good for pre-commit verification or quick health checks.
allowed-tools: Bash(pnpm:*), Read
context: fork
agent: general-purpose
user-invocable: true
---

# Quick Validation Check

Run available validation scripts and return a simple pass/fail result.

## Process

1. Check `package.json` for available scripts
2. Run each available script silently
3. Return summary only

## Scripts to Check

Run in order, skip if not configured:
- `pnpm lint`
- `pnpm build`
- `pnpm test:e2e` or `pnpm test`

## Output Format

**All pass:**
```
✅ Validation passed
- Lint: OK
- Build: OK
- Tests: OK
```

**Some fail:**
```
❌ Validation failed
- Lint: OK
- Build: FAILED
- Tests: Skipped
```

## Rules

- No detailed error output (use `/validate` for that)
- No offer to fix (use `/validate` for that)
- Just run and report pass/fail
- Fast and non-interactive
