#!/usr/bin/env bash
set -euo pipefail

# Simple validator to check the built resume page contains correctly formatted
# work history entries (company name, job title, start date). Used in CI to
# detect regressions in resume templates.

SITE_DIR="${1:-_site}"
RESUME_FILE="$SITE_DIR/resume.html"

if [[ ! -f "$RESUME_FILE" ]]; then
  echo "ERROR: built resume file not found at: $RESUME_FILE" >&2
  echo "Run 'bundle exec jekyll build --destination $SITE_DIR' before running this script." >&2
  exit 2
fi

BASE_DIR=$(git rev-parse --show-toplevel 2>/dev/null || echo "$(pwd)")
WORK_SRC="$BASE_DIR/_work_history"

if [[ ! -d "$WORK_SRC" ]]; then
  echo "No _work_history directory found; nothing to validate." >&2
  exit 0
fi

missing=0

for src in "$WORK_SRC"/*.md; do
  [[ -f "$src" ]] || continue
  # Use POSIX [[:space:]] to trim whitespace reliably on macOS (avoid \s which isn't POSIX)
  company=$(awk '/^company_name:/{sub(/^company_name:[[:space:]]*/,"",$0); print $0; exit}' "$src" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
  title=$(awk '/^job_title:/{sub(/^job_title:[[:space:]]*/,"",$0); print $0; exit}' "$src" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
  start=$(awk '/^start_date:/{sub(/^start_date:[[:space:]]*/,"",$0); print $0; exit}' "$src" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')

  name_ok=true
  title_ok=true
  start_ok=true

  if [[ -n "$company" ]]; then
    if ! grep -Fq "$company" "$RESUME_FILE"; then
      echo "MISSING company in resume: '$company' (from $src)"
      name_ok=false
    fi
  else
    echo "WARN: no company_name found in $src"
    name_ok=false
  fi

  if [[ -n "$title" ]]; then
    if ! grep -Fq "$title" "$RESUME_FILE"; then
      echo "MISSING job_title in resume: '$title' (from $src)"
      title_ok=false
    fi
  else
    echo "WARN: no job_title found in $src"
    title_ok=false
  fi

  if [[ -n "$start" ]]; then
    if ! grep -Fq "$start" "$RESUME_FILE"; then
      echo "MISSING start_date in resume: '$start' (from $src)"
      start_ok=false
    fi
  else
    echo "WARN: no start_date found in $src"
    start_ok=false
  fi

  if ! $name_ok || ! $title_ok || ! $start_ok; then
    missing=$((missing + 1))
  fi
done

if [[ $missing -gt 0 ]]; then
  echo
  echo "FAIL: $missing work_history items missing data in $RESUME_FILE" >&2
  exit 1
fi

echo "PASS: all work_history entries show company, job title, and start date in $RESUME_FILE"
exit 0
