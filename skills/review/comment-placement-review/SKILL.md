---
name: comment-placement-review
description: "Review whether code comments and README prose are necessary, nonredundant, and placed in the right surface. Use standalone, or as an additional lens alongside adversarial-review, or when explicitly asked to review comments or comment placement."
metadata:
  adversarial-lens: true
---

# Comment Placement Review

Review the lifetime and placement of explanatory text, not just its wording.

## Scope

When invoked by `adversarial-review`, read the supplied review package as the diff source; do not run another `git diff`. Normally report only on changed comments and README paragraphs, while reading surrounding code for context. If the caller explicitly requests a comment review, use the package's file list to inspect each complete touched file at the reviewed revision and report on existing comments and README paragraphs too. If a complete file is unavailable at that revision, limit findings to the package rather than treating a different revision as evidence.

When invoked directly, establish the requested diff scope. Default to changed comments and README paragraphs; inspect all touched files when the caller explicitly requests a comment review.

## Criteria

1. Ask of each candidate sentence: does it say something the code cannot show, and will it still be true after the next change to this file? Keep a concise comment that explains a durable, surprising choice, such as why a non-default value must remain.
2. For a comment that narrates the code or needs several lines to make the code understandable, identify a concrete naming or structure change that makes the code explain itself. Remove redundant or duplicated comments instead of rewriting the same information in multiple places.
3. Put durable usage and operational guidance in the appropriate README or documentation. Put change-specific rationale, ticket references, current wiring, deliberate absences, merge order, dates, and review risks in the MR/PR description, not in a source comment or README. Avoid repeating the same explanation across surfaces.
4. Preserve comments required by tooling, public API contracts, licenses, or other project conventions. Do not demand comment-free code when the reason cannot be expressed clearly in code.

Report only actionable findings tied to a specific changed line (or an existing line in explicit full-file mode). Show the redundant or misplaced text and the concrete code change, deletion, or better destination. Use the orchestrator's P0–P3 structured finding contract and `maintainability` bucket; write the requested raw findings file before returning. Leave factual errors and stale descriptions to `documentation-accuracy-review`, and unrelated code complexity to `complexity-review`.
