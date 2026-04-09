#!/bin/bash
# Checks if installed claude-rules are behind the plugin version.
# Run as a SessionStart hook — prints a one-line nudge if stale.

set -euo pipefail

PLUGIN_ROOT="${CLAUDE_PLUGIN_ROOT:-}"
[ -z "$PLUGIN_ROOT" ] && exit 0

DIST="$PLUGIN_ROOT/claude-rules/dist"
INSTALLED_HASH_FILE="$DIST/.installed-hash"
CURRENT_HASH_FILE="$DIST/.checksums"

# Only check if rules are installed (inject or symlink mode)
[ -f "$DIST/.mode-global" ] || exit 0

# Compare installed hash with current compiled hash
if [ -f "$INSTALLED_HASH_FILE" ] && [ -f "$CURRENT_HASH_FILE" ]; then
    installed=$(cat "$INSTALLED_HASH_FILE")
    current=$(shasum -a 256 "$DIST/global.md" 2>/dev/null | awk '{print $1}')
    if [ "$installed" != "$current" ]; then
        echo "claude-skills rules have been updated. Run /claude-skills:setup to refresh."
    fi
fi

# Check if hook scripts are newer than installed copies
for hook in remind-session-topic.sh log-skill-use.sh log-slash-command.sh; do
    src="$PLUGIN_ROOT/hooks/$hook"
    dst="$HOME/.claude/hooks/$hook"
    if [ -f "$src" ] && [ -f "$dst" ]; then
        if [ "$src" -nt "$dst" ]; then
            echo "claude-skills hooks have been updated. Run /claude-skills:setup to refresh."
            break
        fi
    fi
done

# Check statusline
src="$PLUGIN_ROOT/bin/statusline.sh"
dst="$HOME/.claude/statusline.sh"
if [ -f "$src" ] && [ -f "$dst" ] && [ "$src" -nt "$dst" ]; then
    echo "claude-skills statusline has been updated. Run /claude-skills:setup to refresh."
fi
