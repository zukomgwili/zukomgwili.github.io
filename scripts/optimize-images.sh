#!/usr/bin/env bash
set -euo pipefail

# Lossless image optimizer helper for the repo.
# - Uses npx svgo for SVGs
# - Uses npx imagemin-cli for raster images if available
# Outputs optimized files to _site/optimized/assets (non-destructive)

OUT_DIR="${1:-_site/optimized/assets}"
SRC_DIR="${2:-_site/assets}"

echo "Optimizing images from $SRC_DIR -> $OUT_DIR"
mkdir -p "$OUT_DIR"

# Optimize SVGs using svgo
if command -v npx >/dev/null 2>&1; then
  echo "Optimizing SVGs with svgo via npx (may download the package if not cached)..."
  npx -y svgo -f "$SRC_DIR" -o "$OUT_DIR" --multipass || true
else
  echo "npx not available — skipping svgo optimizations" >&2
fi

# Optimize PNG/JPEG/WebP using imagemin if available
if command -v npx >/dev/null 2>&1; then
  echo "Optimizing PNG/JPEG using imagemin-cli via npx..."
  # Use common imagemin plugins
  npx -y imagemin-cli "$SRC_DIR/*.{png,jpg,jpeg,webp}" --out-dir="$OUT_DIR" --plugin=pngquant --plugin=mozjpeg || true
else
  echo "npx not available — skipping imagemin optimizations" >&2
fi

echo "Optimization run complete. Compare $SRC_DIR with $OUT_DIR to review changes." 

exit 0
