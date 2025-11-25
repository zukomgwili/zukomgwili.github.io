#!/usr/bin/env bash
set -euo pipefail

# normalize-front-matter.sh
# Scan _posts/ for missing `date` or `excerpt` in YAML front matter.
# By default this is a dry-run and prints a report. Use --apply to write
# fallback values to files (date is inferred from filename, excerpt is the
# first paragraph of the post content trimmed to 200 characters).

ROOT_DIR=$(git rev-parse --show-toplevel 2>/dev/null || echo "$(pwd)")
POST_DIR="$ROOT_DIR/_posts"
APPLY=false
DRY_RUN=true
VERBOSE=false

usage() {
  cat <<EOF
Usage: $(basename "$0") [--apply] [--dry-run] [--verbose]

--apply    : Write fallback values into files (destructive). Default: dry-run
--dry-run  : Only report missing fields (default)
--verbose  : Show per-file detail

This script finds posts missing `date` or `excerpt` in front matter and
can optionally add fallback values:
  - date: inferred from file name prefix YYYY-MM-DD (if available)
  - excerpt: first paragraph (trimmed)

It exits with status 0 if no problems found; non-zero if missing fields were found
and not applied.
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --apply)
      APPLY=true; DRY_RUN=false; shift ;;
    --dry-run)
      APPLY=false; DRY_RUN=true; shift ;;
    --verbose)
      VERBOSE=true; shift ;;
    -h|--help)
      usage; exit 0 ;;
    *)
      echo "Unknown option: $1" >&2; usage; exit 2 ;;
  esac
done

if [[ ! -d "$POST_DIR" ]]; then
  echo "No _posts directory found at $POST_DIR" >&2
  exit 0
fi

missing_count=0
changed_count=0

for file in "$POST_DIR"/*; do
  # skip non-markdown
  [[ -f "$file" ]] || continue
  if ! grep -q "^---" "$file"; then
    [[ "$VERBOSE" == true ]] && echo "Skipping $file — no front matter"
    continue
  fi

  # extract YAML front matter (between first '---' and next '---')
  fm=$(awk 'BEGIN{p=0} /^---/{if(p==0){p=1;next}else{exit}} p==1{print}' "$file") || fm=""

  has_date=$(printf "%s" "$fm" | grep -E "^date:\s*" || true)
  has_excerpt=$(printf "%s" "$fm" | grep -E "^excerpt:\s*" || true)

  # Record missing fields
  missing=""
  if [[ -z "$has_date" ]]; then
    missing+="date"
  fi
  if [[ -z "$has_excerpt" ]]; then
    if [[ -n "$missing" ]]; then
      missing+=", "
    fi
    missing+="excerpt"
  fi

  if [[ -z "$missing" ]]; then
    [[ "$VERBOSE" == true ]] && echo "OK: $(basename "$file") — has date & excerpt"
    continue
  fi

  ((missing_count++))
  echo "MISSING [$missing]: $(basename "$file")"

  if [[ "$APPLY" == true ]]; then
    tmp=$(mktemp)
    cp "$file" "$tmp"

    # construct replacements
    # date: try to parse YYYY-MM-DD from filename
    filename=$(basename "$file")
    if [[ -z "$has_date" && "$filename" =~ ^([0-9]{4}-[0-9]{2}-[0-9]{2})- ]]; then
      found_date="${BASH_REMATCH[1]}"
    else
      # fallback: use today's date
      found_date=$(date +%Y-%m-%d)
    fi

    # excerpt: get the first non-empty paragraph after front matter
    if [[ -z "$has_excerpt" ]]; then
      excerpt_raw=$(awk 'BEGIN{p=0} /^---/{if(p==0){p=1;next}else{p=2;next}} p==2{print}' "$file" | awk 'BEGIN{RS=""} NR==1{print}' | sed -E 's/^[[:space:]]+//; s/[[:space:]]+$//')
      # trim to 200 chars safely
      excerpt_trimmed=$(printf "%s" "$excerpt_raw" | tr -d '\r' | cut -c1-200)
      # ensure single-line for YAML
      excerpt_escaped=$(printf "%s" "$excerpt_trimmed" | sed 's/"/\"/g' | tr "\n" " " | sed 's/[[:space:]]\+/ /g')
    fi

    # Now write the updated file: insert date and/or excerpt into front matter
    awk -v add_date="$found_date" -v add_excerpt="$excerpt_escaped" -v has_date="$has_date" -v has_excerpt="$has_excerpt" '
    BEGIN{p=0}
    /^---/{if(p==0){print; p=1; next} else {print; p=3; next}}
    p==1{print; next}
    p==3{print; next}
    ' "$tmp" > "$file".new

    # Simpler approach: rewrite by reading front matter then adding missing fields after first '---'
    # Build new front matter
    fm_out=""
    while IFS= read -r line; do
      if [[ "$line" == "---" ]]; then
        fm_out+="---\n"
        break
      fi
    done < "$tmp"

    # Append current front matter from tmp but ensure we don't duplicate additions
    in_fm=true
    while IFS= read -r line; do
      if [[ "$line" == "---" ]]; then
        in_fm=false
        break
      fi
      fm_out+="$line\n"
    done < "$tmp"

    # add missing fields
    if [[ -z "$has_date" ]]; then
      fm_out+="date: $found_date\n"
    fi
    if [[ -z "$has_excerpt" ]]; then
      fm_out+="excerpt: \"$excerpt_escaped\"\n"
    fi

    fm_out+="---\n"

    # now append the rest of the file (content)
    rest=$(awk 'BEGIN{p=0} /^---/{if(p==0){p=1;next}else{p=2;next}} p==2{print}' "$tmp") || rest=""

    printf "%s\n%s" "$fm_out" "$rest" > "$file"

    ((changed_count++))
    echo "APPLIED: updated $(basename "$file") (added: $missing)"
  fi
done

echo
echo "Summary: missing files detected: $missing_count, files changed: $changed_count"

if [[ $missing_count -gt 0 && "$APPLY" == false ]]; then
  echo "Run with --apply to write fallback values to these files (review changes before committing)." >&2
  exit 1
fi

exit 0
