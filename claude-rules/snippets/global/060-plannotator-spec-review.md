## Spec Review via Plannotator

When specs are written outside an automated brainstorming flow (e.g., standalone spec edits, manual brainstorming, or spec files written outside a development skill), use Plannotator for spec review:

1. Write the spec file (do NOT commit yet)
2. Invoke `/plannotator-specs` — this opens Plannotator in the browser for inline annotation
3. Address any annotations the user leaves
4. Re-open in Plannotator for verification
5. Loop until the user approves (submits with no annotations)
6. Only then proceed to the next step (commit, implementation planning, etc.)

**Why Plannotator:** It provides inline annotation — the user can leave targeted comments directly on sections, which is faster and more precise than reviewing a raw markdown file in the terminal.

**This applies to:**
- Brainstorming spec documents
- SPEC files in `.specs`-enabled projects (`specs/`)
- Any design document that needs user approval before proceeding
