#!/usr/bin/env bash
set -euo pipefail

# Purge unused CSS from the generated `_site` directory.
# Non-destructive: writes output to `_site/optimized/css`.

OUT_DIR="${1:-_site/optimized/css}"
SRC_CSS_DIR="${2:-_site/assets}"   # source folder containing css files
CONTENT_DIR="${3:-_site}"          # html content dir

mkdir -p "$OUT_DIR"

if command -v npx >/dev/null 2>&1; then
  echo "Running PurgeCSS via npx (may download on first run)."
  npx -y purgecss --css "$SRC_CSS_DIR"/**/*.css --content "$CONTENT_DIR"/**/*.html --output "$OUT_DIR" || true
  echo "PurgeCSS run complete — optimized CSS written to $OUT_DIR"
else
  echo "npx not available, skipping PurgeCSS. To run manually, install purgecss: npm i -D purgecss && npx purgecss --css _site/assets/**/*.css --content _site/**/*.html --output _site/optimized/css" >&2
fi

exit 0
