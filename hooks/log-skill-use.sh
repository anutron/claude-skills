#!/bin/bash
# Logs every Skill tool invocation to a TSV file for usage analysis.
# Triggered by PostToolUse hook with matcher "Skill".
# Deduplicates against slash command logger (log-slash-command.sh) to avoid
# double-counting when a user-typed /command also triggers a Skill tool call.

INPUT=$(cat)
SKILL_NAME=$(echo "$INPUT" | jq -r '.tool_input.skill // "unknown"')
SKILL_ARGS=$(echo "$INPUT" | jq -r '.tool_input.args // ""')
PROJECT_DIR="${CLAUDE_PROJECT_DIR:-unknown}"
TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

LOG_FILE="$HOME/.claude/skill-usage.tsv"

# Create header if file does not exist
if [ ! -f "$LOG_FILE" ]; then
  printf "timestamp\tskill\targs\tproject\n" > "$LOG_FILE"
fi

# Skip if the same skill was already logged in the last 10 seconds
# (by the UserPromptSubmit slash command hook)
LAST_LINE=$(tail -1 "$LOG_FILE" 2>/dev/null)
LAST_SKILL=$(echo "$LAST_LINE" | cut -f2)
if [ "$LAST_SKILL" = "$SKILL_NAME" ]; then
  LAST_TS=$(echo "$LAST_LINE" | cut -f1)
  if [ -n "$LAST_TS" ]; then
    LAST_EPOCH=$(date -j -u -f "%Y-%m-%dT%H:%M:%SZ" "$LAST_TS" +%s 2>/dev/null)
    NOW_EPOCH=$(date -u +%s)
    if [ -n "$LAST_EPOCH" ] && [ $((NOW_EPOCH - LAST_EPOCH)) -lt 10 ]; then
      exit 0
    fi
  fi
fi

printf "%s\t%s\t%s\t%s\n" "$TIMESTAMP" "$SKILL_NAME" "$SKILL_ARGS" "$PROJECT_DIR" >> "$LOG_FILE"

exit 0
