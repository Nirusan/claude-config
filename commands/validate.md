---
allowed-tools: Bash(pnpm:*)
description: Run lint, build, and E2E tests in sequence
---

## Full Project Validation

Run all 3 validation steps in order. Stop immediately if any step fails.

### Step 1: Lint
```bash
pnpm lint
```
- If errors: display them and offer to fix
- If ok: proceed to next step

### Step 2: Build (TypeScript)
```bash
pnpm build
```
- If type errors: display them and offer to fix
- If ok: proceed to next step

### Step 3: E2E Tests
```bash
pnpm test:e2e
```
- If tests fail: display summary and failing tests
- If ok: confirm all validations passed

## Final Summary

At the end, display a recap:
```
✅ Lint: OK
✅ Build: OK
✅ E2E Tests: OK (X tests passed)
```

Or if failed:
```
✅ Lint: OK
❌ Build: 3 type errors
⏭️ E2E Tests: Skipped
```
