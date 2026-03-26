## SPEC-Driven Development

**Opt-in per project via `.specs` file.** Projects with a `.specs` file at their root use spec-driven development. Projects without one do not.

**Recommendation:** If the user creates a new application or asks to create/modify code in a project that lacks a `.specs` file, recommend adding one.

**`.specs` file format:**
```
dir: specs
```
One line. The `dir` field says where specs live (defaults to `specs/`). If the file exists, the project uses specs.

**Detection:** `test -f .specs && cat .specs` — zero-cost, no directory snooping.

**The Process (Spec-First, Non-Negotiable):**

1. **Update SPEC first** — Before writing any code. The spec captures what the change IS.
2. **Show SPEC to the user** for approval on new features (MUST WAIT for approval)
3. **Write tests** from the spec (when testable)
4. **Implement** — Write code to pass the tests
5. **Show results** and commit (spec + tests + code together)

**NEVER derive specs from code.** If you wrote code first and specs second, the spec is documentation, not a contract. The order matters: spec → test → implement.

**On every behavioral change the user requests: update the SPEC on the same turn.**
- The SPEC is the source of truth — if SPEC and code drift, the code needs updating
- Don't batch SPEC updates for later; capture each requirement as it arrives

**Spec reporting:** After committing, always report spec status:
- `Specs: Updated (specs/foo.md)` — spec changes included
- `Specs: No behavioral changes` — config/docs/cosmetic only
- `Specs: Skipped (no .specs file)` — project doesn't use specs
- `Specs: Missing` — behavioral changes without spec updates

**SPEC Format (Markdown):**

```markdown
# SPEC: Feature Name

## Purpose
Why this exists, what problem it solves

## Interface
- **Inputs**: What goes in
- **Outputs**: What comes out
- **Dependencies**: What it needs

## Behavior
Step-by-step: given X, system does Y, resulting in Z

## Test Cases
- Happy path
- Error cases
- Edge cases

## Examples
Concrete usage examples with real data
```

**Key Principles:**
- SPEC is source of truth - if it's not in the SPEC, it doesn't exist
- Tests validate SPEC compliance
- SPEC evolves with the code - always keep it updated
- Can rebuild from scratch using just the SPEC
