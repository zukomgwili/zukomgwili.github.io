#!/usr/bin/env bash
set -euo pipefail

# Basic discoverability check for generated Jekyll site
# Usage: ./scripts/check-discoverability.sh [site-dir]

SITE_DIR="${1:-_site}"

echo "Checking discoverability in site dir: $SITE_DIR"

if [ ! -d "$SITE_DIR" ]; then
  echo "Site directory '$SITE_DIR' not found — attempting to build..."
  if command -v bundle >/dev/null 2>&1; then
    bundle exec jekyll build --destination "$SITE_DIR"
  elif command -v jekyll >/dev/null 2>&1; then
    jekyll build --destination "$SITE_DIR"
  else
    echo "Error: cannot build site (missing bundle/jekyll). Make sure to run from CI where the site is built or install jekyll/bundle locally." >&2
    exit 2
  fi
fi

missing=0
check_file() {
  local file_path="$1"
  if [ ! -e "${SITE_DIR}/${file_path}" ]; then
    echo "MISSING: ${SITE_DIR}/${file_path}"
    missing=1
  else
    echo "OK: ${SITE_DIR}/${file_path}"
  fi
}

# Commonly required discoverable assets
check_file "about.html"
check_file "assets/resume.pdf"

if [ "$missing" -ne 0 ]; then
  echo "Discoverability check FAILED: one or more resources are missing." >&2
  exit 1
fi

echo "Discoverability check PASSED"
exit 0
