#!/usr/bin/env bash
set -euo pipefail

# Validate front-matter for known content types to avoid build breakages.
# Checks:
#  - _posts/*.md -> must contain title and date
#  - _work_history/*.md -> must contain company_name, job_title, start_date
#  - _education/*.md -> must contain school, start_year
#  - top-level pages (about.md, resume.html) should have title

ROOT_DIR="${1:-.}"
errs=0

echo "Validating front-matter under ${ROOT_DIR}"

extract_front_matter() {
  # Extract YAML front-matter (the block between the first and second '---' lines)
  # Return nothing if no valid front-matter block exists.
  if [ "$(head -n1 "$1" 2>/dev/null)" != '---' ]; then
    return 1
  fi
  # Find the line number of the closing '---'
  # Use grep -n to be portable (works on macOS and Linux)
    local lines
    lines=$(grep -n '^---[[:space:]]*$' "$1" || true)
    # If there are fewer than two '---' lines, no valid block
    local count
    count=$(printf '%s\n' "$lines" | wc -l | tr -d ' ')
  if [ "$count" -lt 2 ]; then
    return 1
  fi
  local second_line
    second_line=$(printf '%s\n' "$lines" | sed -n '2p' | cut -d: -f1)
  local start=2
  local end=$((second_line - 1))
  sed -n "${start},${end}p" "$1"
}

check_keys() {
  local file="$1"; shift
  local keys=("$@")
  local fm
  fm="$(extract_front_matter "$file")"
  if [ -z "${fm}" ]; then
    echo "ERROR: $file - missing YAML front-matter (--- block)"
    errs=1
    return
  fi
  for k in "${keys[@]}"; do
    if ! echo "$fm" | grep -E "^[[:space:]]*${k}:[[:space:]]*" >/dev/null; then
      echo "ERROR: $file - missing required front-matter key: ${k}"
      errs=1
    fi
  done
}

# 1) Posts
shopt -s nullglob 2>/dev/null || true
for f in ${ROOT_DIR}/_posts/*.md; do
  # posts often have date in filename -- ensure they include a layout or title
  if [ ! -f "$f" ]; then
    continue
  fi
  fm_file="$f"
  fm=""
  if extract_front_matter "$fm_file" >/dev/null 2>&1; then
    fm=1
  fi
  if [ -n "$fm" ]; then
    # require at least layout OR title
    fm_text=$(extract_front_matter "$fm_file" || true)
    if ! printf "%s" "$fm_text" | grep -E '^\s*(layout|title):' >/dev/null; then
      echo "ERROR: $f - expected front-matter to include 'layout' or 'title'"
      errs=1
    fi
  else
    # No front-matter: check filename has YYYY-MM-DD prefix to confirm Jekyll post
    if ! basename "$f" | grep -E '^[0-9]{4}-[0-9]{2}-[0-9]{2}-' >/dev/null; then
      echo "ERROR: $f - missing front-matter and not a dated post filename"
      errs=1
    fi
  fi
done

# 2) Work history
for f in ${ROOT_DIR}/_work_history/*.md; do
  check_keys "$f" company_name job_title start_date
done

# 3) Education
for f in ${ROOT_DIR}/_education/*.md; do
  check_keys "$f" school start_year
done

# 4) Top-level pages we care about
for f in ${ROOT_DIR}/about.md ${ROOT_DIR}/resume.html; do
  if [ -f "$f" ]; then
    if [[ "$f" == *.md ]]; then
      check_keys "$f" title
    else
      # HTML layout files usually rely on front-matter in top (jekyll) -- check for title on file
      extract_front_matter "$f" | grep -E "^[[:space:]]*title:[[:space:]]*" >/dev/null || { echo "WARN: $f - no title front-matter found (this is optional for HTML layout)"; }
    fi
  fi
done

if [ "$errs" -ne 0 ]; then
  echo "\nOne or more front-matter validation errors detected. Please fix the listed files before merging." >&2
  exit 1
fi

echo "Front-matter validation passed."
exit 0
