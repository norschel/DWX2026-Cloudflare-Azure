#!/usr/bin/env bash
set -euo pipefail

BASE_URL="${1:-${DEMO_BASE_URL:-http://localhost:5000}}"
RUNS="${2:-5}"

printf "%-6s %-8s %-10s %-18s %-6s %-8s\n" "Run" "Status" "Duration" "CF-Cache-Status" "Age" "Origin"

for ((i=1; i<=RUNS; i++)); do
  headers_file=$(mktemp)
  result=$(curl -sS -D "$headers_file" -o /dev/null -w "%{http_code} %{time_total}" "$BASE_URL/api/products")

  status=$(awk '{print $1}' <<<"$result")
  duration=$(awk '{printf "%.3fs", $2}' <<<"$result")
  cf_cache_status=$(grep -i '^cf-cache-status:' "$headers_file" | tail -n 1 | cut -d: -f2- | tr -d '\r' | xargs || true)
  age=$(grep -i '^age:' "$headers_file" | tail -n 1 | cut -d: -f2- | tr -d '\r' | xargs || true)
  origin=$(grep -i '^x-demo-origin:' "$headers_file" | tail -n 1 | cut -d: -f2- | tr -d '\r' | xargs || true)

  cf_cache_status=${cf_cache_status:-n/a}
  age=${age:-n/a}
  origin=${origin:-n/a}

  printf "%-6s %-8s %-10s %-18s %-6s %-8s\n" "$i" "$status" "$duration" "$cf_cache_status" "$age" "$origin"
  rm -f "$headers_file"
  sleep 1
done
