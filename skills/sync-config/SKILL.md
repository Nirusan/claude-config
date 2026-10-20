---
name: sync-config
description: Back up the Claude Code and Codex configs and memories to GitHub in one run (claude-config, claude-memory, codex-config, codex-memory). Use when the user says "sync config", "sync mes configs", "sauvegarde ma config", "/sync-config".
allowed-tools: Bash(*)
user-invocable: true
disable-model-invocation: true
---

# Sync Claude + Codex configuration

Invoking this skill authorizes committing and pushing these four repositories, and nothing else.

| Local clone | GitHub repo | Visibility | Filled by |
| --- | --- | --- | --- |
| `~/Sites/claudeCode` | `Nirusan/claude-config` | public | `~/Sites/claudeCode/sync.sh` |
| `~/Sites/claude-memory` | `Nirusan/claude-memory` | **private** | same script (auto-memory) |
| `~/Sites/codex-config` | `Nirusan/codex-config` | public | `~/Sites/codex-config/sync.sh` |
| `~/Sites/codex-memory` | `Nirusan/codex-memory` | **private** | same script (memories + `mintdex-*` skills) |

## Steps

1. **Bring each clone up to date** before syncing, so a stale clone never overwrites newer GitHub work (2026-10-20: codex-config sat a month behind). For each clone: `git -C <clone> pull --ff-only`. If a pull fails (local changes, divergence), stop and report; never reset or discard.

2. **Run both sync scripts:**
   ```bash
   ~/Sites/claudeCode/sync.sh && ~/Sites/codex-config/sync.sh
   ```
   Each script verifies on GitHub that its memory repo is PRIVATE and skips the memory copy otherwise. If either prints a "skipping" warning, report it; never work around the check.

3. **Review every clone:** `git -C <clone> status --short` and `git -C <clone> diff --stat`. Read the actual diff for the two public repos.

4. **Block leaks before committing.** In each clone with changes, scan the changed files for secrets (API keys, tokens, JWTs, private keys, passwords). In the two **public** repos, also flag personal data: absolute `/Users/...` paths, account ids, emails, business or tax notes. Any hit: stop and show the file and line with the value redacted; never commit it.

5. **Commit and push** each clone that changed, with a short message (`sync: <what changed>`), ending with the session's attribution line. Stage the reviewed paths, not unrelated stray files: list anything unexpected (e.g. `.DS_Store`, a nested clone) and leave it out.

6. **Report in French:** per repo, the commit hash and a one-line summary, or "rien à synchroniser"; plus any skipped step and why.

## Notes

- Never copy memory into a public repo, and never change a repo's visibility.
- `codex-config` publishes only the skills listed in `config/skills-manifest.txt`; private project skills (`mintdex-*`) go to `codex-memory` instead.
- Restore on a new machine: `install.sh` from each config repo, then `restore.sh` from each memory repo (see their READMEs).
