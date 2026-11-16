---
name: memory-cleanup
description: Audit and clean one repo's Claude auto-memory — verify every memory against the repo and environment, propose delete/merge/update, apply only what the user approves.
disable-model-invocation: true
---

# Memory cleanup

Bring a repo's auto-memory back to a state where every memory is current and correct, merged, or
deleted: no two memories contradict each other, none describes a state that no longer holds, and
`MEMORY.md` has exactly one line per file.

Roles: you read, plan, cross-check, and talk to the user. Sonnet subagents do the per-file checking
and the edits — pass `model: "sonnet"` on every `Agent` call. Memory files change only after the
user's approval in step 4. `~/.claude/CLAUDE.md` is read-only reference unless the user explicitly
approves an edit to it.

User-facing text (the proposal, the final report) follows the language rule in your user instructions if one exists; otherwise it uses the user's language.

## 1. Inventory

1. Resolve the memory directory of the repo's **main checkout**, not of a worktree:
   `~/.claude/projects/<main-checkout-path with / replaced by ->/memory/`.
2. List every `~/.claude/projects/*/memory/` with its file count. Show the user any directory
   belonging to this repo's worktrees or holding memories about this repo (grep for the repo
   name), and ask whether to adopt or ignore them. Only the main directory is edited.
3. Read `MEMORY.md` and every file's frontmatter (`name`, `description`, `type`, `modified`, size).
4. Reconcile: file without an index line, index line without a file, duplicate `name` slugs,
   files without frontmatter, `name` differing from the file stem, and every `[[link]]` that
   matches no file stem.
5. Note the repo's reference ref and its date (`git log -1 --format='%H %ci' origin/main`). If a
   fetch is impossible, say so and cite the date.
6. Split the files into topical batches of 8–12 so related memories land together. A typical cut:
   sandbox/tooling/build · git/review host/tickets tooling · review feedback · writing feedback ·
   modelling/architecture · ticket and feature state (`project_<ticket>*`) · rest.

Done when every file is in exactly one batch and the reconcile findings are listed.

## 2. Check (Sonnet, parallel, read-only)

Launch one Sonnet agent per batch, all in one message, each with the brief in
[`reviewer-brief.md`](reviewer-brief.md) filled in (paths, reference ref and date, batch list,
batch-specific hints such as "check X against the LSP rule in CLAUDE.md").

Done when every batch has returned its table.

## 3. Cross-check (yourself)

The reviewers each saw one batch. Across all tables:

- **Contradictions between batches** — two files claiming opposite facts (e.g. "X works
  in-sandbox" vs "X is impossible"). Decide by the newer *measurement*, not the newer file.
- **Conflicting proposals** — batch A says "delete X", batch B says "merge Y into X". Resolve to
  one action per file.
- **Stale index lines** — the file was corrected but its `MEMORY.md` line still states the old
  claim. This is the most common drift; check every index line against the file's current header.
- **Cheap re-measurement** — when a claim decides delete-vs-keep and can be measured in seconds
  (one tool call, one config file, one `env` lookup), measure it yourself rather than trusting
  either side.
- **Overturn weak reviewer verdicts**:
  - A user preference or review rule stays even when existing code violates it; code that
    predates or ignores a rule does not falsify the rule.
  - A memory whose rule now lives in `~/.claude/CLAUDE.md`, a repo `AGENTS.md`, or a skill is a
    delete candidate — confirm the rule is really there (`git show origin/main:<path>`).
  - A memory recording falsified hypotheses (probes nobody should repeat) is kept; at most
    tightened.
  - A finished ticket memory is deleted only when nothing reusable remains; otherwise tightened
    to the reusable lesson. Ticket status via the Atlassian MCP or `git log origin/main --grep=<ID>`.
- **Inbound links** of every file proposed for deletion or merge — they are rewritten in step 5.

Done when every file has exactly one proposed action with evidence.

## 4. Proposal (to the user), then wait

Lead with the counts: delete · merge · update · unclear · keep (after-count of files). Then group by
action; per entry: file, one-sentence reason, evidence (`path:line`, git command, or measurement).
For merge and update, state the new core content in one sentence. For unclear, ask the question
and give your recommendation. Keep entries: count only. List the mechanical fixes (slug
normalisation, dead links) as one block. Name any contradiction you found in `CLAUDE.md` itself.

Stop and wait. The user cuts, changes, or approves.

## 5. Apply (after approval)

1. Split the approved content edits across Sonnet agents so no two agents share a file. Each brief:
   only Read/Edit/Write; delete with `trash <path>` if available, otherwise `rm`; touch only the
   listed files; never `MEMORY.md`; keep the format (frontmatter `name`, `description`,
   `metadata.type`; **Why:** and **How to apply:** for feedback/project; links as `[[file_stem]]`);
   the exact change per file with the evidence to record; for merges, which source file to trash.
2. While they run, do the parts that touch many files yourself:
   - `trash` the approved deletions.
   - Any approved `CLAUDE.md` edit (back it up to `/tmp` first, for the diff).
3. After all agents report, run the mechanical pass over every file in one go: `name:` = file
   stem; every `[[link]]` rewritten to a file stem, links to merged-away files pointed at the
   merge target, links to deleted files removed, links that were deliberately open left as they
   are.
4. Write `MEMORY.md` yourself, in one pass: one line per file, `- [Title](file.md) — hook`, the hook
   matching the file's *current* content.

## 6. Verify (yourself)

Run each check and show the result:

- Every `MEMORY.md` line points to an existing file; every file has exactly one line.
- Every `[[slug]]` matches an existing file stem or is a known open link.
- Every file has frontmatter with `name` equal to its stem.
- `wc -c MEMORY.md` is under 17 KB.

Then report: before/after file count; what was deleted, merged (with rewritten inbound links),
and updated; what stays open.
