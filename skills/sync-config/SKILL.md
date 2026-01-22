---
name: sync-config
description: Sync local Claude config to GitHub repo. Use to backup or share your Claude configuration (CLAUDE.md, settings, commands, agents, skills).
allowed-tools: Bash(*)
user-invocable: true
disable-model-invocation: true
---

# Sync Claude Configuration

Sync your local `~/.claude/` config to the GitHub repo.

## Steps

1. Run the sync script:
```bash
cd ~/Sites/claudeCode && ./sync.sh
```

2. Review changes:
```bash
cd ~/Sites/claudeCode && git status && git diff
```

3. If changes look good, commit and push:
```bash
cd ~/Sites/claudeCode && git add -A && git commit -m "sync: update config" && git push
```

## Notes
- This syncs: CLAUDE.md, settings.json, commands, agents, skills
- The sync-config skill itself is NOT synced (local only)
- Review changes before pushing to avoid accidents
