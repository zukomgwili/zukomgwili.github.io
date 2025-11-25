#!/usr/bin/env bash
set -euo pipefail

SITE_DIR="${1:-_site}"
PORT="${2:-4000}"
OUT_DIR="${3:-visual-snapshots}"

if [ ! -d "$SITE_DIR" ]; then
  echo "Site directory '$SITE_DIR' not found — build it first or pass the correct path" >&2
  exit 2
fi

python3 -m http.server "$PORT" -d "$SITE_DIR" &
SERVER_PID=$!
trap 'echo "Stopping server..."; kill $SERVER_PID || true' EXIT

echo "Waiting for server to become ready..."
for i in {1..10}; do
  if curl -sSf "http://127.0.0.1:$PORT/" >/dev/null 2>&1; then
    echo "Server ready"
    break
  fi
  sleep 1
done

npm init -y >/dev/null 2>&1 || true
npm i --no-save playwright@latest >/dev/null 2>&1 || true
npx playwright install --with-deps >/dev/null 2>&1 || npx playwright install >/dev/null 2>&1 || true

SITE_URL="http://127.0.0.1:$PORT" node scripts/visual-sample.js "$OUT_DIR"

echo "Uploading screenshots to ./visual-snapshots/"
ls -l "$OUT_DIR" || true

exit 0
