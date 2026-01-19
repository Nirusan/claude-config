---
name: worktree
description: Create and manage git worktrees for parallel Claude sessions. Use when starting work on a new feature/branch to enable parallel development.
allowed-tools: Bash, Read
user-invocable: true
triggers:
  - worktree
  - créer worktree
  - nouvelle branche parallèle
  - parallel branch
  - start new feature
auto-triggers:
  - when: "User wants to work on multiple features simultaneously"
    description: "Suggest creating worktrees for parallel work"
  - when: "User mentions needing to switch context frequently"
    description: "Recommend worktrees over git stash"
---

# Git Worktree Management

Git worktrees allow you to have multiple working directories for the same repository, each on a different branch. This is perfect for running multiple Claude sessions in parallel without conflicts.

## Quick Start

### Create a worktree for a new feature
```bash
./scripts/worktree.sh create feature/my-feature
```

### List existing worktrees
```bash
./scripts/worktree.sh list
```

### Navigate to a worktree
```bash
cd $(./scripts/worktree.sh cd feature/my-feature)
```

### Delete a worktree when done
```bash
./scripts/worktree.sh delete feature/my-feature
```

## Workflow for Parallel Claude Sessions

### 1. Plan your parallel work
Identify 2-4 independent features/fixes that can be developed simultaneously.

### 2. Create worktrees
```bash
./scripts/worktree.sh create feature/auth
./scripts/worktree.sh create feature/api
./scripts/worktree.sh create bugfix/login
```

### 3. Open terminals for each worktree
Each worktree is a separate directory. Open a new terminal tab/window for each:
- Terminal 1: `cd ../project-worktrees/feature-auth && claude`
- Terminal 2: `cd ../project-worktrees/feature-api && claude`
- Terminal 3: `cd ../project-worktrees/bugfix-login && claude`

### 4. Work in parallel
Each Claude session works independently on its branch. No conflicts, no stashing.

### 5. Merge when ready
From the main repo, merge completed features:
```bash
git merge feature/auth
git merge feature/api
```

### 6. Cleanup
```bash
./scripts/worktree.sh delete feature/auth
./scripts/worktree.sh delete feature/api
```

## Directory Structure

```
project/                          <- Main repo (main branch)
├── .git/
└── src/

project-worktrees/                <- Auto-created directory
├── feature-auth/                 <- Worktree (feature/auth branch)
│   └── src/
├── feature-api/                  <- Worktree (feature/api branch)
│   └── src/
└── bugfix-login/                 <- Worktree (bugfix/login branch)
    └── src/
```

## Benefits Over Stash

| Stash | Worktree |
|-------|----------|
| One context at a time | Multiple contexts simultaneously |
| Must stash/unstash | No context switching needed |
| Risk of forgetting stash | Clean separation |
| Can't run parallel tests | Run tests in parallel |
| Single terminal | Multiple terminals |

## Tips

- **Name branches descriptively**: `feature/user-auth`, `bugfix/api-timeout`
- **Keep worktrees short-lived**: Create, develop, merge, delete
- **Share with team**: Each developer can have their own worktrees locally
- **CI/CD friendly**: Each worktree can push to its own branch for CI

## Automation with Ralph

For autonomous parallel execution, combine with `ralph.sh`:
```bash
# Terminal 1
cd ../project-worktrees/feature-auth
./scripts/ralph.sh 5

# Terminal 2
cd ../project-worktrees/feature-api
./scripts/ralph.sh 5
```

Both features develop in parallel, each committing to their own branch.
