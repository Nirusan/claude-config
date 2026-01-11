---
allowed-tools: mcp__supabase__list_projects, mcp__supabase__get_advisors, mcp__supabase__list_tables
argument-hint: [security|performance|all]
description: Check Supabase advisors (security, RLS, performance)
---

## Supabase Database Health Check

### Step 1: Identify Project
Use `mcp__supabase__list_projects` to list available projects.
Ask user to confirm if multiple projects are available.

### Step 2: List Tables
Use `mcp__supabase__list_tables` to see current schema.

### Step 3: Check Advisors

Check type (based on "$ARGUMENTS" or "all" by default):

**If "security" or "all":**
- Use `mcp__supabase__get_advisors` with type="security"
- Check for:
  - Tables without RLS enabled
  - Missing policies
  - Exposed sensitive columns

**If "performance" or "all":**
- Use `mcp__supabase__get_advisors` with type="performance"
- Check for:
  - Missing indexes
  - Potential slow queries
  - Large tables without pagination

### Step 4: Report

Display a structured report:
```
## Supabase Report - [Project name]

### Tables (X total)
- profiles (RLS: ✅)
- opportunities (RLS: ✅)
- responses (RLS: ❌ MISSING)

### Security
✅ No issues detected
or
⚠️ 2 issues detected:
  1. [Description + remediation link]
  2. [Description + remediation link]

### Performance
✅ No issues detected
or
⚠️ 1 issue detected:
  1. [Description + remediation link]
```

Include remediation URLs provided by advisors.
