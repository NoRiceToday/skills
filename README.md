# Sajjad Ahmad — Agent Skills

[![skills.sh](https://skills.sh/b/NoRiceToday/skills)](https://skills.sh/NoRiceToday/skills)

Curated agent skills I've used internally and promoted on approval. Each skill
has been battle-tested in real workflows before it ships here.

## Quickstart

Install via the [skills.sh](https://skills.sh) CLI (works with Claude Code,
Cursor, Codex, Windsurf, Gemini, and other agent harnesses):

```bash
npx skills@latest add NoRiceToday/skills
```

Pick the skills you want, and which coding agents to install them on. Done.

## Install as a Claude Code plugin

Prefer a plug-and-play install that updates when I ship a new version? These
skills also ship as a native [Claude Code plugin](https://code.claude.com/docs/en/plugins).

Inside Claude Code:

```
/plugin marketplace add NoRiceToday/skills
/plugin install noricetoday-skills@noricetoday
```

Or from your shell:

```bash
claude plugin marketplace add NoRiceToday/skills
claude plugin install noricetoday-skills@noricetoday
```

## Layout

```
skills/
└── <category>/<name>/SKILL.md   # one folder per skill
```

Each skill folder contains a `SKILL.md` with YAML frontmatter (`name`,
`description`, …) and the skill body. Categories group related skills
(`engineering`, `productivity`, …).

## Versioning

This repo uses [Changesets](https://github.com/changesets/changesets) for
versioning and a GitHub-linked changelog. Maintainers add a changeset per
promoted skill and run `npm run version` to cut a release.

## License

MIT — see [LICENSE](./LICENSE).
