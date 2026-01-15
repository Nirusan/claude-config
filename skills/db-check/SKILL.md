---
name: db-check
description: Check Supabase database health, RLS policies, and performance. Use AUTOMATICALLY after writing SQL, creating tables, modifying migrations, or changing RLS policies. Also when user asks "is my database secure?", "check RLS", "any missing indexes?", "ma base est sécurisée?", "vérifie les RLS", "il manque des index?", or after any schema.sql changes.
allowed-tools: mcp__supabase__list_projects, mcp__supabase__get_advisors, mcp__supabase__list_tables
context: fork
agent: general-purpose
user-invocable: true
---

## Supabase Database Health Check

### Step 1: Identify Project
Use `mcp__supabase__list_projects` to list available projects.
Ask user to confirm if multiple projects are available.

### Step 2: List Tables
Use `mcp__supabase__list_tables` to see current schema.

### Step 3: Check Advisors

Run both security and performance checks:

**Security:**
- Use `mcp__supabase__get_advisors` with type="security"
- Check for:
  - Tables without RLS enabled
  - Missing policies
  - Exposed sensitive columns

**Performance:**
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
