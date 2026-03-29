---
name: writing-skills
description: Create a new skill for the Claude Code config. Use when the user wants to add a new skill, command, or workflow to their configuration.
triggers:
  - "/writing-skills"
  - "create a skill"
  - "new skill"
  - "add a skill"
allowed-tools: Read, Write, Edit, Bash, Glob, Grep
user-invocable: true
---

# Writing Skills

Create new skills that follow the conventions of this config repo.

## Step 1: Understand the Need

Before creating a skill, answer:
- What task does this skill automate or guide?
- When should it be triggered? (manually via /command, or auto-invoked?)
- What tools does it need access to?
- Does an existing skill already cover this? (check skills/ directory)

## Step 2: Skill Structure

Every skill needs:

```
skills/{skill-name}/SKILL.md
```

### Required Frontmatter

```yaml
---
name: skill-name              # kebab-case
description: One-line description of what this skill does and when to use it
triggers:                      # Keywords that activate this skill
  - "/skill-name"
  - "natural language trigger"
allowed-tools: Read, Write, Edit, Bash, Glob, Grep  # Only what's needed
user-invocable: true           # true if user can call it with /command
---
```

### Content Guidelines

- **Lead with the action** -- what to do, not background explanation
- **Use checklists** where steps must be completed in order
- **Include "When to skip"** -- every skill should document its exceptions
- **Add anti-patterns** -- what NOT to do is as important as what to do
- **Keep it concise** -- under 150 lines. If longer, the skill is doing too much
- **No fluff** -- no motivational text, no "best practices" headers without content
- **English only** -- all skills must be written in English (CLAUDE.md rule)

## Step 3: Write the Skill

1. Create the directory: `mkdir -p skills/{skill-name}`
2. Write `SKILL.md` following the structure above
3. Test mentally: "If Claude reads only this file, can it execute the skill without ambiguity?"

## Step 4: Register the Skill

1. Add to `install.sh` SKILLS array (alphabetical order)
2. Add to `skills/skill-router/SKILL.md`:
   - Decision tree (if manually triggered)
   - Auto-invoke section (if auto-triggered)
   - Quick reference table
3. Commit: `git add skills/{skill-name} install.sh skills/skill-router/SKILL.md`

## Step 5: Verify

- Read the skill back and check for:
  - [ ] No placeholders or TODOs
  - [ ] Triggers are clear and won't conflict with existing skills
  - [ ] allowed-tools list is minimal (only what's needed)
  - [ ] Steps are actionable without external context
  - [ ] Anti-patterns or "when to skip" section exists

## Naming Conventions

- Skill names: `kebab-case` (e.g., `test-driven-development`)
- File: always `SKILL.md` (uppercase)
- Directory: matches skill name exactly
- Triggers: include both `/command` form and natural language

## Common Patterns

### Process Skill (brainstorm, debug, tdd)
- Steps must be followed in order
- Include "hard gate" if skipping steps is dangerous
- Include "red flags" for when to restart

### Audit Skill (security-check, seo-check, db-check)
- Checklist format
- Severity levels in output (Critical/High/Medium/Low)
- Specific file:line references

### Workflow Skill (validate-update-push, git-add-commit-push)
- Sequential commands
- Stop on failure
- Summary at the end
