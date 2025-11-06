#!/usr/bin/env bash
set -euo pipefail

# End-to-end verification for retention metrics
# - Firestore collection counts
# - Analytics logcat tail (optional)
# - Cloud Functions metrics query
#
# Usage:
#   scripts/verify-metrics-flow.sh --cohort-date YYYY-MM-DD [--project csc-305-dev-project] [--report]

PROJECT_ID="${PROJECT_ID:-csc-305-dev-project}"
COHORT_DATE=""
REPORT=false

while [[ $# -gt 0 ]]; do
  case "$1" in
    --project) PROJECT_ID="$2"; shift 2;;
    --cohort-date) COHORT_DATE="$2"; shift 2;;
    --report) REPORT=true; shift;;
    *) echo "Unknown arg: $1"; exit 2;;
  esac
done

pass=true
summary=()

have_firebase=false
if command -v firebase >/dev/null 2>&1; then
  have_firebase=true
fi

have_jq=false
if command -v jq >/dev/null 2>&1; then
  have_jq=true
fi

# Firestore checks
if [[ "$have_firebase" == true ]]; then
  echo "Checking Firestore collections in $PROJECT_ID ..."
  users_json=$(firebase firestore:get users --project="$PROJECT_ID" 2>/dev/null || echo '{}')
  compl_json=$(firebase firestore:get user_recipe_completions --project="$PROJECT_ID" 2>/dev/null || echo '{}')
  if [[ "$have_jq" == true ]]; then
    users_count=$(echo "$users_json" | jq 'paths | select(length==1) | length' 2>/dev/null || echo 0)
    compl_count=$(echo "$compl_json" | jq 'paths | select(length==1) | length' 2>/dev/null || echo 0)
  else
    users_count=$(echo "$users_json" | wc -l)
    compl_count=$(echo "$compl_json" | wc -l)
  fi
  summary+=("Firestore: ${users_count} users, ${compl_count} completions")
else
  summary+=("Firestore: Skipped (firebase CLI not found)")
  pass=false
fi

# Analytics via logcat (optional, requires connected device)
if command -v adb >/dev/null 2>&1; then
  echo "Checking Analytics via adb logcat (5s sample)..."
  set +e
  out=$(timeout 5s adb logcat -v brief | grep -Ei 'FA|FirebaseAnalytics|Analytics|session_start|recipe_complete' | head -n 50)
  set -e
  if [[ -n "$out" ]]; then
    summary+=("Analytics: Events observed in logcat sample")
  else
    summary+=("Analytics: No events observed in 5s sample (device idle?)")
  fi
else
  summary+=("Analytics: Skipped (adb not found)")
fi

# Cloud Functions query
if [[ -n "$COHORT_DATE" ]]; then
  url="https://us-central1-${PROJECT_ID}.cloudfunctions.net/getD7RetentionMetrics?cohortDate=${COHORT_DATE}"
  echo "Querying Cloud Function: $url"
  set +e
  resp=$(curl -sS "$url")
  code=$?
  set -e
  if [[ $code -eq 0 && -n "$resp" ]]; then
    if [[ "$have_jq" == true ]]; then
      rate=$(echo "$resp" | jq -r '.d7_repeat_recipe_rate // .rate // empty')
      summary+=("Cloud Functions: Response OK (rate=${rate:-unknown})")
    else
      summary+=("Cloud Functions: Response OK")
    fi
  else
    summary+=("Cloud Functions: Request failed")
    pass=false
  fi
else
  summary+=("Cloud Functions: Skipped (no --cohort-date)")
fi

if [[ "$REPORT" == true ]]; then
  echo ""
  for line in "${summary[@]}"; do
    if [[ "$line" == *"OK"* || "$line" == Firestore:* || "$line" == Analytics:* ]]; then
      echo "✅ $line"
    else
      echo "❌ $line"
    fi
  done
fi

if [[ "$pass" == true ]]; then
  exit 0
else
  exit 1
fi
