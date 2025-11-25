#!/usr/bin/env bash
set -euo pipefail

# Scans the generated site (default: _site) for external <script> tags and matches
# against a small blacklist of known third-party tracker hostnames.

BUILD_DIR="${1:-_site}"

if [[ ! -d "$BUILD_DIR" ]]; then
  echo "ERROR: Build directory '$BUILD_DIR' not found. Run a site build first (e.g. bundle exec jekyll build)." >&2
  exit 2
fi

echo "Scanning $BUILD_DIR for external scripts and known trackers..."

blacklist=(
  "googletagmanager.com"
  "google-analytics.com"
  "analytics.google.com"
  "facebook.net"
  "facebook.com"
  "ads.linkedin.com"
  "quantserve.com"
  "doubleclick.net"
  "hotjar.com"
)

matches=0

# Find script src attributes pointing to external hosts
while IFS= read -r src; do
  # Extract hostname from the URL
  host=$(echo "$src" | sed -E 's#https?://([^/]+).*#\1#' | sed -E 's/^www\.//')
  for b in "${blacklist[@]}"; do
    if echo "$host" | grep -qi "$b"; then
      echo "FOUND disallowed script reference: $src (matched: $b)"
      matches=$((matches+1))
    fi
  done
done < <(grep -rhoP "<script[^>]+src=[\"']?https?://[^\"'>]+[\"']?" "$BUILD_DIR" || true)

if [ "$matches" -gt 0 ]; then
  echo "ERROR: Found $matches disallowed external script references — privacy gate FAILED." >&2
  exit 1
fi

echo "No known third-party tracker scripts found. Privacy gate OK."
exit 0
