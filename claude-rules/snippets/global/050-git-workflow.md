## Git Workflow

**Every turn (chunk of completed work) gets committed.**

**Process:**
1. Complete a logical unit of work
2. Run tests (if applicable)
3. Create git commit
4. Commit message: `<imperative that generated the work>`

**Examples:**
- `"Add Fitbit sync to memory MCP server"`
- `"Implement query translation for swimming progress"`
- `"Create interaction logging table in Supabase"`

**Repository Structure:**
- Commit frequently, push when ready
- Tag releases: `v1.0.0`, `v1.1.0`, etc.

**SPEC Pre-Commit Hook:**
All spec-driven repos have a pre-commit hook that blocks commits when behavioral code changes (*.go, *.ts, *.py, *.js, *.sh, *.rb) don't include a `specs/*.md` update. Bypass with `--no-verify` when appropriate.

When creating a new repo, install the hook:
```bash
ln -sf <path-to-spec-check-hook.sh> .git/hooks/pre-commit
```
