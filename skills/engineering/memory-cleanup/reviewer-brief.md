# Reviewer brief (step 2)

Pass this to each Sonnet reviewer, with the placeholders filled in. Everything below the line is
the brief.

---

You review Claude memory files for staleness. READ-ONLY task.

Memory dir: `<memory dir>`
Repo (run git commands here): `<repo path>`
Reference ref: `<origin/main sha>`, dated `<date>` (no fetch possible → cite this date).
Reference rules file (read it): `~/.claude/CLAUDE.md`. Also the repo's `AGENTS.md`/`CLAUDE.md`
files and skills under `~/.claude/skills/` — a memory whose rule already stands there is a
deletion candidate.
Index: `MEMORY.md` in the memory dir.

Your batch (`<topic>`): `<file list>`
`<batch-specific hints: files to read for contradiction checks only, rules to check against>`

Rules:

- Read only: Read, Grep, Glob, and `git show` / `git log` / `git ls-files` / `git grep` via Bash.
  No builds, no writing files, no cat/sed/heredoc. Read files with the Read tool.
- Per file, check:
  1. Do the named files, classes, flags, config keys, scripts, paths still exist? In the repo
     against the reference ref (`git show <ref>:<path>`, `git grep <name> <ref>`); outside the
     repo via Read/Glob. A path the sandbox denies is "nicht prüfbar" / "not checkable".
  2. Is the statement already in `~/.claude/CLAUDE.md`, a repo doc, or a skill — or derivable from
     code or git history? Then it is a deletion candidate; name where it stands.
  3. Markers like SUPERSEDED, OBSOLETE, RETIRED, "retest", "pending", a date with "until": has the
     described transition happened by now?
  4. Does it contradict another memory in the batch or one it links to via `[[...]]`? Read both.
  5. Does the `MEMORY.md` line still match the file's current content?
- Some memories deliberately record falsified hypotheses so nobody repeats the probes. That is
  not stale content: such files may at most be tightened.
- A user preference or rule is not falsified by existing code that violates it.
- Ignore the spelling style of `name:` slugs and `[[links]]` (hyphen vs underscore) — handled
  centrally. Report `[[links]]` that match a memory under no spelling.
- For every update or merge proposal, give the new core content in one sentence.

Output: a markdown table, one row per file, in the user's language:
`file | proposal (keep / update / merge with X / delete / unclear) | reason in one sentence | evidence (path:line, git command, or "not checkable")`
Every proposal carries evidence; "not checkable" beats a guess. After the table: cross-file
contradictions, and the one-sentence new core content per update/merge.
