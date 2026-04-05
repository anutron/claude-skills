## v1.1.2 — 2026-04-05

Added `RELEASE_NOTES.md` changelog. The `/publish-skills` workflow now prepends release notes to this file on every publish.

Updated skill: `write-skill` — no functional change (already in v1.1.1), just the publish-skills workflow improvement.

---

## v1.1.1 — 2026-04-05

Closes the loop on v1.1.0's description rewrite. The `/write-skill` skill now enforces the "Use when..." convention:

- **Template example** changed from `One-line summary of what this skill does` to `Use when <trigger situation> -- <what the skill does>`
- **Field docs** now say descriptions MUST start with "Use when..." and warns that noun-phrase descriptions will never auto-trigger
- **Validation checklist** item updated from "Description is present and includes trigger keywords" to "Description starts with 'Use when...' (trigger pattern, not noun phrase)"

New skills created with `/write-skill` will follow the trigger-pattern convention by default.

---

## v1.1.0 — 2026-04-05

All 24 publishable skill descriptions rewritten from noun phrases to trigger patterns so Claude Code's skill router matches them to user intent.

- **Before:** `"Multi-agent competing hypotheses debugging"` — describes what the skill *is*
- **After:** `"Use when encountering any bug, test failure, or unexpected behavior, before proposing fixes"` — tells Claude *when to use it*

This follows the [superpowers](https://github.com/obra/superpowers) convention where the `description` front-matter field acts as a routing instruction, not a label.

Updated skills (24): agent-driven-development, bugbash, changelog, close-worktree, debug, devils-advocate, disk-cleanup, execute-plan, fixit, guard, improve, merge, pr, pr-dashboard, promote, ralph-review, rereview, review, save-w-specs, spec-recommender, spec-writer, test, unstaged, write-skill

No new or removed skills. README skills table updated to match.

---

## v1.0.0 — 2026-04-04

Initial release. 37 skills, 12 rule snippets, status line script, and skill usage hooks.
