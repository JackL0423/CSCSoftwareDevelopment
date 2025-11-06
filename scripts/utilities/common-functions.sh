#!/bin/bash
# common-functions.sh
# Shared functions for FlutterFlow automation scripts
#
# Usage:
#   source scripts/common-functions.sh
#   print_script_header "Script Name" "1.0"
#   verify_tool_versions

# Print standardized script header with tool versions
# Arguments:
#   $1 - Script name
#   $2 - Script version (optional)
print_script_header() {
  local SCRIPT_NAME="$1"
  local SCRIPT_VERSION="${2:-1.0}"

  echo "=============================================="
  echo "$SCRIPT_NAME v$SCRIPT_VERSION"
  echo "Date: $(date -u +%Y-%m-%dT%H:%M:%SZ)"
  echo "=============================================="
  echo ""
}

# Print tool versions for reproducibility
# Addresses Risk R6: Tool version drift
print_tool_versions() {
  echo "[INFO] Tool Versions (for reproducibility):"
  echo "  curl:    $(curl --version 2>&1 | head -1 | awk '{print $2}')"
  echo "  jq:      $(jq --version 2>&1)"
  echo "  base64:  $(base64 --version 2>&1 | head -1 | awk '{print $NF}')"
  echo "  zip:     $(zip -v 2>&1 | grep "This is Zip" | awk '{print $4,$5,$6}' | tr -d ',')"
  echo "  gcloud:  $(gcloud version 2>&1 | grep "Google Cloud SDK" | awk '{print $NF}')"
  echo "  bash:    $BASH_VERSION"
  echo ""
}

# Verify minimum tool versions
# Returns:
#   0 - All tools present
#   1 - Missing required tools
verify_tool_versions() {
  local MISSING=0

  echo "[CHECK] Verifying required tools..."

  # Check curl
  if ! command -v curl &> /dev/null; then
    echo "[ERROR] curl not found (required)"
    MISSING=1
  fi

  # Check jq
  if ! command -v jq &> /dev/null; then
    echo "[ERROR] jq not found (required)"
    MISSING=1
  fi

  # Check base64
  if ! command -v base64 &> /dev/null; then
    echo "[ERROR] base64 not found (required)"
    MISSING=1
  fi

  # Check gcloud
  if ! command -v gcloud &> /dev/null; then
    echo "[ERROR] gcloud not found (required for secrets)"
    MISSING=1
  fi

  if [ $MISSING -eq 1 ]; then
    echo "[ERROR] Missing required tools. Please install them and try again."
    return 1
  fi

  echo "[CHECK] All required tools present"
  echo ""
  return 0
}

# Load FlutterFlow secrets from GCP Secret Manager
# Sets environment variables:
#   FLUTTERFLOW_PROJECT_ID
#   FLUTTERFLOW_LEAD_API_TOKEN
#   TEST_PROJECT_ID (if available)
load_flutterflow_secrets() {
  local GCP_PROJECT="csc305project-475802"
  local GCP_ACCOUNT="juan_vallejo@uri.edu"

  echo "[INFO] Loading FlutterFlow secrets from GCP..."

  # Production project ID
  if [ -z "$FLUTTERFLOW_PROJECT_ID" ]; then
    FLUTTERFLOW_PROJECT_ID=$(gcloud secrets versions access latest \
      --secret="FLUTTERFLOW_PROJECT_ID" \
      --project="$GCP_PROJECT" \
      --account="$GCP_ACCOUNT" 2>/dev/null)

    if [ -z "$FLUTTERFLOW_PROJECT_ID" ]; then
      echo "[ERROR] Failed to load FLUTTERFLOW_PROJECT_ID from GCP"
      return 1
    fi
    export FLUTTERFLOW_PROJECT_ID
  fi

  # API token
  if [ -z "$FLUTTERFLOW_LEAD_API_TOKEN" ]; then
    FLUTTERFLOW_LEAD_API_TOKEN=$(gcloud secrets versions access latest \
      --secret="FLUTTERFLOW_LEAD_API_TOKEN" \
      --project="$GCP_PROJECT" \
      --account="$GCP_ACCOUNT" 2>/dev/null)

    if [ -z "$FLUTTERFLOW_LEAD_API_TOKEN" ]; then
      echo "[ERROR] Failed to load FLUTTERFLOW_LEAD_API_TOKEN from GCP"
      return 1
    fi
    export FLUTTERFLOW_LEAD_API_TOKEN
  fi

  # Test project ID (optional)
  if [ -z "$TEST_PROJECT_ID" ]; then
    TEST_PROJECT_ID=$(gcloud secrets versions access latest \
      --secret="TEST_ID_API" \
      --project="$GCP_PROJECT" \
      --account="$GCP_ACCOUNT" 2>/dev/null)

    if [ -n "$TEST_PROJECT_ID" ]; then
      export TEST_PROJECT_ID
    fi
  fi

  echo "[INFO] Secrets loaded successfully"
  echo "[INFO] Production Project: $FLUTTERFLOW_PROJECT_ID"
  if [ -n "$TEST_PROJECT_ID" ]; then
    echo "[INFO] Test Project: $TEST_PROJECT_ID"
  fi
  echo ""
  return 0
}

