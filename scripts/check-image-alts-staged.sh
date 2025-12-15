#!/usr/bin/env bash
set -euo pipefail

# Check staged files for images with missing alt text.
# Looks at added/modified staged files (git cached) and finds markdown image
# references with empty alt [](...) and html <img> tags without alt or empty alt="".

STAGED_FILES=$(git diff --cached --name-only --diff-filter=ACM)
if [[ -z "$STAGED_FILES" ]]; then
  echo "No staged files to check." >&2
  exit 0
fi

bad=0

for f in $STAGED_FILES; do
  # only check HTML/MD/MDOWN files
  case "$f" in
    *.md|*.markdown|*.html)
      # read staged content (not disk) so pre-commit sees pre-index changes
      content=$(git show :"$f" 2>/dev/null || true)
      if [[ -z "$content" ]]; then
        continue
      fi

      # check for markdown images with empty alt: ![   ](url)
      md_matches=$(printf "%s" "$content" | grep -nE "!\[[[:space:]]*\]\(.*\)" || true)
      if [[ -n "$md_matches" ]]; then
        echo "[ERROR] $f contains markdown images with empty alt:"
        printf "%s\n" "$md_matches"
        bad=1
      fi

      # check for HTML <img ...> without alt or alt=""
      html_missing=$(printf "%s" "$content" | grep -nE "<img[^>]*>" | while IFS= read -r line; do
        # get the tag portion
        tag=$(printf "%s" "$line" | sed -n 's/^[0-9]\+:\s*//; s/.*\(<img[^>]*>\).*/\1/p')
        if [[ -z "$tag" ]]; then
          continue
        fi
        # if 'alt=' missing or alt empty
        if ! printf "%s" "$tag" | grep -q -E "\balt=\"[^\"]+\""; then
          printf "%s\n" "$line"
        fi
      done || true)

      if [[ -n "$html_missing" ]]; then
        echo "[ERROR] $f contains <img> tags missing alt text (or empty alt):"
        printf "%s\n" "$html_missing"
        bad=1
      fi
    ;;
    *)
      ;; # skip
  esac
done

if [[ $bad -ne 0 ]]; then
  echo
  echo "Please add descriptive alt text to images before committing." >&2
  exit 1
fi

echo "PASS: staged files have image alt text." 
exit 0
