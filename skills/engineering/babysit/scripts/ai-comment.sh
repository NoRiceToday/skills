#!/usr/bin/env bash
# ai-comment.sh — stamp the AI marker on a comment body before it is posted.
#
# The user does not review agent-written comments. Every one must announce
# itself, so this is the only supported way to produce a body for posting.
#
# Usage:
#   ai-comment.sh <body-file>            # write <body-file>:<marker>.ready and print its path
#   ai-comment.sh <body-file> --check    # exit 1 unless the marker is present
#   ai-comment.sh <body-file> --marker '[AI:claude]'
#
# Env: AI_COMMENT_MARKER overrides the default marker.
# Default marker: [AI]

set -euo pipefail

MARKER="${AI_COMMENT_MARKER:-[AI]}"
CHECK=0
BODY=""

die() { printf '%s\n' "$*" >&2; exit 2; }

while [[ $# -gt 0 ]]; do
  case "$1" in
    --check)  CHECK=1; shift ;;
    --marker) [[ $# -ge 2 ]] || die "--marker needs a value"; MARKER="$2"; shift 2 ;;
    -h|--help) sed -n '2,16p' "$0" | sed 's/^# \{0,1\}//'; exit 0 ;;
    -*) die "unknown flag: $1" ;;
    *)  [[ -z "$BODY" ]] || die "one body file only"; BODY="$1"; shift ;;
  esac
done

[[ -n "$BODY" ]] || die "usage: ai-comment.sh <body-file> [--check] [--marker '<marker>']"
[[ -f "$BODY" ]] || die "no such file: $BODY"
[[ -s "$BODY" ]] || die "empty body: $BODY"

first="$(awk 'NF{print; exit}' "$BODY")"

has_marker() {
  case "$first" in
    "$MARKER"|"$MARKER "*) return 0 ;;
    *) return 1 ;;
  esac
}

if [[ $CHECK -eq 1 ]]; then
  if has_marker; then
    printf 'ok: marked\n'
    exit 0
  fi
  printf 'unmarked comment body: %s\n' "$BODY" >&2
  exit 1
fi

# Refuse to double-stamp: a body that already carries the marker is either
# ready or was tampered with. Either way, do not silently rewrite it.
if has_marker; then
  printf 'ok: already marked, passing through: %s\n' "$BODY"
  exit 0
fi

ready="$(mktemp "${TMPDIR:-/tmp}/ai-comment.XXXXXX")"
awk -v m="$MARKER" '{ if (!done && NF) { print m " " $0; done=1 } else print }' "$BODY" > "$ready"
printf '%s\n' "$ready"
