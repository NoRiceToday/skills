---
name: gh-issue-context
description: "Fetch the GitHub issue(s) linked to a PR or branch and return a normalized intent-context structure. Silent fallback on missing issue or unavailable tooling. Invoked by adversarial-review during pre-read."
---

# GitHub Issue Context

Resolve the GitHub issue(s) linked to a PR or branch and return their content as a normalized intent-context structure for review.

## Input

- A PR id (number) or branch name, plus the repo (`owner/repo` or inferred from git remote).

## Resolution

Use the installed `*-forge-access` skill for the `origin` host's forge.
If more than one matches, prefer the CLI-based one over the `*-mcp-forge-access` one.

1. **From a PR id**: run the `view` operation. Take linked issue numbers from
   `closingIssuesReferences`; as a fallback, scan the PR body for
   `Fixes #N` / `Closes #N` / `Resolves #N`. Mark these `closes`.
   Then scan the PR body for any other `#N` reference (e.g. `Refs #N`,
   `Part of #N`) and mark it `references`.
2. **From a branch name**: extract an issue number if the branch name contains a `#N`-style token OR a leading/hyphen/slash-delimited number (e.g. `feature/123-desc`, `fix-123`, `issue-123`, `123-describe-thing`). Pattern: `(?:^|[-/])(\d+)(?:[-/]|\b)`. If no number is found, skip silently unless the user explicitly provided an issue number.
3. **Fetch each issue**: run the `view-issue` operation. Extract title, body, and any task-list items (which serve as acceptance criteria).

## Output

Return a single JSON-ish markdown block:

```text
intent-context:
  ticket-id: GH-<N>  (or list if multiple)
  relation: closes | references
  title: <issue title>
  description: <issue body, truncated to ~2k chars>
  acceptance-criteria: <extracted task-list items, or "not specified">
                       (for `references`: context only — unmet items are not PR gaps)
  linked-sub-tickets: <list of sub-issue IDs if epic, else empty>
  source-url: https://github.com/owner/repo/issues/<N>
```

Or, on any failure (no linked issue, unparseable input, no GitHub forge-access skill installed, an operation fails, issue not found):

```text
intent-context: not-available
reason: <one-line reason>
```

Never error. Silent fallback — the orchestrator proceeds with commits-only intent.

## Tool availability

Probe once at start: if no `*-forge-access` skill for GitHub is installed,
return `not-available` with reason `no GitHub forge access`. If an operation
fails, return `not-available` with the first line of its error as reason.
