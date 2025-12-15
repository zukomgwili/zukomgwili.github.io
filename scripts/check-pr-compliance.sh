#!/usr/bin/env bash
set -euo pipefail

# Minimal check: when run in GitHub Actions for pull_request events, confirm the
# PR body contains the phrase "Constitution" or "compliance" so reviewers see the
# required constitution compliance note.

EVENT_FILE="${GITHUB_EVENT_PATH:-/github/workflow/event.json}"

if [[ ! -f "$EVENT_FILE" ]]; then
  echo "No GitHub event file found at $EVENT_FILE; skipping PR compliance check." >&2
  exit 0
fi

PR_BODY=$(jq -r '.pull_request.body // empty' "$EVENT_FILE") || PR_BODY=""

if [[ -z "$PR_BODY" ]]; then
  echo "ERROR: Pull request body is empty — please include a short constitution compliance statement in the PR description." >&2
  exit 1
fi

if echo "$PR_BODY" | grep -qiE "constitution|compliance|privacy|accessibility"; then
  echo "PR body contains compliance-related keywords — PR compliance check OK."
  exit 0
else
  echo "ERROR: PR description does not include constitution compliance info. Please add a short statement explaining how this PR complies with the project constitution (accessibility, privacy, CI gates where applicable)." >&2
  exit 1
fi
