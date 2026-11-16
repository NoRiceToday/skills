---
name: create-merge-request
description: Use when creating a merge request or pull request — gathers branch context, builds a why-focused description with motivation, context, and deployment impact, then opens it through the installed forge-access skill.
---

# Create Merge Request

## Overview

Creates a well-structured merge request (GitLab) or pull request (GitHub).
"MR" below means either. The description focuses on **why**, not what —
the diff already shows what changed.

## Workflow

### 1. Gather context

Run in parallel:

- `git log main..HEAD --oneline` — commits since branch diverged
- `git diff main...HEAD --stat` — files changed
- `git diff main...HEAD` — full diff
- Read `AGENTS.md` / `CLAUDE.md` / `LOCAL_SETUP.md` if present for repo-specific title/branch conventions

### 2. Ask the user

In a single message, ask for:

1. **Ticket number** — use `NO-TICKET:` only for explicitly ticketless changes
2. **Context**: "Is there background a reviewer should know — ticket context, ADRs, business decisions, prior agreements?"
3. **Implementation decisions**: "Were there problems, alternatives considered, or constraints that led to this specific approach?"

Do not skip these questions even if the branch and commits seem self-explanatory.

### 2a. Visual aid (if applicable)

If `--stat` shows **7 or more changed files** and the changes are non-trivial (not purely formatting, import reordering, or whitespace): using the full diff plus the user's context and implementation decisions from step 2, weigh what shows the change better to a reviewer — a Mermaid diagram (flows, interactions, structure; any type that fits) or a table (mappings, before/after, option lists) — and produce one. If you cannot check that a diagram renders, use the table. Keep it reviewer-focused.

If fewer than 7 files changed, or all changes are trivial, skip.

### 3. Draft description

Omit sections that have nothing meaningful to say. Do not pad.

For a refactor or publish MR, write for readers who don't know your local history: describe what
changes in the repo, before vs. after.

```markdown
## Motivation

Why this change is necessary. What problem, requirement, or decision drives it.

## Context

Background the reviewer needs that is not in the diff.
Incorporate what the user provided in step 2 here.
Reference ticket, ADR, or business decision if relevant.

## Implementation Decisions

(Include only if the user provided information in step 2.)
Why the implementation was done this specific way:
- Constraints or dead ends that ruled out other approaches
- Alternatives considered and why they were rejected
- Known trade-offs accepted

## Diagram or table

(Include only when step 2a produced one.)
The visual aid chosen to ease review of this specific change.
Wrap a diagram in a mermaid fenced code block.

## Deployment / Impact

- Breaking changes (API contract, event schema, config keys)
- Migration steps if any
- Rollout risk or feature-flag status
- Services or teams affected
```

MR title format: `{TICKET}: {short human-readable summary}` — imperative mood, ≤ 72 chars total.

### 3a. Code comment or MR description — not both

Which sentences may stay in the code is settled by the criteria of skill
`comment-placement-review`. Do not restate them here. Its consequence for this step: the description
carries the cross-cutting rationale a reviewer needs in order to approve or reject — trade-offs,
alternatives rejected, decisions still open, cross-repo dependencies, paging risk. If the diff
contains a comment restating that rationale, ask the user whether to drop it from the code; never
leave it silently.

### 3b. Length sanity gate

Dispatch a subagent (fast model) with the description and instruct it to apply this test to each
sentence: *would removing this change a reviewer's decision to merge, or make it harder for the
reviewer to understand why this change exists?* If neither, cut it. Then re-run the why-only check
(3a) on what survives.

If the description does not fit on one screen without scrolling, that is a signal, not a rule —
re-run the test.

### 4. Present draft to user

Show title + full description. Wait for explicit approval or corrections before creating.
The same gate applies when editing the description of an existing MR/PR.

### 5. Open the merge request

First check whether the source branch already has an open MR/PR; if so, update that one instead
of opening a second.

Use the installed `*-forge-access` skill for the `origin` host's forge.
If more than one matches, prefer the CLI-based one over the `*-mcp-forge-access` one.
Run its `open` operation with the approved title and description, target `main`
unless the user names another, and delete the source branch on merge.
Report the MR/PR URL back to the user.
