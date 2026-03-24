#!/bin/bash
# Logs user-typed slash commands to the skill usage TSV.
# Complements log-skill-use.sh (which catches Skill tool invocations).
# Triggered by UserPromptSubmit hook.

INPUT=$(cat)
PROMPT=$(echo "$INPUT" | jq -r '.prompt // empty')

# Only log slash commands
[[ "$PROMPT" != /* ]] && exit 0

# Extract skill name: first word after /, strip any trailing args
SKILL_NAME=$(echo "$PROMPT" | head -1 | awk '{print $1}' | sed 's|^/||')

# Skip built-in CLI commands that aren't skills
case "$SKILL_NAME" in
  help|clear|compact|resume|login|logout|status|config|init|permissions|cost|doctor|memory|hooks|mcp|vim|terminal-setup)
    exit 0
    ;;
esac

# Extract args (everything after the first word)
SKILL_ARGS=$(echo "$PROMPT" | head -1 | sed 's|^/[^ ]* *||')

PROJECT_DIR="${CLAUDE_PROJECT_DIR:-unknown}"
TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
LOG_FILE="$HOME/.claude/skill-usage.tsv"

# Create header if file does not exist
if [ ! -f "$LOG_FILE" ]; then
  printf "timestamp\tskill\targs\tproject\n" > "$LOG_FILE"
fi

printf "%s\t%s\t%s\t%s\n" "$TIMESTAMP" "$SKILL_NAME" "$SKILL_ARGS" "$PROJECT_DIR" >> "$LOG_FILE"

exit 0
