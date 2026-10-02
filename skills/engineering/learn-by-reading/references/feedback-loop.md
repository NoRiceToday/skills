# Feedback loop

The skill improves from its own use. Four stages.

## 1. Detect

Watch the conversation for signals that the skill, not the learner, fell short:

- Confusion: "ich verstehe das nicht", "ich check nix", a long silence after a step.
- Criticism of the method: "das ist zu viel", "das war unklar", "so habe ich es nicht verstanden".
- Repeated questions about the same point.
- Pushback on a claim, which may mean the claim or its explanation was wrong.

Treat every signal as a bug in the skill.

## 2. Ask

At natural pauses, such as the end of a lesson or after a format change, ask one focused question: what was unclear, what was missing. Do not interrupt an explanation to ask.

## 3. Log

Append a row to the log below. One row per signal. Keep the trigger in the learner's own words.

| Date | Trigger | Skill problem | Change | Version |
| --- | --- | --- | --- | --- |
| 2026-10-02 | "ich check gar nix" | Concept and cue came after the question; snippets were unlabelled | Lesson arc fixed to Konzept-first; labels required | 0.1 |
| 2026-10-02 | "woran erkenne ich das?" | No recognition cue per smell | Erkennung step added to the arc and the catalogue | 0.1 |

## 4. Consolidate

When a signal repeats, make one concrete edit to the skill: a new cue, a new principle, a reordered step, a removed no-op. Bump the version at the top of `SKILL.md` and record the change in the log row. Edit between lessons, never during one; collect first, then improve.

Completion: every signal this session is logged, and each recurring one has a proposed edit.
