#!/usr/bin/env bash
# analyze-har.sh
# Analyze HAR (HTTP Archive) files for FlutterFlow API endpoints
#
# Usage: bash scripts/analyze-har.sh path/to/file.har

set -e

# Check arguments
if [ $# -eq 0 ]; then
  echo "Usage: bash scripts/analyze-har.sh path/to/file.har"
  exit 1
fi

HAR_FILE="$1"

if [ ! -f "$HAR_FILE" ]; then
  echo "[ERROR] File not found: $HAR_FILE"
  exit 1
fi

echo "=================================================="
echo "HAR Analysis for FlutterFlow API Endpoints"
echo "=================================================="
echo "File: $HAR_FILE"
echo "Date: $(date -u +%Y-%m-%dT%H:%M:%SZ)"
echo ""

# Extract all unique endpoints
echo "[1] Extracting All API Endpoints..."
echo ""

ENDPOINTS=$(jq -r '.log.entries[].request.url' "$HAR_FILE" | grep -E "api\.flutterflow\.io|flutterflow\.io" | sort -u)

if [ -z "$ENDPOINTS" ]; then
  echo "[WARN] No FlutterFlow API endpoints found in HAR file"
  echo "[INFO] This might be expected if traffic was captured before API calls occurred"
  exit 0
fi

echo "Found $(echo "$ENDPOINTS" | wc -l) unique FlutterFlow endpoints:"
echo ""
echo "$ENDPOINTS"
echo ""

# Look for POST/PUT requests (mutations)
echo "[2] Identifying Mutation Requests (POST/PUT)..."
echo ""

jq -r '.log.entries[] | select(.request.method == "POST" or .request.method == "PUT") | select(.request.url | contains("flutterflow.io")) | "\(.request.method) \(.request.url)"' "$HAR_FILE" | sort -u

echo ""

# Search for suspicious keywords in URLs
echo "[3] Searching for Create/Action Keywords in URLs..."
echo ""

KEYWORDS=("create" "add" "trigger" "action" "mutate" "update" "generate")

for KEYWORD in "${KEYWORDS[@]}"; do
  MATCHES=$(echo "$ENDPOINTS" | grep -i "$KEYWORD" || true)
  if [ -n "$MATCHES" ]; then
    echo "Keyword '$KEYWORD' found in:"
    echo "$MATCHES"
    echo ""
  fi
done

# Search for file key patterns in responses
echo "[4] Searching for File Key Patterns (id-XXXXXXXX) in Responses..."
echo ""

FILE_KEY_PATTERN='id-[a-zA-Z0-9]{8}'

jq -r --arg pattern "$FILE_KEY_PATTERN" '
  .log.entries[] |
  select(.response.content.text != null) |
  select(.response.content.text | test($pattern)) |
  "URL: \(.request.url)\nMethod: \(.request.method)\nStatus: \(.response.status)\n---"
' "$HAR_FILE" | head -50

echo ""

# Check for new file keys (from experiment context)
echo "[5] Checking for Trigger Action File Keys..."
echo ""

TRIGGER_PATTERN='trigger_actions|ON_INIT_STATE|ON_PAGE_LOAD'

jq -r --arg pattern "$TRIGGER_PATTERN" '
  .log.entries[] |
  select(.response.content.text != null) |
  select(.response.content.text | test($pattern; "i")) |
  "URL: \(.request.url)\nMethod: \(.request.method)\nResponse Preview: \(.response.content.text[:200])...\n---"
' "$HAR_FILE" | head -30

echo ""

# Summary of request types
echo "[6] Request Type Summary..."
echo ""

echo "Total Requests: $(jq '.log.entries | length' "$HAR_FILE")"
echo "GET Requests: $(jq '.log.entries[] | select(.request.method == "GET") | .request.url' "$HAR_FILE" | wc -l)"
echo "POST Requests: $(jq '.log.entries[] | select(.request.method == "POST") | .request.url' "$HAR_FILE" | wc -l)"
echo "PUT Requests: $(jq '.log.entries[] | select(.request.method == "PUT") | .request.url' "$HAR_FILE" | wc -l)"
echo "DELETE Requests: $(jq '.log.entries[] | select(.request.method == "DELETE") | .request.url' "$HAR_FILE" | wc -l)"
echo ""

# Known endpoints (for comparison)
echo "[7] Comparing with Known Endpoints..."
echo ""

KNOWN_ENDPOINTS=(
  "/v2/listPartitionedFileNames"
  "/v2/projectYamls"
  "/v2/validateProjectYaml"
  "/v2/updateProjectByYaml"
  "/v2/syncCustomCodeChanges"
  "/v2/l/listProjects"
)

echo "Known endpoints found in HAR:"
for ENDPOINT in "${KNOWN_ENDPOINTS[@]}"; do
  COUNT=$(echo "$ENDPOINTS" | grep -c "$ENDPOINT" || echo "0")
  if [ "$COUNT" -gt 0 ]; then
    echo "  ✓ $ENDPOINT (count: $COUNT)"
  fi
done

echo ""
echo "Potentially NEW/undocumented endpoints:"
for ENDPOINT_URL in $(echo "$ENDPOINTS"); do
  IS_KNOWN=0
  for KNOWN in "${KNOWN_ENDPOINTS[@]}"; do
    if echo "$ENDPOINT_URL" | grep -q "$KNOWN"; then
      IS_KNOWN=1
      break
    fi
  done

  if [ $IS_KNOWN -eq 0 ]; then
    echo "  → $ENDPOINT_URL"
  fi
done

echo ""

# Generate detailed report for POST requests to API
echo "[8] Detailed Report: POST Requests to /v2/ Endpoints..."
echo ""

jq -r '
  .log.entries[] |
  select(.request.method == "POST") |
  select(.request.url | contains("/v2/")) |
  "
  ======================================
  URL: \(.request.url)
  Method: \(.request.method)
  Status: \(.response.status) \(.response.statusText)
  Time: \(.startedDateTime)

  Request Headers (Auth):
  \(.request.headers[] | select(.name == "Authorization" or .name == "authorization") | "  \(.name): \(.value[:50])...")

  Request Body (first 300 chars):
  \(.request.postData.text[:300] // "N/A")...

  Response (first 300 chars):
  \(.response.content.text[:300] // "N/A")...
  ======================================
  "
' "$HAR_FILE"

echo ""
echo "=================================================="
echo "Analysis Complete"
echo "=================================================="
echo ""
echo "Next Steps:"
echo "  1. Review NEW endpoints above for create/mutation operations"
echo "  2. Check POST request details for file key generation patterns"
echo "  3. Test any discovered endpoints programmatically"
echo "  4. Update EXPERIMENTS.md with findings"
echo ""
