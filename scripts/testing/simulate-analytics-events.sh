#!/usr/bin/env bash
set -euo pipefail

# Simulate GA4 events via Measurement Protocol for a mobile app stream.
# Requires MEASUREMENT_ID, API_SECRET, and APP_INSTANCE_ID (from a real device).
#
# Usage:
#   export MEASUREMENT_ID=G-XXXXXXX
#   export API_SECRET=your_secret
#   export APP_INSTANCE_ID=from_device
#   scripts/simulate-analytics-events.sh --events 50 --days 7 --debug

EVENTS=20
DAYS=7
DEBUG=false

while [[ $# -gt 0 ]]; do
  case "$1" in
    --events) EVENTS="$2"; shift 2;;
    --days) DAYS="$2"; shift 2;;
    --debug) DEBUG=true; shift;;
    *) echo "Unknown arg: $1"; exit 2;;
  esac
done

if [[ -z "${MEASUREMENT_ID:-}" || -z "${API_SECRET:-}" || -z "${APP_INSTANCE_ID:-}" ]]; then
  echo "Error: MEASUREMENT_ID, API_SECRET, and APP_INSTANCE_ID environment variables are required."
  exit 1
fi

endpoint="https://www.google-analytics.com/mp/collect?measurement_id=${MEASUREMENT_ID}&api_secret=${API_SECRET}"

send_event() {
  local name="$1"
  local timestampMicros="$2"
  local params_json="$3"
  local body
  body=$(cat <<JSON
{
  "app_instance_id": "${APP_INSTANCE_ID}",
  "timestamp_micros": "${timestampMicros}",
  "events": [
    { "name": "${name}", "params": ${params_json} }
  ]
}
JSON
)
  if [[ "$DEBUG" == true ]]; then
    echo "POST ${endpoint} -> ${name} @ ${timestampMicros}"
    echo "$body"
  fi
  curl -sS -X POST -H 'Content-Type: application/json' -d "$body" "$endpoint" >/dev/null
}

now_ms=$(date +%s%3N)
# distribute events over DAYS in the past
for i in $(seq 1 "$EVENTS"); do
  offset_days=$((RANDOM % DAYS))
  # random time during that day
  hour=$((RANDOM % 24))
  min=$((RANDOM % 60))
  sec=$((RANDOM % 60))
  ts=$(date -d "-$offset_days day $hour:$min:$sec" +%s)
  ts_us=$((ts*1000000))

  if (( i % 2 )); then
    # session_start
    params='{"session_id":"mp_sim_'"$i"'","is_debug":"1"}'
    send_event "session_start" "$ts_us" "$params"
  else
    # recipe_complete
    rid=$((RANDOM % 1000))
    params='{"recipe_id":"mp_'"$rid"'","cuisine":"seed","prep_time_bucket":"0-30min","source":"seed","completion_method":"sim","is_debug":"1"}'
    send_event "recipe_complete" "$ts_us" "$params"
  fi
done

echo "Pushed ${EVENTS} events over last ${DAYS} days via Measurement Protocol."
#!/usr/bin/env bash
set -euo pipefail

# Simulate GA4 Analytics events via Measurement Protocol
# WARNING: For Firebase App streams, you need app_instance_id from a real device
# Requirements:
#   - MEASUREMENT_ID and API_SECRET env vars (GA4 Data Stream)
#   - APP_INSTANCE_ID env var (from device) OR INSTALLATION_ID + FIREBASE_APP_ID
#   - --debug to send to debug endpoint
#
# Usage:
#   scripts/simulate-analytics-events.sh --events 10 --days 7 --debug

EVENTS=50
DAYS=7
DEBUG=false

while [[ $# -gt 0 ]]; do
  case "$1" in
    --events) EVENTS="$2"; shift 2;;
    --days) DAYS="$2"; shift 2;;
    --debug) DEBUG=true; shift;;
    *) echo "Unknown arg: $1"; exit 2;;
  esac
done

if [[ -z "${MEASUREMENT_ID:-}" || -z "${API_SECRET:-}" ]]; then
  echo "Missing MEASUREMENT_ID or API_SECRET. Set both env vars."
  exit 1
fi

ENDPOINT="https://www.google-analytics.com/mp/collect"
[[ "$DEBUG" == true ]] && ENDPOINT="https://www.google-analytics.com/debug/mp/collect"

if [[ -z "${APP_INSTANCE_ID:-}" && (-z "${FIREBASE_APP_ID:-}" || -z "${INSTALLATION_ID:-}") ]]; then
  cat <<EOF
Error: APP_INSTANCE_ID not provided.
For Firebase app streams, events must include app_instance_id (preferred) or installation_id + firebase_app_id.
Tips:
  - Connect a device, run the app with debug enabled, and read app_instance_id from DebugView device stream.
  - Or prefer validating events on real device via ./scripts/tail-analytics.sh.
EOF
  exit 1
fi

post_events() {
  local name="$1"; shift
  local timestamp_micros="$1"; shift
  local payload
  if [[ -n "${APP_INSTANCE_ID:-}" ]]; then
    payload=$(jq -n --arg ai "$APP_INSTANCE_ID" --arg ts "$timestamp_micros" --arg n "$name" '{app_instance_id:$ai, timestamp_micros: ($ts|tonumber), non_personalized_ads:true, events:[{name:$n, params:{debug_mode:1}}] }')
  else
    payload=$(jq -n --arg fid "$INSTALLATION_ID" --arg app "$FIREBASE_APP_ID" --arg ts "$timestamp_micros" --arg n "$name" '{firebase_app_id:$app, installation_id:$fid, timestamp_micros: ($ts|tonumber), non_personalized_ads:true, events:[{name:$n, params:{debug_mode:1}}] }')
  fi
  curl -sS -X POST "$ENDPOINT?measurement_id=$MEASUREMENT_ID&api_secret=$API_SECRET" \
    -H 'Content-Type: application/json' \
    -d "$payload" | jq . || true
}

echo "Sending $EVENTS events over $DAYS days to $ENDPOINT ..."
now_ts=$(date +%s)

for i in $(seq 1 "$EVENTS"); do
  # random event type
  ev="session_start"
  [[ $((RANDOM%2)) -eq 0 ]] && ev="recipe_complete"
  # distribute over last N days
  day_offset=$(( RANDOM % DAYS ))
  sec_offset=$(( RANDOM % 86400 ))
  ts=$(( (now_ts - day_offset*86400 - sec_offset) * 1000000 ))
  post_events "$ev" "$ts"
  sleep 0.2
done

echo "Done. Review DebugView if --debug was used."
