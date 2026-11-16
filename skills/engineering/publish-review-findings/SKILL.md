---
name: publish-review-findings
description: "Posting utility: turn adversarial-review findings into merge request or pull request comments. Sets up a worktree for full-file context, drafts comments, presents them for user approval, and posts approved comments through the installed forge-access skill. Not a reviewer — adversarial-review owns the review."
---

# Publish Review Findings

Take structured findings from `adversarial-review` and post them as merge
request or pull request comments after user approval. This skill does **not**
review code — it is a delivery channel.

Input: the `adversarial-review` handover under `.review/<run-id>/` and the
MR/PR id.

## Forge access

Use the installed `*-forge-access` skill for the `origin` host's forge.
If more than one matches, prefer the CLI-based one over the `*-mcp-forge-access` one.

Below, "the `<name>` operation" means that operation of the chosen
forge-access skill.

## Workflow

### 1. Worktree for full-file context

So the user can verify findings against full files, not just diff hunks:

1. Run `git worktree list` to check whether a worktree for the source branch
   already exists.
2. **If it exists:** use that path.
3. **If not:** derive `<repo-root>/.worktrees/<branch-slug>` (branch name with
   `/` replaced by `-`). Run `git fetch origin <source_branch>` if the branch
   is unknown locally, then `git worktree add <path> <source_branch>`. Keep the
   worktree inside the repo; sandboxed sessions may not reach sibling paths.
4. If the fetch or the worktree fails, work from the `diff` operation's output
   and any files already checked out, and note "full-file context limited".

Read `AGENTS.md` / `LOCAL_SETUP.md` from the worktree if present.

### 2. Translate findings to comment drafts

- **General comment** (one per review): the handover's Summary + Verdict + Risk.
- **Inline comment** per finding with a `Location: file:line`: on the new side
  of the diff, or on the removed side when the finding points at a deleted
  line. Line numbers come from the review package's diff hunks.

What a draft says, how long it runs, and what tone it takes come from the
`writing-review-comments` skill. It is not model-invocable: read
`../writing-review-comments/SKILL.md` relative to this skill's base directory.
Directly applicable edits use the forge-access skill's suggestion syntax.

### 3. Present before posting

Follow §7 of the `writing-review-comments` file read in §2 for how drafts are shown and approved
before anything is posted.

### 4. Post approved comments

Post the general comment with the `comment` operation and each inline comment
with the `inline-comment` operation. If an operation fails, stop, show the
error, and list the drafts not yet posted — do not retry silently.
