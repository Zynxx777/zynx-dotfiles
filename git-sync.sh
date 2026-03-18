#!/usr/bin/env bash
# git-sync.sh — Smart dotfile backup for stow-based repos
set -euo pipefail

REPO="$(cd "$(dirname "$0")" && pwd)"
cd "$REPO"

# Stage all changes (respects .gitignore)
git add .

# If nothing staged, exit early
if git diff --cached --quiet; then
  echo "✓ Nothing new to commit. Dotfiles are up to date."
  exit 0
fi

# Build a smart commit message from changed files
CHANGED=$(git diff --cached --name-only | sed 's|base/.config/||' | paste -sd ', ')
MSG="chore: update ${CHANGED}"

git commit -m "$MSG"
git push origin master
echo "✓ Pushed: $MSG"
