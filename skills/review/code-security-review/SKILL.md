---
name: code-security-review
description: "Perform a focused security review of current branch changes and report actionable vulnerabilities across the unified severity scale."
metadata:
  adversarial-lens: true
---

# Code Security Review

Use this skill for a standalone security audit of local branch changes, or as a lens used by `adversarial-review`.

## Goal

Identify exploitable vulnerabilities introduced by current changes. Report findings across the full severity scale so reviewers see both blocking issues and lower-priority hardening notes, while still avoiding speculative findings outside the defined scope.

## Lens mode vs standalone mode

**Lens mode** (invoked by `adversarial-review`): a review package path is provided in the dispatch prompt. Read it; do NOT run your own `git diff` or derive your own diff range. Normalize all findings to the orchestrator's P0-P3 + bucket taxonomy (buckets: `bug`, `maintainability`, `missing-test`, `docs-drift`, `decision-violation`, `decision-conflict`, `speculative`). Do not emit the standalone severity scale below.

**Standalone mode** (invoked directly): analyze the current branch against `origin/HEAD` using the commands below.

## Data to review (standalone mode only)

Analyze the current branch against `origin/HEAD`:

- `git status`
- changed files (`git diff --name-only origin/HEAD...`)
- commits (`git log --no-decorate origin/HEAD...`)
- full diff (`git diff --merge-base origin/HEAD`)

## Analysis process

1. Understand repository security context and established secure patterns.
2. Compare new changes to existing patterns.
3. Trace input-to-sensitive-sink paths in modified code.
4. Validate exploitability before reporting.

## Priority vulnerability categories

- Injection: SQL/NoSQL/command/template/XXE/path traversal
- Auth and authorization bypass or escalation
- Unsafe crypto or key handling
- Unsafe deserialization / code execution
- Sensitive data exposure (including secrets or PII in logs)

## Exclusions

Do not report:

- DoS/resource exhaustion/rate limiting concerns
- Theoretical hardening gaps without concrete exploit path
- Dependency-age findings only
- Test-only file issues
- Log spoofing
- SSRF where only path is controlled
- Regex injection/ReDoS
- Documentation-only issues
- Client-only missing auth checks

## Standalone severity scale (standalone mode only)

- `Critical` — exploitable vulnerability with concrete path that blocks merge (maps to orchestrator `P0`).
- `Should-fix` — clear security bug or pattern deviation that should be fixed before merge (maps to `P1`).
- `Minor` — minor hardening improvement or preventive best practice (maps to `P2`).
- `Question` — exploitability unclear, author input needed (maps to `P3` / `speculative`).

## Required output

Return markdown findings only. For each finding include:

- File and line
- Severity (standalone scale, or P0-P3 + bucket when orchestrated)
- Category
- Description
- Exploit scenario
- Fix recommendation
