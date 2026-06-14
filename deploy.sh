#!/usr/bin/env bash
# Creates a GitHub repo, pushes this folder, and enables GitHub Pages.
# Requires the GitHub CLI (gh) installed and authenticated:  gh auth login
set -euo pipefail

REPO="${1:-f1-2026-live}"          # repo name (default: f1-2026-live)
VIS="${2:-public}"                  # public | private  (Pages needs public on free plans)

echo "→ Initialising git repo…"
git init -q
git add .
git commit -q -m "v1.0.0: F1 2026 live season timing board"
git branch -M main

echo "→ Creating GitHub repo '$REPO' ($VIS) and pushing…"
gh repo create "$REPO" --"$VIS" --source=. --remote=origin --push

USER="$(gh api user --jq .login)"

echo "→ Enabling GitHub Pages (branch: main, path: /)…"
gh api -X POST "repos/$USER/$REPO/pages" \
  -f "source[branch]=main" -f "source[path]=/" >/dev/null 2>&1 || \
  echo "  (If this errored, enable Pages manually: Settings → Pages → main / root)"

echo ""
echo "✓ Done. Your live board will be at:"
echo "  https://$USER.github.io/$REPO/"
echo "  (first build can take ~1 minute)"
