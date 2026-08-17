---
name: performance-review
description: "Review lens for performance issues, bottlenecks, and resource efficiency. Use standalone on local changes, or as a lens used by adversarial-review."
metadata:
  adversarial-lens: true
---

# Performance Review

Use this as a review lens for local diffs or merge requests.

## Lens mode vs standalone mode

**Lens mode** (invoked by `adversarial-review`): a review package path is provided in the dispatch prompt. Read it; do NOT run your own `git diff` or derive your own diff range. Normalize all findings to the orchestrator's P0-P3 + bucket taxonomy (buckets: `bug`, `maintainability`, `missing-test`, `docs-drift`, `decision-violation`, `decision-conflict`, `speculative`). Do not emit the standalone severity scale below.

**Standalone mode** (invoked directly): use `git diff origin/HEAD...` and the standalone severity scale below.

The rest of this skill applies to both modes.

## Scope

Focus on measurable performance impact and practical optimization opportunities.

## Checklist

### Algorithmic complexity

- O(n^2) or worse paths that can be improved.
- Repeated work and redundant computation.
- Inefficient nested loops.
- Blocking work that could be async or deferred.

### Network and query efficiency

- N+1 queries and missing index awareness.
- Missing batching opportunities.
- Missing pagination/filtering/projection.
- Caching, memoization, or dedup opportunities.
- Connection pooling and resource reuse.
- Retry behavior that can cause storms.

### Memory and resource management

- Leaks from unclosed listeners, handles, or connections.
- Large allocations inside loops.
- Missing cleanup paths.
- Suboptimal data structure choices for memory usage.

### Infrastructure and config performance

- Resource requests/limits are reasonable.
- Avoid unnecessary duplication across environments.
- Config complexity can be simplified with shared patterns.

## Standalone severity scale (standalone mode only)

- `Critical` — critical bottleneck with measurable impact (maps to orchestrator `P0`).
- `Should-fix` — clear optimization opportunity (maps to `P1`).
- `Minor` — preventive best practice (maps to `P2`).
- `Question` — needs profiling or author context (maps to `P3` / `speculative`).

## Output format

For each finding include:

- File and line reference
- Severity (standalone scale, or P0-P3 + bucket when orchestrated)
- Estimated impact (latency, throughput, memory, cost, or complexity)
- Recommended change
- Impact-vs-effort priority
