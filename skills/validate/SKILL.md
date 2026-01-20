---
name: validate
description: Run lint, build, and E2E tests in sequence. Use when the user wants to validate their code, run tests, or check if everything works before committing.
triggers:
  - "/validate"
  - "validate"
  - "valider"
  - "run tests"
  - "lancer les tests"
  - "vérifier le build"
allowed-tools: Bash(pnpm:*), Bash(grep:*), Bash(cat:*), Read
user-invocable: true
---

# Full Project Validation

Run all validation steps in order. Stop immediately if any step fails.

## Step 0: Detect Available Scripts

Check `package.json` to see which scripts are available:
- Look for `lint`, `build`, `test:e2e`, `test` scripts
- Adapt the workflow based on what exists

## Step 1: Lint (if available)

```bash
pnpm lint
```
- If script doesn't exist: skip with note
- If errors: display them and offer to fix
- If ok: proceed to next step

## Step 2: Build (if available)

```bash
pnpm build
```
- If script doesn't exist: skip with note
- If type errors: display them and offer to fix
- If ok: proceed to next step

## Step 3: Tests (if available)

Check which test script exists and run it:
- `pnpm test:e2e` (E2E tests)
- `pnpm test` (unit tests fallback)
- If neither exists: skip with note

## Final Summary

```
Lint: [OK / X errors / Not configured]
Build: [OK / X errors / Not configured]
Tests: [OK (X passed) / X failed / Not configured]
```

Adapt to what's actually available in the project.
