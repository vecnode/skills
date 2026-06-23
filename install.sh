#!/usr/bin/env bash
# install.sh — symlink all skills into ~/.claude/skills/
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")" && pwd)"
SKILLS_SRC="$REPO_ROOT/skills"
SKILLS_DST="${HOME}/.claude/skills"

mkdir -p "$SKILLS_DST"

for skill_dir in "$SKILLS_SRC"/*/; do
  name="$(basename "$skill_dir")"
  target="$SKILLS_DST/$name"

  if [ -L "$target" ]; then
    echo "up-to-date  $name"
  elif [ -e "$target" ]; then
    echo "skip        $name  (exists as real file/dir, remove it manually)"
  else
    ln -s "$skill_dir" "$target"
    echo "linked      $name"
  fi
done

echo ""
echo "Done. Skills available at: $SKILLS_DST"
