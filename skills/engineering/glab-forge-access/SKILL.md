---
name: glab-forge-access
description: GitLab forge access through the glab CLI — the exact commands for opening a merge request, reading its diff and commits, and posting general and inline comments. Use when a workflow skill asks for a `*-forge-access` skill and the origin host is GitLab.
---

# GitLab Forge Access (glab)

Commands below are glab argv. If a skill that brokers `glab` is installed,
run them through it; otherwise run `glab` directly.

Always pass `-R group/project` (the `origin` path). `<iid>` is the merge
request number.

## open

```bash
glab mr create -R group/project \
  --source-branch <current-branch> \
  --target-branch <target> \
  --title "<title>" \
  --description "<description>" \
  --remove-source-branch \
  --yes
```

The description may be multiline. Report the MR URL from the output.

## diff

```bash
glab mr diff <iid> -R group/project
```

## commits

glab has no commit-list verb. Read the branch names, then use git:

```bash
glab mr view <iid> -R group/project --output json   # source_branch, target_branch
git fetch origin <source_branch> <target_branch>
git log --no-decorate origin/<target_branch>..origin/<source_branch>
```

## comment

```bash
glab mr note create <iid> -R group/project -m "<body>"
```

## inline-comment

New side of the diff:

```bash
glab mr note create <iid> -R group/project --file <path> --line <new-line> -m "<body>"
```

Removed side: replace `--line <new-line>` with `--old-line <old-line>`.

## suggestion syntax

A GitLab suggestion replaces the commented line. Put it inside the comment
body:

````text
```suggestion:-0+0
<replacement line(s)>
```
````

`-N+M` widens it to N lines above and M lines below the commented line.
