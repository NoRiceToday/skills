---
name: test-coverage-review
description: "Review lens for test coverage, edge cases, and regression risk. Use standalone on local changes, or as a lens used by adversarial-review. Always-on lens when code paths are added or changed."
metadata:
  adversarial-lens: true
---

# Test Coverage Review

Use this as a review lens for local diffs, MRs, PRs, or branches when code paths are added or changed.

## Lens mode vs standalone mode

**Lens mode** (invoked by `adversarial-review`): a review package path is provided in the dispatch prompt as `REVIEW_PACKAGE_PATH` (or described as "the review package"). Read it; do NOT run your own `git diff` or derive your own diff range. Normalize all findings to the orchestrator's P0-P3 + bucket taxonomy (bucket `missing-test` for this lens). Do not emit the standalone severity scale below.

**Standalone mode** (invoked directly): analyze the current branch against `origin/HEAD` using `git diff --name-only origin/HEAD...` and `git diff origin/HEAD...`. Use the standalone severity scale below.

The rest of this skill applies to both modes.

## Scope

Focus on whether the change's new and modified code paths are actually tested, and whether the tests verify real behavior.

## Checklist

### New code paths

- Are new functions/methods/branches exercised by at least one test?
- Are error paths and failure modes covered, not just the happy path?
- Are edge cases (empty input, boundary values, null/None, very large input) covered?
- Are concurrency/race-prone paths tested if applicable?

### Behavior vs mocks

- Do tests verify real behavior, not mocks of internal logic?
- Are mocks limited to external boundaries (HTTP, DB, filesystem, time)?
- Are assertions specific (check the actual result) or tautological (assert `True`)?

### Regression risk

- Does the change modify shared code (utilities, base classes, contracts) without tests covering existing call sites?
- Are removed tests justified (the behavior they checked is gone), or are they silently dropped?
- Does the change introduce new public API without integration tests?

### Test quality

- Are test names descriptive of the behavior they verify?
- Do tests arrange-act-assert clearly?
- Is test output pristine (no warnings, no noise)?

## Exclusions

Do not report:
- Coverage percentages as a number (we don't measure; we reason).
- Stylistic test improvements with no correctness/maintainability impact.
- Missing tests for trivial getters/setters or pure pass-throughs.

## Standalone severity scale (standalone mode only)

- `Critical` — untested code path that will break in production (maps to orchestrator `P0`).
- `Should-fix` — untested new public API or untested shared-code change (maps to `P1`).
- `Minor` — edge case not covered, regression risk moderate (maps to `P2`).
- `FYI` — minor test quality issue (maps to `P3`).

## Output (lens mode)

Return findings in the orchestrator's format. Use bucket `missing-test`. Priority guidance:

- P0: untested code path that will break in production (error path, known risky input).
- P1: untested new public API or untested shared-code change.
- P2: edge case not covered, regression risk moderate.
- P3: minor test quality issue.

If no issues, emit a single positive finding (`conforms`, P3, `no-coverage-gaps`) noting what was checked.

## Output (standalone mode)

For each finding include: file and line reference, severity (standalone scale), description, and concrete fix recommendation. If no issues, emit a single positive note covering what was checked.
