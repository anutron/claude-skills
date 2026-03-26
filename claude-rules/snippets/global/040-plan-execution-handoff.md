## Plan Execution Handoff

After a plan is approved via `ExitPlanMode`, always:

1. If the project uses spec-driven development (has a `.specs` file), archive the plan to `specs/plans/` with a descriptive filename
2. Show the execute command: `/execute-plan <plan-path>`
3. Use `AskUserQuestion` to ask how the user wants to proceed, with these two options:
   - **Execute in this session** — Run `/execute-plan` right here without clearing context (good for small plans or when current context is valuable)
   - **Copy to clipboard** (recommended) — Copy the `/execute-plan` command to clipboard (`echo -n "/execute-plan <plan-path>" | pbcopy`) and tell the user to run `/clear` and paste. Claude cannot execute `/clear` itself — it is a CLI command only the user can invoke.
