## Spec Review via Plannotator

**For new feature development, use `/airon-develop`** instead of `/brainstorm`. It combines brainstorming and planning into a tighter flow with one review gate (the plan) instead of two (spec + plan). The spec is still written and AI-reviewed, but the user does not review it separately — by that point, the design was already approved in conversation.

**When `/airon-develop` is NOT driving** (e.g., standalone spec edits, manual brainstorming, or spec files written outside the brainstorming flow), use Plannotator for spec review:

1. Write the spec file (do NOT commit yet)
2. Invoke `/plannotator-specs` — this opens Plannotator in the browser for inline annotation
3. Address annotations: if the user leaves a **question**, immediately rewrite the relevant section to answer it and re-open in Plannotator — don't discuss in the terminal unless the annotation explicitly says "discuss w/ me before rewriting the plan"
4. Re-open in Plannotator for verification
5. Loop until the user approves (submits with no annotations)
6. Only then proceed to the next step (commit, implementation planning, etc.)

**Why Plannotator:** It provides inline annotation — the user can leave targeted comments directly on sections, which is faster and more precise than reviewing a raw markdown file in the terminal.

**This applies to (when not using `/airon-develop`):**
- Brainstorming spec documents (`docs/superpowers/specs/`)
- SPEC files in `.specs`-enabled projects (`specs/`)
- Any design document that needs user approval before proceeding
