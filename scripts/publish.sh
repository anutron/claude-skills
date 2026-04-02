#!/usr/bin/env bash
# Syncs publishable skills from AI-RON to this repo.
# Run from the claude-skills repo root.

set -euo pipefail

SOURCE="$HOME/Personal/AI-RON/.claude/skills"
DEST="$(cd "$(dirname "$0")/.." && pwd)/skills"

# Skills to exclude from publishing
EXCLUDE=(
  steal
  refresh-command-center
  logo
  software-best-practices
  publish-skills
  todo-agent
)

is_excluded() {
  local name="$1"
  # Exclude namespaced personal/work skills (never published)
  [[ "$name" == airon-* ]] && return 0
  [[ "$name" == thanx-* ]] && return 0
  for ex in "${EXCLUDE[@]}"; do
    [[ "$name" == "$ex" ]] && return 0
  done
  return 1
}

# Clean and re-copy
rm -rf "$DEST"
mkdir -p "$DEST"

copied=0
skipped=0

for skill_dir in "$SOURCE"/*/; do
  name="$(basename "$skill_dir")"
  if is_excluded "$name"; then
    echo "  skip: $name"
    skipped=$((skipped + 1))
  else
    cp -r "$skill_dir" "$DEST/$name"
    echo "  copy: $name"
    copied=$((copied + 1))
  fi
done

# Copy bin/ artifacts
BIN_SOURCE="$HOME/Personal/AI-RON/.claude/bin"
BIN_DEST="$(cd "$(dirname "$0")/.." && pwd)/bin"
BIN_PUBLISH=(
  statusline.sh
)

mkdir -p "$BIN_DEST"
bin_copied=0
for f in "${BIN_PUBLISH[@]}"; do
  if [ -f "$BIN_SOURCE/$f" ]; then
    cp "$BIN_SOURCE/$f" "$BIN_DEST/$f"
    echo "  copy: bin/$f"
    bin_copied=$((bin_copied + 1))
  else
    echo "  MISSING: bin/$f"
  fi
done

# Copy claude-rules snippets (global only — project snippets are personal)
RULES_SOURCE="$HOME/Personal/AI-RON/claude-rules/snippets/global"
RULES_DEST="$(cd "$(dirname "$0")/.." && pwd)/claude-rules/snippets/global"

rm -rf "$RULES_DEST"
mkdir -p "$RULES_DEST"
rules_copied=0
for f in "$RULES_SOURCE"/*.md; do
  cp "$f" "$RULES_DEST/$(basename "$f")"
  rules_copied=$((rules_copied + 1))
done
echo "  copy: $rules_copied rule snippets"

# Copy hooks
HOOKS_SOURCE="$HOME/Personal/AI-RON/scripts"
HOOKS_DEST="$(cd "$(dirname "$0")/.." && pwd)/hooks"
HOOKS_PUBLISH=(
  log-skill-use.sh
  log-slash-command.sh
)

mkdir -p "$HOOKS_DEST"
hooks_copied=0
for f in "${HOOKS_PUBLISH[@]}"; do
  if [ -f "$HOOKS_SOURCE/$f" ]; then
    cp "$HOOKS_SOURCE/$f" "$HOOKS_DEST/$f"
    echo "  copy: hooks/$f"
    hooks_copied=$((hooks_copied + 1))
  else
    echo "  MISSING: hooks/$f"
  fi
done

echo ""
echo "Published $copied skills ($skipped excluded), $rules_copied rules, $bin_copied bin files, $hooks_copied hooks"
