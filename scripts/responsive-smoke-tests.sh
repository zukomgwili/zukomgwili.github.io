#!/usr/bin/env bash
set -euo pipefail

SITE_DIR="${1:-_site}"
PORT="${2:-4000}"

if [ ! -d "$SITE_DIR" ]; then
  echo "Site directory '$SITE_DIR' not found — build it first or pass the correct path" >&2
  exit 2
fi

echo "Starting static server for responsive smoke tests (serving $SITE_DIR on port $PORT)"
python3 -m http.server "$PORT" -d "$SITE_DIR" &
SERVER_PID=$!
trap 'echo "Stopping server..."; kill $SERVER_PID || true' EXIT

sleep 1

echo "Installing Playwright (temporary)"
npm init -y >/dev/null 2>&1 || true
npm i --no-save playwright@latest >/dev/null 2>&1
node scripts/responsive-smoke.js || {
  echo "Responsive smoke tests failed" >&2
  exit 1
}

echo "Responsive smoke tests passed"
exit 0
