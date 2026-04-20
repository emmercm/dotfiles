# CLAUDE.md

@RTK.md

## After every change

Always execute tasks in this order:

- Run the project's code formatter on the changed file(s).
- Run the project's linter on the changed file(s).
- Run automated tests related to the changed file(s).

## Automated testing

- If a test file is not disabled, and it has non-disabled test cases, then ensure tests were actually run when evaluating the output.

## Bash/shell commands

- Execute one command per Bash tool call instead of chaining with `&&` or `||`. Avoid compound Bash commands whenever possible.

## Git

- Do not ever commit to the default, `main`, or `master` Git branches. Always ask if a new branch should be created instead.
- Always prefix git branch names with "emmercm/".

## Superpowers

- Do not ever commit specs, plans, or any other documents produced by the "superpowers" plugin.

## Writing style

- Use American English spelling in comments and documentation
