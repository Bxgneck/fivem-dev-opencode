#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SOURCE="$REPO_ROOT/.opencode/skills/fivem-dev"
DEST_ROOT="$HOME/.config/opencode/skills"
DEST="$DEST_ROOT/fivem-dev"

if [[ ! -f "$SOURCE/SKILL.md" ]]; then
  echo "Could not find skill: $SOURCE" >&2
  exit 1
fi

mkdir -p "$DEST_ROOT"
if [[ -d "$DEST" ]]; then
  BACKUP="$DEST.backup-$(date +%Y%m%d-%H%M%S)"
  mv "$DEST" "$BACKUP"
  echo "Previous installation backed up to: $BACKUP"
fi
cp -R "$SOURCE" "$DEST"

echo "Installed FiveM skill to: $DEST"
echo "Restart OpenCode, then invoke it with @fivem-dev."
