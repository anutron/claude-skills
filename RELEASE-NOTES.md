# Release notes

## v1.0.0 -- 2026-04-05

First tagged release. The repo has been in use for months, but this marks the shift from a loose skill collection to a coherent architecture with layered discipline skills, an orchestration pattern, and spec-driven development as the backbone.

### Architecture: agent-driven-development

The headline change is a new three-layer skill architecture, adapted from [superpowers](https://github.com/obra/superpowers) and merged with our own innovations:

**Discipline skills** -- how agents should think and work:

- **[test-driven-development](skills/test-driven-development/SKILL.md)** -- red-green-refactor with extensive rationalization tables that make it hard for Claude to skip TDD under pressure. Includes [testing anti-patterns](skills/test-driven-development/testing-anti-patterns.md) reference.
- **[verification-before-completion](skills/verification-before-completion/SKILL.md)** -- evidence before claims. No "should work now" -- run the command, read the output, then state the result.

**Orchestration pattern** -- how agents coordinate:

- **[agent-driven-development](skills/agent-driven-development/SKILL.md)** -- the implement-test-review loop. Fresh agent per task, worktree isolation for parallel execution, two-stage review (spec compliance then code quality), native Task dependencies with `addBlockedBy` for automatic sequencing. Includes [implementer](skills/agent-driven-development/implementer-prompt.md), [spec-reviewer](skills/agent-driven-development/spec-reviewer-prompt.md), and [code-quality-reviewer](skills/agent-driven-development/code-quality-reviewer-prompt.md) prompt templates.

**Updated user-facing skills** -- the things you actually invoke:

- **[execute-plan](skills/execute-plan/SKILL.md)** -- rewritten to use agent-driven-development. Plans are parsed into Task dependency graphs, stages run in parallel worktrees, execution is fully autonomous (no mid-run questions).
- **[fixit](skills/fixit/SKILL.md)** -- still fire-and-forget, now with the implement-test-review loop and debugging reference docs.
- **[bugbash](skills/bugbash/SKILL.md)** -- each bug gets its own worktree, agents run in parallel, Task system tracks progress.

**Retired:** `/dev` -- its planning was absorbed by `/brainstorm`'s quick-confirm path, its execution by `agent-driven-development`.

### Debugging reference docs

Three new reference docs for the [debug](skills/debug/SKILL.md) skill, auto-loaded by any skill involving bug fixing:

- [root-cause-tracing](skills/debug/root-cause-tracing.md) -- trace bugs backward through the call stack to find the original trigger
- [condition-based-waiting](skills/debug/condition-based-waiting.md) -- replace arbitrary timeouts with condition polling in tests
- [defense-in-depth](skills/debug/defense-in-depth.md) -- validate at every layer data passes through

### Brainstorm visual companion

The [brainstorm](skills/brainstorm/SKILL.md) skill now ships with the visual companion server -- a zero-dep Node.js HTTP server for browser-based mockups, diagrams, and side-by-side comparisons during brainstorming sessions. Previously this required the superpowers plugin.

- `scripts/server.cjs` -- WebSocket server with live reload
- `scripts/start-server.sh` / `stop-server.sh` -- lifecycle management
- `scripts/frame-template.html` -- CSS theme with dark mode, selection UI
- [spec-document-reviewer-prompt.md](skills/brainstorm/spec-document-reviewer-prompt.md) -- optional subagent review for complex specs

### Other changes this week

- `/brainstorm` plans now include explicit dependency information so `/execute-plan` can build Task graphs
- Removed all references to the superpowers plugin -- replaced by native skills
- Synced session-topics env var fallback and execute-plan stage overlap check
- Renamed close-worktree skill (was incorrectly named "worktree")
- Added worktree-location rule snippet
- Hardened bugbash (investigation gate), ralph-review (audit resolution tracking), spec-audit (incremental mode, module dispatch)

### Skill count

38 published skills, 12 rule snippets, 2 hooks, 1 status line script.
