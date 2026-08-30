#!/usr/bin/env bash
# Import the exported skills into a Claude Code installation.
#
#   bash install.sh                      # user scope (~/.claude/skills)
#   bash install.sh --project /path/repo # project scope (<repo>/.claude/skills)
#   bash install.sh --with-gstack        # also copy the gstack-dependent wrappers
#   bash install.sh --with-learnings     # also copy raw memory files
#   bash install.sh --force              # overwrite skills that already exist
set -euo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET_ROOT="$HOME/.claude"
WITH_GSTACK=0
WITH_LEARNINGS=0
FORCE=0

while [ $# -gt 0 ]; do
  case "$1" in
    --project) TARGET_ROOT="$2/.claude"; shift 2;;
    --with-gstack) WITH_GSTACK=1; shift;;
    --with-learnings) WITH_LEARNINGS=1; shift;;
    --force) FORCE=1; shift;;
    -h|--help) sed -n '2,8p' "$0"; exit 0;;
    *) echo "unknown option: $1" >&2; exit 1;;
  esac
done

DEST="$TARGET_ROOT/skills"
mkdir -p "$DEST"
echo "Installing into: $DEST"
echo

installed=0; skipped=0
copy_skill() {
  local src="$1" name; name="$(basename "$src")"
  if [ -e "$DEST/$name" ] && [ "$FORCE" -eq 0 ]; then
    echo "  skip (exists): $name"; skipped=$((skipped+1)); return
  fi
  rm -rf "$DEST/$name"
  cp -r "$src" "$DEST/$name"
  echo "  installed: $name"; installed=$((installed+1))
}

echo "Core skills:"
for d in "$HERE"/skills/*/; do copy_skill "${d%/}"; done

if [ "$WITH_GSTACK" -eq 1 ]; then
  echo
  echo "gstack wrapper skills (require the gstack repo at ~/.claude/skills/gstack):"
  for d in "$HERE"/optional/gstack-skills/*/; do copy_skill "${d%/}"; done
fi

if [ "$WITH_LEARNINGS" -eq 1 ]; then
  echo
  echo "Raw memory files:"
  for p in "$HERE"/learnings/raw-memory/*/; do
    n="$(basename "${p%/}")"
    out="$TARGET_ROOT/imported-memory/$n"
    mkdir -p "$out"; cp -r "$p." "$out/"
    echo "  copied: $n -> $out"
  done
  echo
  echo "  NOTE: memory lives per project under ~/.claude/projects/<slug>/memory/."
  echo "  Move each folder into the matching project slug on this machine."
fi

echo
echo "Done. installed=$installed skipped=$skipped"
echo "Restart Claude Code (or start a new session) to pick up the new skills."
