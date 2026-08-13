#!/usr/bin/env bash
# Lists every SKILL.md in this repo (one per line, repo-relative path).
set -euo pipefail

REPO="$(cd "$(dirname "$0")/.." && pwd)"
cd "$REPO"
find . -name SKILL.md -not -path '*/node_modules/*' | sed 's|^\./||' | sort
