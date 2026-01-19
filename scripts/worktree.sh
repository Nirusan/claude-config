#!/bin/bash
set -e

# Git Worktree Manager for Claude Parallel Sessions
# Usage:
#   worktree.sh create <branch-name>    - Create a worktree for a branch
#   worktree.sh delete <branch-name>    - Remove a worktree
#   worktree.sh list                    - List all worktrees
#   worktree.sh cd <branch-name>        - Print the path (use with: cd $(worktree.sh cd feature))

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Find the git root of the main repo
find_git_root() {
  local dir="$PWD"
  while [[ "$dir" != "/" ]]; do
    if [[ -d "$dir/.git" ]] || [[ -f "$dir/.git" ]]; then
      echo "$dir"
      return 0
    fi
    dir="$(dirname "$dir")"
  done
  echo "Error: Not in a git repository" >&2
  return 1
}

GIT_ROOT=$(find_git_root)
REPO_NAME=$(basename "$GIT_ROOT")
WORKTREES_DIR="$(dirname "$GIT_ROOT")/${REPO_NAME}-worktrees"

create_worktree() {
  local branch="$1"
  local worktree_path="${WORKTREES_DIR}/${branch}"

  if [[ -z "$branch" ]]; then
    echo "Error: Branch name required"
    echo "Usage: worktree.sh create <branch-name>"
    exit 1
  fi

  # Create worktrees directory if it doesn't exist
  mkdir -p "$WORKTREES_DIR"

  # Check if worktree already exists
  if [[ -d "$worktree_path" ]]; then
    echo "Worktree already exists at: $worktree_path"
    echo "To use it: cd $worktree_path"
    exit 0
  fi

  # Check if branch exists remotely
  if git -C "$GIT_ROOT" ls-remote --heads origin "$branch" | grep -q "$branch"; then
    echo "Creating worktree from existing remote branch: $branch"
    git -C "$GIT_ROOT" fetch origin "$branch"
    git -C "$GIT_ROOT" worktree add "$worktree_path" "$branch"
  # Check if branch exists locally
  elif git -C "$GIT_ROOT" show-ref --verify --quiet "refs/heads/$branch"; then
    echo "Creating worktree from existing local branch: $branch"
    git -C "$GIT_ROOT" worktree add "$worktree_path" "$branch"
  else
    # Create new branch from current HEAD
    echo "Creating worktree with new branch: $branch"
    git -C "$GIT_ROOT" worktree add -b "$branch" "$worktree_path"
  fi

  echo ""
  echo "Worktree created successfully!"
  echo "Path: $worktree_path"
  echo ""
  echo "To start working:"
  echo "  cd $worktree_path"
  echo "  claude  # Start a new Claude session"
  echo ""
  echo "Pro tip: Open a new terminal tab for each worktree"
}

delete_worktree() {
  local branch="$1"
  local worktree_path="${WORKTREES_DIR}/${branch}"

  if [[ -z "$branch" ]]; then
    echo "Error: Branch name required"
    echo "Usage: worktree.sh delete <branch-name>"
    exit 1
  fi

  if [[ ! -d "$worktree_path" ]]; then
    echo "Error: Worktree not found at $worktree_path"
    exit 1
  fi

  echo "Removing worktree: $worktree_path"
  git -C "$GIT_ROOT" worktree remove "$worktree_path" --force
  echo "Worktree removed."

  # Optionally delete the branch
  read -p "Delete branch '$branch' as well? (y/N): " confirm
  if [[ "$confirm" =~ ^[Yy]$ ]]; then
    git -C "$GIT_ROOT" branch -D "$branch" 2>/dev/null || echo "Branch not found locally"
  fi
}

list_worktrees() {
  echo "Git Worktrees:"
  echo "=============="
  git -C "$GIT_ROOT" worktree list
  echo ""

  if [[ -d "$WORKTREES_DIR" ]]; then
    echo "Worktree directory: $WORKTREES_DIR"
    echo ""
    echo "Available worktrees:"
    for dir in "$WORKTREES_DIR"/*/; do
      if [[ -d "$dir" ]]; then
        local name=$(basename "$dir")
        local branch=$(git -C "$dir" branch --show-current 2>/dev/null || echo "unknown")
        echo "  - $name (branch: $branch)"
      fi
    done
  fi
}

get_path() {
  local branch="$1"
  local worktree_path="${WORKTREES_DIR}/${branch}"

  if [[ -d "$worktree_path" ]]; then
    echo "$worktree_path"
  else
    echo "Error: Worktree not found for branch: $branch" >&2
    exit 1
  fi
}

# Main command router
case "${1:-}" in
  create)
    create_worktree "$2"
    ;;
  delete|remove)
    delete_worktree "$2"
    ;;
  list|ls)
    list_worktrees
    ;;
  cd|path)
    get_path "$2"
    ;;
  *)
    echo "Git Worktree Manager for Claude Parallel Sessions"
    echo ""
    echo "Usage:"
    echo "  $(basename "$0") create <branch>   Create a worktree for a branch"
    echo "  $(basename "$0") delete <branch>   Remove a worktree"
    echo "  $(basename "$0") list              List all worktrees"
    echo "  $(basename "$0") cd <branch>       Get worktree path"
    echo ""
    echo "Example workflow:"
    echo "  # Create worktrees for parallel work"
    echo "  $(basename "$0") create feature/auth"
    echo "  $(basename "$0") create feature/api"
    echo "  $(basename "$0") create bugfix/login"
    echo ""
    echo "  # Open terminals and cd into each"
    echo "  cd \$($(basename "$0") cd feature/auth) && claude"
    echo ""
    echo "Worktrees directory: $WORKTREES_DIR"
    ;;
esac
