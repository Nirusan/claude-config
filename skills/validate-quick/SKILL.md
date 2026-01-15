---
name: validate-quick
description: Quick validation check returning pass/fail. Use AUTOMATICALLY before any git commit, before pushing code, when user asks "is it ready?", "can we commit?", "does it build?", "c'est prêt?", "on peut commit?", "ça build?", or wants a quick health check. Runs silently in background.
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