# Exponential backoff retry logic
# Arguments:
#   $1 - Command to execute (string)
#   $2 - Max retries (default: 6)
#   $3 - Base delay in ms (default: 300)
#   $4 - Backoff factor (default: 2.0)
#
# Returns:
#   Exit code of command (0 on success)
retry_with_backoff() {
  local COMMAND="$1"
  local MAX_RETRIES="${2:-6}"
  local BASE_DELAY="${3:-300}"
  local FACTOR="${4:-2.0}"

  local ATTEMPT=1
  local DELAY=$BASE_DELAY

  while [ $ATTEMPT -le $MAX_RETRIES ]; do
    echo "[RETRY] Attempt $ATTEMPT of $MAX_RETRIES: $COMMAND"

    # Execute command
    if eval "$COMMAND"; then
      echo "[SUCCESS] Command succeeded on attempt $ATTEMPT"
      return 0
    fi

    if [ $ATTEMPT -eq $MAX_RETRIES ]; then
      echo "[ERROR] Command failed after $MAX_RETRIES attempts"
      return 1
    fi

    # Calculate delay with jitter
    local JITTER=$((RANDOM % 100))
    local SLEEP_MS=$((DELAY + JITTER))
    local SLEEP_SEC=$(echo "scale=3; $SLEEP_MS / 1000" | bc)

    echo "[RETRY] Waiting ${SLEEP_SEC}s before retry..."
    sleep "$SLEEP_SEC"

    # Increase delay for next attempt
    DELAY=$(echo "$DELAY * $FACTOR" | bc | awk '{print int($1)}')
    ATTEMPT=$((ATTEMPT + 1))
  done

  return 1
}

# Export functions for use in other scripts
export -f print_script_header
export -f print_tool_versions
export -f verify_tool_versions
export -f load_flutterflow_secrets
export -f retry_with_backoff

# If script is executed directly (not sourced), display info
if [ "${BASH_SOURCE[0]}" = "${0}" ]; then
  echo "common-functions.sh - Shared Function Library"
  echo ""
  echo "This script provides common functions for FlutterFlow automation scripts."
  echo ""
  echo "Usage:"
  echo "  source scripts/common-functions.sh"
  echo ""
  echo "Available functions:"
  echo "  - print_script_header: Standardized script header"
  echo "  - print_tool_versions: Print tool versions"
  echo "  - verify_tool_versions: Check required tools present"
  echo "  - load_flutterflow_secrets: Load secrets from GCP"
  echo "  - retry_with_backoff: Exponential backoff retry logic"
  echo ""

  # Demo
  print_script_header "Example Script" "1.0"
  print_tool_versions
  verify_tool_versions
fi
