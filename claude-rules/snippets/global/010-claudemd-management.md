## CLAUDE.md Management

Both `~/.claude/CLAUDE.md` (global) and `{{PROJECT_DIR}}/CLAUDE.md` (project) are **compiled from snippets** — never edit the CLAUDE.md files directly.

**Source of truth:** `{{CLAUDE_RULES_DIR}}/snippets/`
- `snippets/global/*.md` → compiled into `~/.claude/CLAUDE.md`
- `snippets/project/*.md` → compiled into `{{PROJECT_DIR}}/CLAUDE.md`

**Workflow:**
1. Edit or create a snippet in the appropriate `snippets/{global,project}/` directory
2. Run `{{CLAUDE_RULES_DIR}}/compile.sh` to regenerate the dist files
3. The CLAUDE.md files are symlinks to the compiled output — changes appear immediately

**Commands:**
- `compile.sh compile` — Rebuild both CLAUDE.md files from snippets
- `compile.sh promote <name>.md` — Move a snippet from project to global scope
- `compile.sh demote <name>.md` — Move a snippet from global to project scope
- `compile.sh list` — Show all snippets and their scope
- `compile.sh status` — Check if dist files were modified outside the snippet system

**Naming convention:** Snippets are numbered for ordering (e.g., `010-plan-formatting.md`, `040-tech-stack.md`). Use gaps to allow inserting new snippets without renumbering.

**Template Variables:**
Snippets can use `{{VARIABLE}}` placeholders that compile.sh resolves during compilation.

Built-in variables:
- `{{CLAUDE_RULES_DIR}}` — absolute path to the claude-rules directory
- `{{PROJECT_DIR}}` — absolute path to the project root (parent of claude-rules/)
- `{{GLOBAL_TARGET}}` — `~/.claude/CLAUDE.md`

Custom variables: define in `{{CLAUDE_RULES_DIR}}/variables.env`, one per line (`KEY=value`). Values can reference other variables.

When editing or creating snippets, **always use template variables for paths** — never hardcode absolute paths. This keeps snippets portable and publishable.
