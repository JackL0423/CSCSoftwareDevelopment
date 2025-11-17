#!/usr/bin/env bash
# Bulk YAML update using ZIP upload (26-53% more efficient than JSON)
# Usage: bulk-update-zip.sh file-key1 file-key2 file-key3 ...
# Environment: BATCH_SIZE (default: 24), MAX_RETRIES (default: 4)

set -euo pipefail

BATCH_SIZE="${BATCH_SIZE:-24}"
MAX_RETRIES="${MAX_RETRIES:-4}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Source common functions (includes calc_backoff)
source "$SCRIPT_DIR/utilities/common-functions.sh"

# FlutterFlow configuration
PROJECT_ID="${PROJECT_ID:-c-s-c305-capstone-khj14l}"
API_BASE="https://api.flutterflow.io/v2"

# Ensure directories exist
mkdir -p logs tmp/bulk-verify-zip

# Get API token
get_token() {
  gcloud secrets versions access latest \
    --secret="FLUTTERFLOW_LEAD_API_TOKEN" \
    --project=csc305project-475802 2>/dev/null
}

# Upload batch via ZIP
upload_batch_zip() {
  local batch_num=$1
  shift
  local files=("$@")
  local attempt=1

  echo "=== Batch $batch_num: ${#files[@]} files (ZIP method) ==="

  # Verify all files exist
  for file_key in "${files[@]}"; do
    local yaml_file="flutterflow-yamls/${file_key}.yaml"
    if [ ! -f "$yaml_file" ]; then
      echo "  ✗ File not found: $yaml_file"
      return 1
    fi
  done

  while [ $attempt -le $MAX_RETRIES ]; do
    # Create ZIP file
    local zip_path="/tmp/bulk-batch-${batch_num}.zip"
    rm -f "$zip_path"

    cd flutterflow-yamls
    zip -q "$zip_path" $(printf '%s.yaml ' "${files[@]}") 2>/dev/null || {
      echo "  ✗ Failed to create ZIP"
      cd ..
      return 1
    }
    cd ..

    local zip_size=$(stat -c%s "$zip_path")

    # Encode to base64
    local zip_b64=$(base64 -w 0 "$zip_path")
    local b64_size=${#zip_b64}

    # Create payload
    local payload=$(jq -n \
      --arg pid "$PROJECT_ID" \
      --arg zip "$zip_b64" \
      '{projectId: $pid, projectYamlBytes: $zip}')

    # Save payload for debugging
    echo "$payload" > "logs/payload-zip-batch-${batch_num}.json"
    local payload_size=$(echo "$payload" | wc -c)

    echo "  ZIP size: $zip_size bytes ($(echo "scale=2; $zip_size/1024" | bc) KB)"
    echo "  Payload size: $payload_size bytes ($(echo "scale=2; $payload_size/1024" | bc) KB)"
    echo "  Attempt: $attempt/$MAX_RETRIES"

    # Upload
    local response=$(curl -sS -X POST "${API_BASE}/updateProjectByYaml" \
      -H "Authorization: Bearer ${LEAD_TOKEN}" \
      -H "Content-Type: application/json" \
      -d "$payload" \
      -w '\nHTTP_CODE:%{http_code}\n')

    echo "$response" > "logs/resp-zip-batch-${batch_num}.json"
    local http_code=$(echo "$response" | grep "HTTP_CODE:" | cut -d: -f2)

    if echo "$response" | grep -q '"success":true'; then
      echo "  ✅ Upload succeeded (HTTP $http_code)"
      rm -f "$zip_path"
      return 0
    else
      echo "  ✗ Upload failed (HTTP $http_code)"

      if [ $attempt -lt $MAX_RETRIES ]; then
        local backoff=$(calc_backoff $attempt)
        echo "  Retrying in ${backoff}s..."
        sleep "$backoff"
      fi
    fi

    attempt=$((attempt + 1))
    rm -f "$zip_path"
  done

  echo "  ❌ Batch failed after $MAX_RETRIES attempts"
  return 1
}

# Verify batch (sequential to avoid rate limiting)
verify_batch() {
  local batch_num=$1
  shift
  local files=("$@")
  local failed=0

  echo "  Verifying batch (sequential to avoid rate limits)..."

  for file_key in "${files[@]}"; do
    local original="flutterflow-yamls/${file_key}.yaml"
    local downloaded="tmp/bulk-verify-zip/${file_key}.yaml"
    local diff_log="logs/diff-zip-batch-${batch_num}-${file_key//\//-}.txt"
    local tmp_json="$(mktemp)"

    # Download with retry
    local dl_attempt=0
    local dl_success=false

    while [ $dl_attempt -lt 3 ]; do
      local response=$(curl -sS "${API_BASE}/projectYamls?projectId=${PROJECT_ID}&fileName=${file_key}" \
        -H "Authorization: Bearer ${LEAD_TOKEN}" 2>/dev/null)

      if echo "$response" | jq -r '.value.projectYamlBytes // .value.project_yaml_bytes' > "$tmp_json" 2>/dev/null; then
        if [ -s "$tmp_json" ] && [ "$(cat "$tmp_json")" != "null" ]; then
          cat "$tmp_json" | base64 -d > "${downloaded}.zip" 2>/dev/null
          mkdir -p "$(dirname "$downloaded")"

          # Try to extract YAML from ZIP
          if unzip -p "${downloaded}.zip" "${file_key}.yaml" > "$downloaded" 2>/dev/null || \
             unzip -p "${downloaded}.zip" > "$downloaded" 2>/dev/null; then
            rm -f "${downloaded}.zip"

            # Check if file has content
            if [ -s "$downloaded" ]; then
              dl_success=true
              break
            fi
          fi
        fi
      fi

      # Backoff before retry
      dl_attempt=$((dl_attempt + 1))
      if [ $dl_attempt -lt 3 ]; then
        sleep 2
      fi
    done

    rm -f "$tmp_json"

    if [ "$dl_success" = false ]; then
      echo "    ✗ $file_key (download failed after 3 attempts)"
      failed=1
      continue
    fi

    # Diff
    if diff -u "$original" "$downloaded" > "$diff_log" 2>&1; then
      echo "    ✓ $file_key (verified)"
    else
      echo "    ✗ $file_key (diff has content - verification FAILED)"
      failed=1
    fi

    # Small delay to avoid rate limiting
    sleep 0.2
  done

  return $failed
}

# Main
main() {
  if [ $# -eq 0 ]; then
    cat << EOF
Usage: $0 file-key1 file-key2 ...

Bulk upload FlutterFlow YAML files using ZIP compression (26-53% more efficient than JSON).

Environment:
  BATCH_SIZE   - Files per batch (default: 24, proven stable)
  MAX_RETRIES  - Retry attempts per batch (default: 4)

Example:
  BATCH_SIZE=24 $0 app-state api app-details ... (3+ files)

Features:
  - ZIP compression (26-53% smaller payloads vs JSON)
  - Less prone to rate limiting (smaller transfers)
  - Automatic retry with jittered exponential backoff
  - Sequential verification to avoid rate limits
  - Exits non-zero if ANY verification fails

Performance:
  - 10 files: 5.1 KB payload (vs 6.9 KB JSON) - 26% smaller
  - 24 files: 12.6 KB payload (vs 27.0 KB JSON) - 53% smaller

EOF
    exit 1
  fi

  echo "=== FlutterFlow Bulk Update (ZIP Method) ==="
  echo "Files to upload: $#"
  echo "Batch size: $BATCH_SIZE"
  echo "Max retries: $MAX_RETRIES"
  echo ""

  # Get token
  echo "Retrieving API token..."
  LEAD_TOKEN=$(get_token)
  if [ -z "$LEAD_TOKEN" ]; then
    echo "❌ Failed to retrieve API token"
    exit 1
  fi
  export LEAD_TOKEN

  # Process in batches
  local batch_num=1
  local batch=()
  local total_failed=0

  for file_key in "$@"; do
    batch+=("$file_key")

    if [ ${#batch[@]} -eq $BATCH_SIZE ]; then
      # Upload batch
      if upload_batch_zip $batch_num "${batch[@]}"; then
        # Verify batch
        if verify_batch $batch_num "${batch[@]}"; then
          echo "  ✅ Batch $batch_num verified"
        else
          echo "  ❌ Batch $batch_num verification failed"
          total_failed=$((total_failed + 1))
        fi
      else
        echo "  ❌ Batch $batch_num upload failed"
        total_failed=$((total_failed + 1))
      fi

      echo ""
      batch=()
      batch_num=$((batch_num + 1))
    fi
  done

  # Process remaining files
  if [ ${#batch[@]} -gt 0 ]; then
    if upload_batch_zip $batch_num "${batch[@]}"; then
      if verify_batch $batch_num "${batch[@]}"; then
        echo "  ✅ Batch $batch_num verified"
      else
        echo "  ❌ Batch $batch_num verification failed"
        total_failed=$((total_failed + 1))
      fi
    else
      echo "  ❌ Batch $batch_num upload failed"
      total_failed=$((total_failed + 1))
    fi
    echo ""
  fi

  # Summary
  echo "========================================="
  if [ $total_failed -eq 0 ]; then
    echo "✅ All batches uploaded and verified successfully!"
    echo ""
    echo "Diff logs (should all be empty):"
    find logs -name "diff-zip-batch-*.txt" -type f -exec ls -lh {} \; | head -20
    exit 0
  else
    echo "❌ $total_failed batch(es) failed"
    echo ""
    echo "Check logs for details:"
    echo "  - Payloads: logs/payload-zip-batch-*.json"
    echo "  - Responses: logs/resp-zip-batch-*.json"
    echo "  - Diffs: logs/diff-zip-batch-*.txt"
    exit 1
  fi
}

main "$@"
