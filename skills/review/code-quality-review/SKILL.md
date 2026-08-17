---
name: code-quality-review
description: "Intent-first review lens for code quality, maintainability, and adherence to best practices. Infers author intent, drills down from changed entry-points into downstream files, and reports per-file and per-function findings. Use standalone on local changes, or as a lens used by adversarial-review."
metadata:
  adversarial-lens: true
---

# Code Quality Review

Use this as a review lens for local diffs or merge requests when the user wants more than isolated findings.

## Lens mode vs standalone mode

**Lens mode** (invoked by `adversarial-review`): a review package path is provided in the dispatch prompt. Read it; do NOT run your own `git diff` or derive your own diff range. Normalize all findings to the orchestrator's P0-P3 + bucket taxonomy (buckets: `bug`, `maintainability`, `missing-test`, `docs-drift`, `decision-violation`, `decision-conflict`, `speculative`). Do not emit the standalone severity scale below.

**Standalone mode** (invoked directly): use `git diff origin/HEAD...` and the standalone severity scale below.

The rest of this skill applies to both modes.

## Scope

Focus on code quality, maintainability, conventions, implementation completeness, and whether the chosen approach serves the likely purpose of the change.

## Review Workflow

### Step 1: Understand the change before judging it

- Review the full change set before hunting for issues.
- Infer the author's likely intent from the diff, surrounding code, tests, documentation, names, and any available task context.
- Summarize what was changed and what problem the author appears to be solving.
- Evaluate whether the implementation matches that intent.
- Discuss whether the chosen approach fits the purpose, and mention alternative approaches only when they materially improve correctness, maintainability, simplicity, or alignment with existing patterns.
- Give constructive feedback on the approach even when there are no concrete bugs.

### Step 2: Build a drill-down map of the change

- Identify changed entry-point files first.
- Treat entry-points broadly: routes, handlers, controllers, pages, commands, jobs, public APIs, top-level services, and configuration files that wire behavior.
- Order the walkthrough from the most outward-facing changed file toward the files it calls, configures, or depends on.
- If multiple entry-points exist, group the walkthrough by entry-point and drill down separately.
- If no clear entry-point exists, start with the file that best explains the user-visible or system-level behavior, then continue into supporting files.

### Step 3: Review each changed file in drill-down order

For every changed file, report all of the following:

- What changed: high-level summary of the edits in that file.
- Why it changed: the apparent purpose of the file-level changes.
- Changes per function: list the affected functions, methods, classes, hooks, or top-level blocks and explain what changed in each.
- Issues found in the file: enumerate problems, risks, regressions, or noteworthy omissions. State explicitly when no issues are found.

### Step 4: Apply the quality lens while reviewing

Use the checklist below while writing the intent analysis, the per-file breakdown, and the final findings.

## Checklist

### Naming and readability

- Naming is clear and descriptive.
- Functions and methods are focused and not overloaded.
- Duplicated logic is minimized.
- Complex logic is simplified or justified with concise comments.
- Style and formatting follow repo conventions.
- Magic values are extracted into named constants where appropriate.

### Structure and separation of concerns

- Configuration, logic, and data concerns are separated.
- File organization follows existing repo patterns.
- Unrelated resources are not mixed in one file.
- Directory structure matches established conventions.

### Error handling and edge cases

- Failure paths are handled.
- Input validation exists where expected.
- Null/undefined/empty values are addressed.
- Boundary conditions and empty collections are considered.

### Completeness and consistency

- Comparable resources include similar required fields.
- Naming is consistent with existing suffixes/prefixes.
- Shared configs avoid environment-specific hardcoding.
- Placeholder values are used where overrides are expected.

### Comments and documentation quality

- Comments explain why, not what.
- Outdated comments are removed.
- Typos and grammar issues are flagged.

## Standalone severity scale (standalone mode only)

- `Critical` — breaks functionality or conventions (maps to orchestrator `P0`).
- `Should-fix` — pattern deviation, naming, missing fields (maps to `P1`).
- `Minor` — improvement or style nit (maps to `P2`).
- `Question` — intent unclear, needs clarification (maps to `P3` / `speculative`).

## Output format

Structure the review in this order:

### 1. Intent and approach analysis

- Describe the likely intent of the change set.
- Explain whether the implementation fits that intent.
- Provide constructive feedback on the chosen approach.
- Mention meaningful alternatives when they matter.

### 2. File-by-file drill-down

- Start with changed entry-point files.
- Continue into changed downstream files in the order they are reached from the entry-point.
- For each file, include:
  - What changed
  - Why it changed
  - Changes per function
  - Issues found in the file

### 3. Findings

For each finding include:

- File and line reference
- Severity (standalone scale, or P0-P3 + bucket when orchestrated)
- Description
- Concrete fix recommendation
- Optional reference to an existing good example in the repo
