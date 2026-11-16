---
name: gh-forge-access
description: GitHub forge access through the gh CLI — the exact commands for opening a pull request, reading its diff, commits and linked issues, and posting general and inline comments. Use when a workflow skill asks for a `*-forge-access` skill and the origin host is GitHub.
---

# GitHub Forge Access (gh)

Commands below are gh argv. If a skill that brokers `gh` is installed,
run them through it; otherwise run `gh` directly.

Always pass `-R owner/repo` (the `origin` path) to `gh pr` and `gh issue`.
`<pr>` is the pull request number.

## open

```bash
gh pr create -R owner/repo \
  --head <current-branch> \
  --base <target> \
  --title "<title>" \
  --body "<description>"
```

gh has no per-PR "delete source branch" flag. Tell the user that branch
deletion follows the repository's "Automatically delete head branches"
setting. Report the PR URL from the output.

## diff

```bash
gh pr diff <pr> -R owner/repo
```

## commits

```bash
gh pr view <pr> -R owner/repo --json commits
```

## view

```bash
gh pr view <pr> -R owner/repo --json closingIssuesReferences,body,headRefOid
```

`closingIssuesReferences` lists the linked issues; `headRefOid` is the head
commit SHA that `inline-comment` needs.

## view-issue

```bash
gh issue view <number> -R owner/repo --json title,body,url
```

## comment

```bash
gh pr comment <pr> -R owner/repo --body "<body>"
```

## inline-comment

gh's CLI cannot post inline review comments; use the REST API. Get
`<head_sha>` from `view`. `gh api` takes no `-R`, so take owner and repo from
the `origin` path.

```bash
gh api -X POST /repos/<owner>/<repo>/pulls/<pr>/comments \
  -f path=<path> -F line=<line> -f side=RIGHT \
  -f commit_id=<head_sha> -f body="<body>"
```

- Multi-line: add `-F start_line=<first-line>`.
- Removed side: `-f side=LEFT` with the old line number (multi-line: also `-f start_side=LEFT`).

## suggestion syntax

A GitHub suggestion replaces the commented line or line range. Put it inside
the comment body:

````text
```suggestion
<replacement line(s)>
```
````
