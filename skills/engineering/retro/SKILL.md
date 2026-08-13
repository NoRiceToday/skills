---
name: retro
description: Use when the user invokes /retro at the end of a session to reflect on what was done and capture learnings in the right place.
---

# Retrospective

Short, structured retrospective on the completed session. Claude drafts it — you confirm before anything is written.

## Process

1. **Analyze** the conversation history, draft all sections as bullets
2. **Present** the full draft with proposed actions (format below)
3. **Wait for approval** — user confirms, cuts, or edits
4. **Execute** approved actions, following the routing steps below

## Output Format (bullets only)

```
Summary:
- [what was done, 1-2 bullets]

Went well:
- [patterns/decisions that saved time or prevented rework]

Didn't go well:
- [wrong assumptions, friction, rework triggers]

Learnings:
- [learning] → [proposed target]
- [learning] → [proposed target]

→ Shall I proceed with these?
```

## Routing Each Learning

### Step 1 — Scope
Where does this apply?
- Everywhere → **global**
- This project → **project**
- This module/directory → **module**
- State the chosen scope explicitly before moving on

### Step 2 — Conflict check (before deciding target)
Read the candidate target file(s) at that scope — never claim "nothing found" without reading:
- Found outdated or conflicting content → propose to **UPDATE** or **REMOVE** it — target already decided
- Found nothing relevant → proceed to Step 3

### Step 3 — Type (only if Step 2 found nothing)

| Type | Target |
|---|---|
| Rule Claude should consistently follow | `CLAUDE.md` at that scope |
| Situational / contextual guidance | `feedback memory` |
| Reusable technique or process | `skill` at that scope |
| Architectural decision / "why we chose X" | `docs` or `project memory` |
| Factual project state / ongoing context | `project memory` |

## Hard Rules

- **Never write to any file without showing the full draft and getting explicit approval first.**
- Always do the conflict check (Step 2) before creating anything new.
- Keep the output minimal — bullets only, no prose.
