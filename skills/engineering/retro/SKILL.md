---
name: retro
description: Use when the user asks for a retrospective on the current session — typically at the end of it — to reflect on what was done and capture the learnings in the right place.
---

# Retrospective

Draft a short, structured retrospective on the session, then route each learning
to a durable target. Nothing is written until the user approves the draft.

## Process

1. **Analyze** the conversation history and draft every section as bullets.
2. **Present** the full draft with the proposed target per learning (format below).
3. **Wait for approval** — the user confirms, cuts, or edits.
4. **Execute** only the approved actions, following the routing steps.

## Output format (bullets only)

```text
Summary:
- [what was done, 1-2 bullets]

Went well:
- [patterns or decisions that saved time or prevented rework]

Didn't go well:
- [wrong assumptions, friction, rework triggers]

Learnings:
- [learning] → [proposed target]

→ Shall I proceed with these?
```

## Routing each learning

### Step 1 — Scope

Decide where the learning applies and state the scope explicitly:

- Everywhere → **user scope**
- This repository → **project scope**
- One module or directory → **module scope**

### Step 2 — Conflict check

Read the candidate target files at that scope before deciding anything. Never
claim "nothing found" without having read them.

- Outdated or conflicting content found → propose to **update** or **remove** it;
  the target is already decided, skip Step 3.
- Nothing relevant found → continue to Step 3.

### Step 3 — Type

| Type | Target |
| --- | --- |
| Rule the agent should consistently follow | instruction file (`CLAUDE.md` / `AGENTS.md`) at that scope |
| Situational or contextual guidance | agent memory |
| Reusable technique or process | skill at that scope |
| Architectural decision, "why we chose X" | ADR or other repo documentation |
| Factual project state or ongoing context | agent memory |
| A correction the agent kept repeating | route to a `correct`-style skill if that repo has one (not bundled with this one) — name it, do not run it from here |
| Stale or contradictory agent memory | route to `/memory-cleanup` |

A `correct` candidate is a mistake that happened twice, not a one-off. When a learning qualifies, the whole target is that repo's correction skill: it reruns the same class across the repo and fixes it at the highest level that holds. Writing the rule into `AGENTS.md` instead is the failure this row exists to prevent.

## Hard rules

- Never write to a file without showing the full draft and getting explicit approval.
- This skill is user-invoked. Do not volunteer a retrospective unless the
  session context explicitly enables proactive offers — and then only offer.
- Always run the Step 2 conflict check before creating anything new.
- Keep the output minimal — bullets, no prose.
- Retro is read-only on the repo. When a learning routes to a correction skill, name it
  and stop; never start it from here, because it writes commits.
