## Session Topics

After understanding what a session is about (usually after the first real message), set the status line topic:

```bash
SESSION_ID=$(cat ~/.claude/session-topics/pid-$PPID.map 2>/dev/null)
# Register topic with CCC (if daemon is running)
ccc update-session --session-id "$SESSION_ID" --topic "Your Topic Here" 2>/dev/null || true
[ -n "$SESSION_ID" ] && echo "Your Topic Here" > ~/.claude/session-topics/${SESSION_ID}.txt
```

- Keep it concise (under ~50 chars). It renders in ALL CAPS in the status line.
- Do this silently — don't announce it to the user.
- The user can override anytime with `/set-topic <text>`.
- **Set once, then leave it alone.** The topic is a stable session identifier for distinguishing terminal windows — not a live activity ticker. Set it when you understand the session's purpose, then don't update it as you work through implementation steps. Only change it if the session genuinely pivots to a different project or goal. "REFACTORING TEST HARNESS" is a good topic; "TASK RUNNER REVIEW LOOP" is not — that's an activity within the session, not the session's identity.
