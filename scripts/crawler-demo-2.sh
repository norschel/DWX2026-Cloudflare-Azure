#!/usr/bin/env bash
set -euo pipefail

BASE_URL="${1:-${DEMO_BASE_URL:-http://localhost:5000}}"

USER_AGENTS=(
  "Mozilla/5.0 Demo Browser"
  "GPTBot"
  "ClaudeBot"
  "PerplexityBot"
  "Googlebot"
  "Bingbot"
  "curl/8.0"
  "python-requests/2.31"
)

printf "%-28s %-12s %-22s %-10s\n" "User-Agent" "HTTP Status" "Detected Category" "Duration"

for ua in "${USER_AGENTS[@]}"; do
  headers_file=$(mktemp)
  result=$(curl -sS -D "$headers_file" -o /dev/null -w "%{http_code} %{time_total}" -A "$ua" "$BASE_URL/api/crawler-check")

  status=$(awk '{print $1}' <<<"$result")
  duration=$(awk '{printf "%.3fs", $2}' <<<"$result")
  category=$(grep -i '^x-demo-client-category:' "$headers_file" | tail -n 1 | cut -d: -f2- | tr -d '\r' | xargs || true)

  if [[ -z "$category" ]]; then
    if [[ "$status" == "403" ]]; then
      category="edge-blocked"
    else
      category="unknown"
    fi
  fi

  printf "%-28s %-12s %-22s %-10s\n" "$ua" "$status" "$category" "$duration"
  rm -f "$headers_file"
done
