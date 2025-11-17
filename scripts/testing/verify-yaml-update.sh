#!/usr/bin/env bash
# verify-yaml-update.sh
# Post-condition verification for YAML update operations
# Addresses Risk R1: Silent success (API returns success but no changes persist)
#
# Usage:
#   source scripts/verify-yaml-update.sh
#   verify_yaml_update "$PROJECT_ID" "$FILE_KEY" "$TOKEN" "/tmp/before.txt" "/tmp/after.txt"
#
# Returns:
#   0 - Verification passed (file exists and changed)
#   1 - Verification failed (file missing or unchanged)
#   2 - Error (API call failed)

# Print tool versions for reproducibility
print_tool_versions() {
  echo "[INFO] Tool versions:"
  curl --version | head -1
  jq --version
  echo "base64: $(base64 --version | head -1)"
  echo ""
}

# Verify that a YAML update succeeded by checking:
# 1. File key exists in project
# 2. YAML content changed (checksum different)
#
# Arguments:
#   $1 - PROJECT_ID
#   $2 - FILE_KEY (e.g., "app-state", "page/id-Scaffold_xyz/...")
#   $3 - AUTH_TOKEN
#   $4 - BEFORE_FILE (path to file containing "before" file list)
#   $5 - AFTER_FILE (path to file containing "after" file list)
#   $6 - CHECKSUM_BEFORE (optional, for existing file updates)
#
# Returns:
#   0 - Success
#   1 - Failure (file not found or unchanged)
#   2 - Error
verify_yaml_update() {
  local PROJECT_ID="$1"
  local FILE_KEY="$2"
  local TOKEN="$3"
  local BEFORE_FILE="$4"
  local AFTER_FILE="$5"
  local CHECKSUM_BEFORE="$6"  # Optional

  # Validate inputs
  if [ -z "$PROJECT_ID" ] || [ -z "$FILE_KEY" ] || [ -z "$TOKEN" ]; then
    echo "[ERROR] Missing required arguments"
    echo "Usage: verify_yaml_update PROJECT_ID FILE_KEY TOKEN BEFORE_FILE AFTER_FILE [CHECKSUM_BEFORE]"
    return 2
  fi

  echo "[VERIFY] Checking if file key exists: $FILE_KEY"

  # Check if file key exists in after list
  if ! grep -qFx "$FILE_KEY" "$AFTER_FILE"; then
    echo "[FAIL] File key not found in project after update"
    echo "[FAIL] Expected: $FILE_KEY"
    echo "[INFO] Diff between before/after:"
    diff "$BEFORE_FILE" "$AFTER_FILE" | head -20
    return 1
  fi

  echo "[VERIFY] File key exists: OK"

  # If this was an update to existing file, verify checksum changed
  if [ -n "$CHECKSUM_BEFORE" ]; then
    echo "[VERIFY] Checking if YAML content changed..."

    # Download YAML and calculate checksum
    local YAML_CONTENT
    YAML_CONTENT=$(curl -sS "https://api.flutterflow.io/v2/projectYamls?projectId=${PROJECT_ID}&fileName=${FILE_KEY}" \
      -H "Authorization: Bearer ${TOKEN}" \
      -H "Content-Type: application/json" \
    | jq -r '.value.projectYamlBytes // .value.project_yaml_bytes' \
    | base64 -d 2>/dev/null)

    if [ -z "$YAML_CONTENT" ]; then
      echo "[ERROR] Failed to download YAML for checksum verification"
      return 2
    fi

    # Calculate new checksum (using sha256)
    local CHECKSUM_AFTER
    CHECKSUM_AFTER=$(echo "$YAML_CONTENT" | sha256sum | awk '{print $1}')

    if [ "$CHECKSUM_BEFORE" = "$CHECKSUM_AFTER" ]; then
      echo "[FAIL] YAML content unchanged (checksum identical)"
      echo "[FAIL] Checksum: $CHECKSUM_AFTER"
      return 1
    fi

    echo "[VERIFY] YAML content changed: OK"
    echo "[INFO] Checksum before: $CHECKSUM_BEFORE"
    echo "[INFO] Checksum after:  $CHECKSUM_AFTER"
  fi

  echo "[SUCCESS] Verification passed"
  return 0
}

# Capture project file list before an operation
# Saves to specified file
#
# Arguments:
#   $1 - PROJECT_ID
#   $2 - AUTH_TOKEN
#   $3 - OUTPUT_FILE (where to save file list)
#
# Returns:
#   0 - Success
#   2 - Error
capture_file_list() {
  local PROJECT_ID="$1"
  local TOKEN="$2"
  local OUTPUT_FILE="$3"

  if [ -z "$PROJECT_ID" ] || [ -z "$TOKEN" ] || [ -z "$OUTPUT_FILE" ]; then
    echo "[ERROR] Missing required arguments"
    echo "Usage: capture_file_list PROJECT_ID TOKEN OUTPUT_FILE"
    return 2
  fi

  echo "[INFO] Capturing file list to: $OUTPUT_FILE"

  curl -sS "https://api.flutterflow.io/v2/listPartitionedFileNames?projectId=${PROJECT_ID}" \
    -H "Authorization: Bearer ${TOKEN}" \
    -H "Content-Type: application/json" \
  | jq -r '.value.file_names[]' | sort > "$OUTPUT_FILE"

  local FILE_COUNT
  FILE_COUNT=$(wc -l < "$OUTPUT_FILE")

  if [ "$FILE_COUNT" -eq 0 ]; then
    echo "[ERROR] Failed to capture file list (empty response)"
    return 2
  fi

  echo "[INFO] Captured $FILE_COUNT files"
  return 0
}

