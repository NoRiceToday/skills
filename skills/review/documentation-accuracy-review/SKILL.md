---
name: documentation-accuracy-review
description: "Review lens for documentation accuracy, completeness, and consistency with implementation. Use standalone on local changes, or as a lens used by adversarial-review."
metadata:
  adversarial-lens: true
---

# Documentation Accuracy Review

Use this as a review lens for local diffs or merge requests.

## Lens mode vs standalone mode

**Lens mode** (invoked by `adversarial-review`): a review package path is provided in the dispatch prompt. Read it; do NOT run your own `git diff` or derive your own diff range. Normalize all findings to the orchestrator's P0-P3 + bucket taxonomy (buckets: `bug`, `maintainability`, `missing-test`, `docs-drift`, `decision-violation`, `decision-conflict`, `speculative`). Do not emit the standalone severity scale below.

**Standalone mode** (invoked directly): use `git diff origin/HEAD...` and the standalone severity scale below.

The rest of this skill applies to both modes.

## Scope

Check that docs, comments, and examples reflect real implementation behavior.

## Checklist

### Code documentation

- Public functions/methods/classes are documented where expected.
- Parameter and return descriptions match implementation.
- Examples match current API behavior.
- Edge cases and errors are documented when relevant.
- Stale comments are removed.

### README and project docs

- Feature descriptions match implemented behavior.
- Installation and usage instructions are current.
- Config options and defaults match code.
- New or changed features are documented.

### API and resource docs

- Endpoint/resource behavior matches implementation.
- Request/response examples are accurate.
- Auth requirements are correctly described.
- Parameter constraints/defaults are correct.
- Deprecated behavior is clearly marked.

### Consistency

- Terminology is consistent.
- Version references are current.
- Links and cross-references are valid.
- Config comments match actual behavior.

## Standalone severity scale (standalone mode only)

- `Critical` — documentation contradicts implementation (maps to orchestrator `P0`).
- `Should-fix` — missing docs for changed/new behavior (maps to `P1`).
- `Minor` — minor wording/style fixes (maps to `P2`).
- `Question` — unclear whether docs or code are intended (maps to `P3` / `speculative`).

## Output format

1. Short summary of overall documentation quality.
2. Findings grouped by type.
3. For each finding: location, issue, and proposed fix.
4. Prioritize by severity.
