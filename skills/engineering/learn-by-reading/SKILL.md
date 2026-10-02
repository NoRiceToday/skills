---
name: learn-by-reading
description: Teach a technology or codebase by reading real code, separating best practice from smells. Use when the user asks to learn or be taught a technology or codebase, wants an interactive tutorial, or wants generated code judged against best practices by reading it.
---

# Learn by reading

Version 0.1.

Teach by working through real code. The learner reads and judges; the agent explains first, then shows the code. Deliver lessons in the learner's language.

The failure this skill prevents: quizzing the learner on patterns they cannot yet recognise, and making them infer the rules. The concept and the recognition cue come before any question.

## Learner profile first

Before the first lesson, capture what the learner already knows, what is new, and the pace they want. Write it to [`references/learner-profile.md`](references/learner-profile.md). An expert in the field but new to the tool wants tool surface, not concept lectures. Recheck the profile when the learner corrects the pace.

Completion: the profile names expertise, knowns, unknowns, and language.

## The lesson arc

Every lesson takes one shape, in order: **Konzept → Code → Erkennung → Warum → Idiomatisch → Repo**. Template in [`references/lesson-template.md`](references/lesson-template.md).

- **Konzept** first: the idea in plain language, before any code. One concept per lesson.
- **Code**, labelled: what the snippet is and where it lives (agent, tool, instruction provider, callback, workflow). An unlabelled snippet cannot be judged.
- **Erkennung**: the concrete cue that identifies the pattern in code. This is the part learners cannot guess.
- **Warum**: the consequence. What breaks, what it costs.
- **Idiomatisch**: the corrected version beside the smell.
- **Repo**: the same pattern in the codebase under study.

Do not ask the learner to name a pattern before the Konzept and the Erkennung are on the page. When the learner answers, explain it fully; leave nothing to infer.

Completion: the lesson names one concept, shows labelled code, and states the cue, the consequence, the fix, and the repo location.

## Verify with teach-back

Close a lesson by asking the learner to explain the concept back in their own words. Teach-back comes after the explanation, never before. A gap means the lesson failed, not the learner: re-explain it and log the gap.

## Feedback loop

Run the loop through the session, not once. Format and stages in [`references/feedback-loop.md`](references/feedback-loop.md).

- **Detect** confusion, criticism, repeated questions, and pushback as they appear. Treat "ich verstehe das nicht" as a bug in the skill.
- **Ask** the learner for feedback at natural pauses: after a lesson, after a format change.
- **Log** each signal with the skill version.
- **Consolidate** recurring signals into concrete edits, then bump the version. Collect during a lesson; edit between lessons.

Completion: every signal this session is logged, and each recurring one has a proposed edit.

## Domain content lives with the material

The topics a lesson teaches (domain smells, worked examples, facts) live with the material under study, not in this skill. They are specific to one codebase and go stale when it moves, so they should die with the workspace. This skill keeps the method and the feedback loop, the parts worth carrying forward. The durable artefact from a lesson is its feedback entry.

## Principles

- One concept per lesson.
- Explain before testing.
- Label every code block with what it is and where it lives.
- Pair every smell with its idiomatic opposite and the reason.
- Keep the learner's decisions, the code's observed behaviour, and the agent's recommendations distinct.
- Measure success by understanding, not by code typed.
