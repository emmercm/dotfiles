# CLAUDE.md

@RTK.md

## After every change

Always execute tasks in this order:

- Run the project's code formatter on the changed file(s)
- Run the project's linter on the changed file(s)
- Run automated tests related to the changed file(s)

## Automated testing

- If a test file is not disabled, and it has non-disabled test cases, then ensure tests were actually run when evaluating the output

## Bash/shell commands

- Execute one command per Bash tool call instead of chaining with `&&` or `||`. Avoid compound Bash commands whenever possible

## Git

- Retry all git operations that fail because the lock file exists; do not ever delete the lock file
- Always run `git reset` before `git add`; do not ever commit unintended files
- Do not commit to the default, `main`, or `master` Git branches. Always ask if a new branch should be created instead
- Do not attempt to amend commits that are already pushed
- Always prefix git branch names with "emmercm/"
- Always update/pull the base branch before creating a new branch; do not create a branch off of a stale default branch

## Pull requests

- Always use the `writing-pull-requests` skill when creating pull requests

## Superpowers

- Do not ever commit specs, plans, or any other documents produced by the "superpowers" plugin
- Always create Git branches off of the default branch, never create them off of the current branch

## Writing style

- Use American English spelling in names, comments, and documentation
