---
name: writing-review-comments
description: How to write an MR/PR review comment — the hard three-sentence budget, when a finding is dropped instead of posted, phrasing rules (intent as question, nullability as open choice, concrete refactor sketches, no scope hedges), and the sign-off gate before anything is posted. Reached by a pointer from publish-review-findings, not by model invocation — read it when that skill sends you here, or whenever you are about to phrase a review finding as a comment a person will read.
disable-model-invocation: true
---

# Writing Review Comments

This skill owns *what a review comment says*. It does not post anything and does not
talk to GitLab or GitHub — `publish-review-findings` owns that transport and points
here for content and presentation.

## 1. Before drafting: is it already settled?

Check whether a finding was already resolved out loud — in chat, in an earlier comment,
in the handover discussion. If so, it does not get a draft at all. This is the one case
where a finding disappears without being named: the user already knows, so naming it
again is noise. Every *other* drop is named — see §6.

## 2. The hard budget

> **One finding = one sentence naming the observable consequence + one sentence with the
> ask. Three sentences is the hard ceiling.**

If a finding needs more than that to land, it is not a comment — it is a question to the
user about whether it becomes a ticket instead of an inline note. Don't stretch a comment
to fit; shrink the finding or escalate it to that question.

## 3. Nits

One line per nit. Bundle **all** nits for a review into a single comment — never one
thread per nit.

## 4. The review taxonomy stays internal

`P0`–`P3`, the bucket names (`bug`, `maintainability`, `missing-test`, `docs-drift`,
`decision-violation`, `decision-conflict`, `speculative`), and `Confidence` are working
tools of the review. None of them appear in a posted comment. This is the concrete case
of the general "no internal shorthand" rule — stated here because
it is the one taxonomy every review produces.

Why: a reader cannot act on an abbreviation such as `fnd-1` that was never defined for them.

## 5. Phrasing

- **Possible intent → question, not defect.** If the author might have done this on
  purpose, ask, don't assert a bug.
- **Nullability → an internal consistency question with both resolutions offered**, not
  a prescribed fix. Show the two ways it could be made consistent and let the author pick.
- **Code smell → a concrete signature or record sketch**, not abstract advice. Don't
  write "consider a parameter object" — sketch the actual parameter object.
- **No scope hedges.** Don't write "could also be a follow-up MR if it's out of scope for
  this one." Name the suggestion; the author decides the scope.
- **Point at the file and line, not at the principle.** "`resolve()` in
  `AliasService.java:88`" lands; "this violates the N+1 rule" does not. The author has to
  be able to go straight to the code.
- **Voice is the poster's:** "ich", not "wir".

## 6. Drops

A finding whose fix belongs in a different ticket is **not posted**, but **is named** in
the draft shown to the user:

> not posted, belongs to CORE-XXXX: `<one line on what it is>`

This lets the user pull it back into the MR if they disagree with the drop. Never drop a
finding silently — a named drop can be challenged, a silent one can't.

## 7. Presentation and the sign-off gate

Present numbered drafts with the exact text that would be posted — not a description of
the comment, the comment itself. **Nothing is posted without the user's explicit
sign-off.**

## 8. Suggestion blocks

Use a suggestion block for edits that apply as-is; the forge-access skill gives the syntax.

## 9. Language

Language: the repo's documented language-per-surface rules (`AGENTS.md`, `CLAUDE.md`,
or a `docs/agents/language.md` convention) if one exists.
Otherwise ask once which language posted comments should use, then follow it for the review.

## 10. Check before you present

Before showing any draft to the user, read it against three questions:

1. Is it over three sentences?
2. Does it contain internal shorthand (a priority code, a bucket name, `Confidence`)?
3. Does the ask read like a verdict instead of a request?

Any "yes" means rewrite before presenting, not after.

## Examples

```text
before   [BLOCKER] [bug] AliasService.resolve() — N+1 query. P0/certain.
         Fix: batch the lookup via findAllById.

after    Bei einer Seite mit 40 Aliassen macht `resolve()` 40 einzelne Selects
         statt einem. Magst du das über `findAllById` bündeln?
```

```text
before   [NICE TO HAVE] [maintainability] Naming inconsistency, P3.

after    Nits, alles optional: `sectionNode` heißt zwei Zeilen tiefer `node` ·
         fehlendes `final` in Zeile 88.
```

The `after` examples stay in German because MR/PR comments are German per
`docs/agents/language.md` — this skill's own text is English, the comments it produces
are not.
