---
name: decision-conformity-review
description: "Review lens that checks the diff against recorded decisions (ADRs, BDRs, distilled indexes, AGENTS.md, agent memory, plan/spec docs) and surfaces violations and cross-source conflicts. Always-on lens when decision sources exist."
metadata:
  adversarial-lens: true
---

# Decision Conformity Review

Use this as a review lens to check whether the diff conforms to, drifts from, or contradicts prior recorded decisions. Also surface contradictions between decision sources themselves.

## Lens mode vs standalone mode

**Lens mode** (invoked by `adversarial-review`): a review package path and a list of decision source paths are provided in the dispatch prompt. Read the package; do NOT run your own `git diff`. Normalize findings to the orchestrator's P0-P3 + bucket taxonomy. Use buckets `decision-violation` and `decision-conflict` (see below). Do not emit the standalone severity scale below.

**Standalone mode** (invoked directly): derive the diff from `origin/HEAD` yourself and discover decision sources by Globbing (see Discovery order).

## Decision source discovery order (cheap first)

### 1. Distilled indexes (preferred when present)

Some repos maintain a distilled one-line index per decision-record directory. Glob for common locations:

- `**/decisions/distilled/INDEX.md`
- `**/business-decisions/distilled/INDEX.md`
- `**/adr/distilled/INDEX.md`
- `**/bdr/distilled/INDEX.md`

A typical distilled index has one line per decision, e.g. `- **ADR-NNNN** <title> — <summary>`, with `_(superseded)_` / `_(deprecated)_` markers for non-active records. Distilled per-decision files usually live alongside (same stem as the source record).

Read the index first; it's tiny. Determine relevance to changed files by matching decision subject to changed-file paths or keywords.

If the repo doesn't use distilled indexes, fall through to source records.

### 2. Distilled per-decision files

For each relevant decision from the index, read its distilled file (small). Only fall back to source records if no distilled version exists for a decision you need to inspect in depth.

### 3. Source decision records (fallback)

Glob (only if no distilled version for a needed decision):
- `**/decisions/*.md` (excluding `**/distilled/**`)
- `**/business-decisions/*.md`
- `**/adr/*.md`, `**/adrs/*.md`
- `docs/decisions/**`, `docs/adr/**`

If a repo's distilled index is malformed (doesn't look like a distilled index at all), fall back to source records and note "malformed distilled index — fell back to source records" in your raw output.

### 4. AGENTS.md / CLAUDE.md / project-guide decision sections

Provided by the orchestrator in the dispatch prompt (relevant excerpt, not whole file). In standalone mode, read the repo's `AGENTS.md` / `CLAUDE.md` and extract decision-relevant sections.

### 5. Agent memory (scoped)

Project-scoped (default): `.claude/agent-memory/**/MEMORY.md` in the repo under review (a Claude Code convention). Other agents may store memory elsewhere under the repo — Glob `**/agent-memory/**/MEMORY.md` to catch variants.

User-scoped (opt-in only): read ONLY if the orchestrator's dispatch prompt explicitly says to include user memory. Never read user-scoped memory otherwise; it would inject unrelated personal context from other projects.

### 6. Plan/spec docs

Glob:
- `docs/superpowers/plans/**`
- `docs/specs/**`
- `docs/plans/**`

If the diff claims to implement a plan, check the implementation against the plan.

## Skip condition

If literally no decision sources exist anywhere in the repo (no ADR/BDR/RFC dirs, no AGENTS.md/CLAUDE.md, no agent-memory, no plan/spec docs), emit a single finding (`silent`, P3, `no-decision-sources-found`) noting the lens was skipped. Since AGENTS.md almost always exists, this is rare.

## Conformance check

For each relevant decision, check the diff and classify:

- **conforms** — diff follows the decision.
- **drifts** — partial deviation; flag for review.
- **violates** — diff clearly contradicts an unambiguous decision. Emit a `decision-violation` finding.
- **silent** — decision doesn't apply to this diff.

## Conflict detection

Cross-check decision sources that cover the same scope. A conflict exists when two sources give incompatible guidance for the same concern.

Tag each conflict:
- `conflict-type: memory-vs-adr | memory-vs-memory | adr-vs-adr | memory-vs-agents-md | adr-vs-agents-md | plan-vs-adr`
- `scope: <which decisions/concerns it affects>`
- `staleness-suspected: yes | no` — flag if one source is clearly older (e.g. an ADR marked `status: superseded`/`deprecated`, or a memory timestamp older than a contradicting ADR's commit).

## Consolidation suggestion (when clear)

Emit `suggested-consolidation`:
- Stale ADR → suggest updating or superseding (link to superseding decision if any).
- Stale memory → suggest deleting/correcting (cite path + line).
- Two valid-but-conflicting → suggest which to follow, based on recency, scope specificity, or AGENTS.md precedence (if the repo's AGENTS.md declares a precedence chain, follow it; otherwise prefer recency and scope specificity).
- Ambiguous → "requires maintainer reconciliation: <specific question>".

## Standalone severity scale (standalone mode only)

- `Critical` — violation directly causing incorrect behavior in changed code, or unresolvable conflict affecting changed code's correctness (maps to orchestrator `P0`).
- `Should-fix` — violation of a clear decision, or any conflict (maps to `P1`).
- `Minor` — drift (partial deviation, not clearly wrong) (maps to `P2`).
- `Conforms` — positive finding, no conflict (maps to `P3`).

## Output (lens mode)

Return findings in the orchestrator's format:

- **`decision-violation`** findings: include `decision-source: <path>:<line>` pointing at the decision being violated.
- **`decision-conflict`** findings: include `conflict-sources:` (list of `<path>:<line> — <one-line position>`) and `suggested-consolidation:` field.

Priority:
- P0: violation directly causing incorrect behavior in changed code; or unresolvable conflict directly affecting changed code's correctness.
- P1: violation of a clear decision; or any conflict (shipping code with disagreeing decision sources means the next reviewer hits the same ambiguity).
- P2: drift (partial deviation, not clearly wrong).
- P3: conforms / no-conflicts-detected positive finding.

### No-conflict positive finding

If no conflicts found, emit a single positive finding (`conforms`, P3, `no-conflicts-detected`) noting which sources were cross-checked. Makes the lens's coverage auditable.
