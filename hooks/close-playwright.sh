#!/bin/bash
# Close Playwright/Chromium browsers spawned by the current Claude Code session.
# Scoped to descendants of the Claude Code process — other worktrees untouched.

find_claude_pid() {
  local pid=$PPID
  local depth=0
  while [ -n "$pid" ] && [ "$pid" != "1" ] && [ "$pid" != "0" ] && [ $depth -lt 10 ]; do
    local comm
    comm=$(ps -p "$pid" -o comm= 2>/dev/null | tr -d ' ')
    case "$comm" in
      *claude*) echo "$pid"; return 0 ;;
    esac
    pid=$(ps -o ppid= -p "$pid" 2>/dev/null | tr -d ' ')
    depth=$((depth + 1))
  done
  echo "$PPID"
}

get_descendants() {
  local parent=$1
  local child
  for child in $(pgrep -P "$parent" 2>/dev/null); do
    echo "$child"
    get_descendants "$child"
  done
}

CLAUDE_PID=$(find_claude_pid)

for pid in $(get_descendants "$CLAUDE_PID"); do
  cmd=$(ps -p "$pid" -o command= 2>/dev/null)
  if echo "$cmd" | grep -qE 'playwright|chromium|--remote-debugging-port'; then
    kill "$pid" 2>/dev/null || true
  fi
done

exit 0
