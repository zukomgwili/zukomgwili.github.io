#!/usr/bin/env bash
set -euo pipefail

SITE_DIR="${1:-_site}"

if [[ ! -d "$SITE_DIR" ]]; then
  echo "Site directory not found: $SITE_DIR" >&2
  exit 2
fi

python3 scripts/check-image-alts.py "$SITE_DIR"
