#!/usr/bin/env bash
set -euo pipefail

BASE_URL="${1:-${DEMO_BASE_URL:-http://localhost:5000}}"

echo "Resetting demo state..."
echo "No persistent application state is stored by this demo."
echo "If Cloudflare cache is enabled, purge cache from Cloudflare dashboard/API for immediate reset."

echo "Checking local health endpoint: $BASE_URL/api/health"
curl -sS "$BASE_URL/api/health" || true

echo
echo "Demo reset complete."
