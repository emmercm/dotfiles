---
name: writing-pull-requests
description: Use when drafting a pull request title or description, opening a PR with `gh pr create`, or filling out PR body content
---

# Writing Pull Requests

## Overview

A pull request's title and description must convey the *intent* of a change, the *risks* on both sides of merging it, how to *undo* it, and what to *watch* after deploy. Do not include mechanical "what changed" details — they belong to the diff.

## Length Scales With Complexity

Match length to the change. A null-pointer fix does not need two paragraphs; a one-line risk does not need four sentences. Reviewers skip walls of text — state the fact, name the mitigation, move on. Default to the **shortest form that satisfies each tenet**, then expand only when complexity demands it.

If you find yourself writing a second paragraph, ask whether the second paragraph carries information the reviewer cannot get from the diff or the linked ticket. If not, cut it.

## Order of Precedence

1. The repository's `PULL_REQUEST_TEMPLATE`
2. Project `CLAUDE.md` / `AGENTS.md` PR conventions
3. This skill

## Template Handling (Hard Rules)

When a PR template exists:

- **Do not add sections** that aren't in the template.
- **Do not remove sections** that are in the template.
- **Do not leave any section blank.**
- **Do not write `N/A`** — neither alone nor with a reason. Write a definitive sentence stating what *is* true. Example: write "No new risks; this is a test-only change with no production code paths touched", not "N/A — test only".
- **Do not alter section headings.** Preserve them verbatim, including punctuation and parenthetical hints.

## Title

- Lead with the affected module/service in lowercase, then a colon: `my-service: migrate v1 endpoint to v2`.
- Use a verb first after the colon: "add", "remove", "migrate", "wire", "fix". Do not write "PR for X" or "changes to X".
- Append the JIRA key in brackets at the end when known: `[ENG-1234]`.
- Keep under ~80 characters.

## The Four Content Tenets

These map onto the typical template sections (Description, Risks, Rollback, Observability). Apply each tenet to the section that fits, even when the template uses different headings.

### 1. Description — intent, not mechanics

Convey the *spirit* and *intention* of the change. The description must answer the question the diff cannot: **why does this PR exist, and what outcome is it producing?**

Required elements:
- **The problem or motivation.** Open with what was broken, missing, deprecated, unsafe, or now needed. State *why* this PR exists before stating *what* it touches.
- **The intent of the change.** State the outcome it produces and the invariant it establishes or restores. Frame this at the level of *system behavior*, not class-by-class deltas.
- **Code explicitly left alone.** Call out any adjacent code a reviewer might reasonably expect to change but didn't, and state why. Examples: a fallback path kept for a flag-transition race, a deprecated method left behind for one remaining caller, an async path that has no replacement yet. Omitting this wastes reviewer time on "why didn't you also change X?" questions.

**Length discipline:** A single-bug fix is **1-3 sentences**: name the failure mode and the fix. Save 3-6 sentences for migrations, new features, or changes touching multiple services. Do not pad a simple fix with paragraphs of context the reviewer can read in the linked ticket. Do not add bullets to this section by default. Do not write a bulleted list of behavioral changes — that list is the diff.

Do not:
- **Enumerate touched classes, methods, or fields.** "`FooActivity` is now gone, `BarActivity` lost a constructor parameter, `BazType` dropped its `async` field" is mechanics dressed up as behavior. Cut it.
- Walk through files or functions one at a time.
- Write "This PR modifies `MyClass.java` and `OtherClass.java`" — the diff shows that.
- Add a "Behavioral changes:" bullet list that re-narrates the diff at the class level. Replace it with one sentence describing the system-level outcome.
- Use marketing voice ("improves robustness", "enhances reliability"). State the concrete behavior change.

**Refactor test:** A description statement must remain true after a behavior-preserving refactor that renames or restructures the touched classes. Cut any statement that fails this test — it is mechanics.

### 2. Risks — both directions

Cover risk on **both sides** of the merge. Do not cover only one side.

- **Risk introduced by the change.** Name the specific failure mode that could occur if this ships (latency regression, schema incompatibility, message-loss window, traffic that was previously no-op'd now actually executing). Name the **mitigation** for each (feature flag, gradual rollout, monitoring, fallback path, idempotency).
- **Risk of *not* making the change.** Name what stays broken, exposed, or degrading when this PR is *not* merged. This is mandatory for security fixes, compliance work, dead-code removal that blocks other work, and migrations where the old path is being deprecated.

Do not leave either side blank. When a side has no risk, write a definitive sentence stating *why* — e.g. "No new failure modes introduced: the new SDK method is purely additive and has no callers yet."

**Length discipline:** **1-2 sentences per side** for simple changes. Do not pad. "Additive change at the input boundary — previously-`null` reference is now a non-`null` empty default. Not merging leaves the RPC unusable for callers that don't set the field." is complete; do not expand it into a paragraph re-explaining the original bug.

### 3. Rollback — revertibility and flag controls

Answer two questions explicitly. Do not skip either.

- **Is the change safely revertible?** State whether `git revert` is sufficient. Call out any roll-forward-only content — DB migrations (especially destructive ones like column drops or data backfills), proto field number reuse, irreversible schema changes, published-event format changes consumers have already deserialized — and describe the actual rollback procedure for those parts.
- **Feature flag controls.** Name the gating flag(s). State explicitly whether disabling the flag reverts behavior without a redeploy. State which part of the change a flag gates when it gates only part.

Keep the answer terse when nothing is complicated (`Revert the PR.` / `Disable the MY_FEATURE_FLAG flag — no redeploy required.`). Do not skip the question.

### 4. Observability — what to watch

For changes with production behavior, cover up to three things — only the ones that apply:

- **Metrics expected to change intentionally.** Name the metric and the expected direction. Example: "Expect `my_service_request_latency_p99` to drop on enabled tenants as the new path bypasses the legacy validator."
- **Metrics expected to stay flat that would signal a problem if they moved.** Cover error rates, throughput, downstream dependency call counts, queue depth, retry counts. Name the dashboards or queries when they exist.
- **New logs, traces, or stats added by this PR.**

Skip categories that don't apply. A bug fix that adds no metrics and changes no expected directions can be **1-2 sentences** naming the signal that would confirm the fix worked (e.g. "The `cdTest` job for `BulkProcessSubscriptionFlow` should return to passing.").

Do not write `N/A`. For changes with no production-runtime impact (proto-only, test-only, doc changes), state that fact directly and name what would signal a problem if the assumption is wrong — e.g. "No runtime behavior changes; CI build and proto-consumer compilation are the relevant signals." There is always *something* to watch.

## Style Rules

**Lead with the problem, then the change.** Start the first sentence with what was broken, missing, or needed. Do not start with what the PR does.

**Wrap every code identifier in backticks** — class names, method names, feature-flag constants, RPC names, file paths, env vars. Do not write plain-text identifiers.

**Strip filler.** Do not write "this PR aims to", "in order to", "we should", "going forward". State facts directly.

**Default to prose. Do not reach for bullets.** Write the description as 3-6 sentences with no bullets. Use a bullet only when it conveys something a reviewer cannot get from the diff (intent, motivation, an explicit non-change). Do not use bullets to itemize per-class changes — that is a worse diff.

**Name what was actually run in Verification.** List test class names, scenarios covered, and commands executed. Use checkboxes (`- [x]`) for build/lint/test steps. Do not write "tests pass" without specifics.
