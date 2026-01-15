---
name: security-check
description: Red-team security audit for code changes. Use automatically when working on authentication, authorization, user inputs, API endpoints, database queries, or any security-sensitive code. Also use before commits that touch sensitive areas.
---

## Security Check - Red Team Audit

Act as a red-team penetration tester. Thoroughly investigate the current feature/code for security vulnerabilities, permission gaps, and attack vectors. Be paranoid and assume attackers are creative.

### Security Audit Checklist

#### 1. Injection Vulnerabilities
- [ ] SQL Injection (raw queries, string concatenation)
- [ ] NoSQL Injection (MongoDB, Supabase filters)
- [ ] Command Injection (shell commands, exec, spawn)
- [ ] XSS (Cross-Site Scripting) - reflected, stored, DOM-based
- [ ] Template Injection (server-side rendering)
- [ ] Path Traversal (file access, `../` patterns)

#### 2. Authentication & Authorization
- [ ] Missing authentication on sensitive routes
- [ ] Broken access control (IDOR, privilege escalation)
- [ ] JWT vulnerabilities (weak secrets, no expiry, algorithm confusion)
- [ ] Session management issues
- [ ] Missing CSRF protection on state-changing operations
- [ ] Insecure password handling

#### 3. Data Exposure
- [ ] Hardcoded secrets, API keys, credentials
- [ ] Sensitive data in logs
- [ ] Excessive data in API responses
- [ ] Missing input validation
- [ ] Insecure direct object references
- [ ] PII exposure in URLs or client-side storage

#### 4. Database Security (if Supabase/DB present)
- [ ] Missing RLS policies
- [ ] Overly permissive RLS rules
- [ ] Service role key exposed to client
- [ ] Unvalidated user input in queries

#### 5. API Security
- [ ] Missing rate limiting
- [ ] No input sanitization
- [ ] Verbose error messages leaking internals
- [ ] Missing security headers (CSP, HSTS, X-Frame-Options)
- [ ] CORS misconfiguration
- [ ] Mass assignment vulnerabilities

#### 6. Dependencies & Config
- [ ] Known vulnerabilities in dependencies (`pnpm audit`)
- [ ] Outdated packages with security patches
- [ ] Insecure default configurations
- [ ] Debug mode enabled in production
- [ ] Source maps exposed in production

#### 7. Client-Side Security
- [ ] Sensitive logic in client code
- [ ] localStorage/sessionStorage with sensitive data
- [ ] Eval or Function constructor usage
- [ ] Prototype pollution risks
- [ ] Clickjacking vulnerabilities

### Methodology

1. **Reconnaissance**: Understand the code structure and data flow
2. **Threat Modeling**: Identify attack surfaces and entry points
3. **Vulnerability Scanning**: Check each item systematically
4. **Exploitation Analysis**: Assess real-world exploitability
5. **Impact Assessment**: Rate severity (Critical/High/Medium/Low)

### Output Format

```
## Security Audit Report

**Scope:** [files/features analyzed]
**Risk Level:** [Critical | High | Medium | Low]

### Critical Issues (fix immediately)
1. **[Vulnerability Type]** - `file:line`
   - Description: ...
   - Attack vector: ...
   - Fix: ...

### High Priority
...

### Medium Priority
...

### Low Priority / Recommendations
...

### Passed Checks
- No SQL injection found
- RLS properly configured
- ...

### Summary
- X critical issues
- X high priority
- X medium priority
- X recommendations
```

### Important

- Be specific: include file paths, line numbers, and code snippets
- Provide actionable fixes, not just descriptions
- Consider the full attack chain, not isolated vulnerabilities
- Check for defense in depth - one layer failing shouldn't compromise everything
- Flag anything that "smells wrong" even if not immediately exploitable