# Calculate checksum of a YAML file
#
# Arguments:
#   $1 - PROJECT_ID
#   $2 - FILE_KEY
#   $3 - AUTH_TOKEN
#
# Returns:
#   Checksum (sha256) on stdout
#   Exit code 0 on success, 2 on error
calculate_yaml_checksum() {
  local PROJECT_ID="$1"
  local FILE_KEY="$2"
  local TOKEN="$3"

  if [ -z "$PROJECT_ID" ] || [ -z "$FILE_KEY" ] || [ -z "$TOKEN" ]; then
    echo "[ERROR] Missing required arguments" >&2
    return 2
  fi

  # Download YAML content
  local YAML_CONTENT
  YAML_CONTENT=$(curl -sS "https://api.flutterflow.io/v2/projectYamls?projectId=${PROJECT_ID}&fileName=${FILE_KEY}" \
    -H "Authorization: Bearer ${TOKEN}" \
    -H "Content-Type: application/json" \
  | jq -r '.value.projectYamlBytes // .value.project_yaml_bytes' \
  | base64 -d 2>/dev/null)

  if [ -z "$YAML_CONTENT" ]; then
    echo "[ERROR] Failed to download YAML" >&2
    return 2
  fi

  # Calculate and output checksum
  echo "$YAML_CONTENT" | sha256sum | awk '{print $1}'
  return 0
}

# Complete verification workflow wrapper
# Handles before/after capture and verification
#
# Usage example:
#   verify_update_workflow "$PROJECT_ID" "$FILE_KEY" "$TOKEN" true
#
# Arguments:
#   $1 - PROJECT_ID
#   $2 - FILE_KEY
#   $3 - AUTH_TOKEN
#   $4 - IS_EXISTING_FILE (true/false) - whether to check checksum
#
# Returns:
#   0 - Verification passed
#   1 - Verification failed
#   2 - Error
verify_update_workflow() {
  local PROJECT_ID="$1"
  local FILE_KEY="$2"
  local TOKEN="$3"
  local IS_EXISTING="${4:-false}"

  # Create temp files
  local BEFORE_FILE="/tmp/verify_before_$$.txt"
  local AFTER_FILE="/tmp/verify_after_$$.txt"
  local CHECKSUM_BEFORE=""

  echo "[VERIFY] Starting verification workflow for: $FILE_KEY"
  echo ""

  # Capture before state
  if ! capture_file_list "$PROJECT_ID" "$TOKEN" "$BEFORE_FILE"; then
    echo "[ERROR] Failed to capture before state"
    rm -f "$BEFORE_FILE" "$AFTER_FILE"
    return 2
  fi

  # If updating existing file, get checksum before
  if [ "$IS_EXISTING" = "true" ]; then
    echo "[INFO] Calculating checksum before update..."
    CHECKSUM_BEFORE=$(calculate_yaml_checksum "$PROJECT_ID" "$FILE_KEY" "$TOKEN")
    if [ $? -ne 0 ]; then
      echo "[WARN] Could not calculate before checksum (file may not exist yet)"
      CHECKSUM_BEFORE=""
    else
      echo "[INFO] Before checksum: $CHECKSUM_BEFORE"
    fi
  fi

  echo ""
  echo "[INFO] Perform your update operation now, then this verification will run..."
  echo "[INFO] (In automated scripts, update happens here)"
  echo ""

  # NOTE: In actual usage, the UPDATE operation happens here
  # This function is meant to be called AFTER the update completes

  # Capture after state
  if ! capture_file_list "$PROJECT_ID" "$TOKEN" "$AFTER_FILE"; then
    echo "[ERROR] Failed to capture after state"
    rm -f "$BEFORE_FILE" "$AFTER_FILE"
    return 2
  fi

  # Verify
  local RESULT
  verify_yaml_update "$PROJECT_ID" "$FILE_KEY" "$TOKEN" "$BEFORE_FILE" "$AFTER_FILE" "$CHECKSUM_BEFORE"
  RESULT=$?

  # Cleanup
  rm -f "$BEFORE_FILE" "$AFTER_FILE"

  return $RESULT
}

# Export functions for sourcing
export -f verify_yaml_update
export -f capture_file_list
export -f calculate_yaml_checksum
export -f verify_update_workflow
export -f print_tool_versions

# If script is executed directly (not sourced), run a test
if [ "${BASH_SOURCE[0]}" = "${0}" ]; then
  echo "verify-yaml-update.sh - YAML Update Verification Library"
  echo ""
  echo "This script provides verification functions for FlutterFlow API updates."
  echo ""
  echo "Usage:"
  echo "  source scripts/verify-yaml-update.sh"
  echo ""
  echo "Available functions:"
  echo "  - verify_yaml_update: Core verification logic"
  echo "  - capture_file_list: Capture project file list"
  echo "  - calculate_yaml_checksum: Get SHA256 checksum of YAML"
  echo "  - verify_update_workflow: Complete before/after verification"
  echo "  - print_tool_versions: Print tool versions"
  echo ""
  echo "Example:"
  echo "  source scripts/verify-yaml-update.sh"
  echo "  capture_file_list \"\$PROJECT_ID\" \"\$TOKEN\" /tmp/before.txt"
  echo "  # ... perform update ..."
  echo "  capture_file_list \"\$PROJECT_ID\" \"\$TOKEN\" /tmp/after.txt"
  echo "  verify_yaml_update \"\$PROJECT_ID\" \"app-state\" \"\$TOKEN\" /tmp/before.txt /tmp/after.txt"
  echo ""
  print_tool_versions
fi
