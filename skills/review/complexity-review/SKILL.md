---
name: complexity-review
description: "Review code changes for avoidable complexity: unnecessary abstractions, speculative features, duplicated solutions, and changes larger than the problem requires. Use standalone, or as an additional lens alongside adversarial-review, or when explicitly asked to review complexity, KISS, or YAGNI."
metadata:
  adversarial-lens: true
---

# Complexity Review

Find a simpler implementation that meets the same requirements before reporting avoidable complexity.

## Diff source

When invoked by `adversarial-review`, read the supplied review package and intent context. Use the package as the diff source; do not run a separate `git diff`. Return findings in its structured P0–P3 format, using the `maintainability` bucket, and write the requested raw findings file first.

When invoked directly, establish the requested diff scope with the caller's base or local changes, then use the same review criteria.

## Review

1. Establish the change's purpose and trace affected callers, behavior, and existing conventions before judging its size. A shared root-cause fix can be larger than a local patch and still be the simpler solution.
2. Look for an existing helper or pattern, standard-library or native feature, or already-used framework/dependency that fulfills the requirement. Prefer the framework's established abstraction over a hand-rolled replacement.
3. Check whether new layers, one-use abstractions, configuration, dependencies, or scaffolding solve a current requirement. Check for scope creep: added features, workflows, or unrelated refactors beyond the stated intent. Identify the specific extra changes that could be dropped while still meeting the requirement.
4. Compare conceptual complexity, not line count. Prefer straightforward code over terse but harder-to-understand tricks when you can show a simpler equivalent.
5. Report only when you can point to the changed lines and show a concrete simpler alternative that preserves requested behavior, relevant edge cases, tests, security, trust-boundary validation, accessibility, and data-loss protections. Describe what code or maintenance burden that alternative removes. If equivalence or intent is uncertain, investigate before asserting a finding; omit it if the evidence remains insufficient.

Diff size is a routing signal, never a finding by itself. Fewer lines in the wrong place are not a simplification. Leave measurable runtime costs to `performance-review`, test effectiveness and test scaffolding to `test-coverage-review`, unrelated readability issues to `code-quality-review`, and recorded policy violations to `decision-conformity-review`. The orchestrator deduplicates findings with the same root cause.

## Findings

Use the orchestrator's location, confidence, priority, and raw-file anchor fields. In `Problem`, cite the redundant changed code and the evidence for a simpler existing or direct solution. In `Fix`, name the minimal equivalent change and the burden it removes. If no supported simplification exists, return no findings.
