#!/bin/bash
# Run this script to create a GitHub repo and push FrameComp
# Requires: gh CLI (brew install gh) logged in, or manual GitHub setup

set -e
cd "$(dirname "$0")"

echo "→ Initializing git..."
git init
git add -A
git commit -m "Initial commit: FrameComp - Fujifilm X-T5 Composition Assistant"

echo "→ Creating GitHub repo and pushing..."
if command -v gh &> /dev/null; then
  gh repo create FrameComp --public --source=. --remote=origin --push
  echo ""
  echo "✓ Done! Repo: https://github.com/$(gh api user -q .login)/FrameComp"
else
  echo "GitHub CLI (gh) not found."
  echo "Install with: brew install gh"
  echo "Then run: gh auth login"
  echo ""
  echo "Or create the repo manually at https://github.com/new"
  echo "Then run:"
  echo "  git remote add origin https://github.com/YOUR_USERNAME/FrameComp.git"
  echo "  git branch -M main"
  echo "  git push -u origin main"
fi
