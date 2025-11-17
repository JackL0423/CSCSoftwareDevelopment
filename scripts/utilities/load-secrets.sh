#!/usr/bin/env bash
# Optimized secrets loader from GCP Secret Manager (csc305project-475802)
# Usage: source ./scripts/utilities/load-secrets.sh
#
# This script retrieves project secrets from Secret Manager with:
# - Retry logic with exponential backoff
# - Strict error handling (fails fast on missing secrets)
# - Statistics tracking and timing
# - Clean, maintainable code

set -euo pipefail

# GCP project containing secrets
SECRETS_PROJECT="csc305project-475802"

# Required secrets (must exist)
declare -A REQUIRED_SECRETS=(
    ["FLUTTERFLOW_LEAD_API_TOKEN"]="FLUTTERFLOW_API_TOKEN"
    ["FIREBASE_PROJECT_ID"]="FIREBASE_PROJECT_ID"
    ["GEMINI_API_KEY"]="GEMINI_API_KEY"
)

# Statistics
LOADED=0
FAILED=0
START_TIME=$(date +%s%3N 2>/dev/null || date +%s000)

echo "Loading secrets from GCP Secret Manager (project: $SECRETS_PROJECT)..."

# Check if gcloud is authenticated
if ! gcloud auth list --filter=status:ACTIVE --format="value(account)" &>/dev/null; then
    echo "❌ Error: No active gcloud account. Run: gcloud auth login"
    return 1 2>/dev/null || exit 1
fi

# Function to load a single secret with retry logic
load_secret_with_retry() {
    local secret_name="$1"
    local env_var_name="$2"
    local max_attempts=3
    local value=""

    for attempt in $(seq 1 $max_attempts); do
        value=$(gcloud secrets versions access latest \
            --secret="$secret_name" \
            --project="$SECRETS_PROJECT" 2>/dev/null || true)

        if [ -n "$value" ]; then
            # Success - export and return
            export "$env_var_name"="$value"
            echo "✓ Loaded: $env_var_name"
            return 0
        fi

        # Retry with exponential backoff
        if [ $attempt -lt $max_attempts ]; then
            echo "  Retry $attempt/$max_attempts for $secret_name..." >&2
            sleep $((attempt * 2))  # 2s, 4s backoff
        fi
    done

    # All retries exhausted
    echo "❌ FAILED: Required secret '$secret_name' not found after $max_attempts attempts" >&2
    return 1
}

# Load all required secrets
for secret_name in "${!REQUIRED_SECRETS[@]}"; do
    env_var_name="${REQUIRED_SECRETS[$secret_name]}"

    if load_secret_with_retry "$secret_name" "$env_var_name"; then
        ((LOADED++))
    else
        ((FAILED++))
    fi
done

# Create alias for LEAD_TOKEN (no duplicate API call)
if [ -n "${FLUTTERFLOW_API_TOKEN:-}" ]; then
    export LEAD_TOKEN="$FLUTTERFLOW_API_TOKEN"
    echo "✓ Created alias: LEAD_TOKEN → FLUTTERFLOW_API_TOKEN"
fi

# Calculate timing
END_TIME=$(date +%s%3N 2>/dev/null || date +%s000)
DURATION=$((END_TIME - START_TIME))

echo ""
if [ $FAILED -eq 0 ]; then
    echo "✅ All secrets loaded successfully! ($LOADED/$((LOADED + FAILED)) in ${DURATION}ms)"
    echo ""
    echo "Available environment variables:"
    echo "  - \$FLUTTERFLOW_API_TOKEN (or \$LEAD_TOKEN)"
    echo "  - \$FIREBASE_PROJECT_ID"
    echo "  - \$GEMINI_API_KEY"
    echo ""
    echo "Usage examples:"
    echo "  ./scripts/flutterflow.sh list"
    echo "  firebase deploy"
    echo ""
else
    echo "❌ Failed to load $FAILED/$((LOADED + FAILED)) secrets"
    echo ""
    echo "Fix: Verify secrets exist in GCP Secret Manager:"
    echo "  gcloud secrets list --project=$SECRETS_PROJECT"
    echo ""
    return 1 2>/dev/null || exit 1
fi
