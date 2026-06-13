#!/usr/bin/env bash
set -euo pipefail

BASE_URL="${1:-${DEMO_BASE_URL:-http://localhost:5000}}"
MODE="${2:-normal}"
REQUESTS="${3:-20}"

if [[ "$MODE" != "normal" && "$MODE" != "suspicious" ]]; then
  echo "Usage: $0 <base-url> [normal|suspicious] [request-count]"
  exit 1
fi

success=0
blocked=0
total_time=0

for ((i=1; i<=REQUESTS; i++)); do
  if [[ "$MODE" == "suspicious" ]]; then
    result=$(curl -sS -o /dev/null -w "%{http_code} %{time_total}" -A "demo-scanner" -H "x-demo-traffic: suspicious" "$BASE_URL/api/weather")
  else
    result=$(curl -sS -o /dev/null -w "%{http_code} %{time_total}" -A "Mozilla/5.0 Demo Browser" "$BASE_URL/api/weather")
  fi

  status=$(awk '{print $1}' <<<"$result")
  duration=$(awk '{print $2}' <<<"$result")
  total_time=$(awk -v total="$total_time" -v add="$duration" 'BEGIN{printf "%.6f", total + add}')

  if [[ "$status" =~ ^2|3 ]]; then
    success=$((success + 1))
  fi

  if [[ "$status" == "403" || "$status" == "429" ]]; then
    blocked=$((blocked + 1))
  fi
done

avg_time=$(awk -v total="$total_time" -v count="$REQUESTS" 'BEGIN{if(count==0){print "0.000"} else {printf "%.3f", total/count}}')

echo "Mode: $MODE"
echo "Total requests: $REQUESTS"
echo "Successful responses: $success"
echo "Blocked responses: $blocked"
echo "Average duration: ${avg_time}s"
