#!/bin/bash
#
# GlobalFlavors - Secret Manager Loader
#
# This script loads secrets from Google Secret Manager and exports them as environment variables
# Usage: source scripts/load-secrets.sh
#
# Requirements:
# - gcloud CLI installed and authenticated
# - Access to Google Secret Manager
# - GCP_PROJECT_ID set in environment or .env file

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Helper function to print colored messages
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Determine which environment file to use
ENV_FILE=".env"
if [[ "${NODE_ENV:-}" == "production" ]]; then
    ENV_FILE=".env.production"
elif [[ "${NODE_ENV:-}" == "testing" ]]; then
    ENV_FILE=".env.testing"
fi

log_info "Loading environment from: $ENV_FILE"

# Check if environment file exists
if [[ ! -f "$ENV_FILE" ]]; then
    log_error "Environment file not found: $ENV_FILE"
    exit 1
fi

# Load non-secret environment variables
set -a  # automatically export all variables
source "$ENV_FILE"
set +a

# Get GCP project ID
if [[ -z "${GCP_PROJECT_ID:-}" ]]; then
    GCP_PROJECT_ID=$(gcloud config get-value project 2>/dev/null || echo "")
fi

if [[ -z "$GCP_PROJECT_ID" ]]; then
    log_error "GCP_PROJECT_ID not set. Please set it in $ENV_FILE or run: gcloud config set project YOUR_PROJECT_ID"
    exit 1
fi

log_info "Using GCP Project: $GCP_PROJECT_ID"

# Function to fetch secret from Google Secret Manager
fetch_secret() {
    local secret_name=$1
    local env_var_name=$2

    log_info "Fetching secret: $secret_name"

    # Check if secret exists
    if ! gcloud secrets describe "$secret_name" --project="$GCP_PROJECT_ID" &>/dev/null; then
        log_warn "Secret '$secret_name' not found in Secret Manager"
        return 1
    fi

    # Fetch the secret value
    local secret_value
    secret_value=$(gcloud secrets versions access latest \
        --secret="$secret_name" \
        --project="$GCP_PROJECT_ID" 2>/dev/null)

    if [[ -z "$secret_value" ]]; then
        log_warn "Secret '$secret_name' is empty"
        return 1
    fi

    # Export the secret as an environment variable
    export "${env_var_name}=${secret_value}"
    log_success "Loaded: $env_var_name"

    return 0
}

# Main: Load all secrets referenced in environment file
log_info "Loading secrets from Google Secret Manager..."

# Counter for loaded secrets
LOADED=0
FAILED=0

# Process all *_SECRET variables from the environment file
while IFS='=' read -r key value; do
    # Skip comments and empty lines
    [[ "$key" =~ ^#.*$ ]] && continue
    [[ -z "$key" ]] && continue

    # Only process variables ending with _SECRET
    if [[ "$key" =~ _SECRET$ ]]; then
        # Remove _SECRET suffix to get the actual environment variable name
        env_var_name="${key%_SECRET}"

        # The value is the secret name in Secret Manager
        secret_name="$value"

        # Skip if value is empty
        [[ -z "$secret_name" ]] && continue

        # Fetch and export the secret
        if fetch_secret "$secret_name" "$env_var_name"; then
            ((LOADED++))
        else
            ((FAILED++))
        fi
    fi
done < "$ENV_FILE"

# Summary
echo ""
log_success "Secrets loaded: $LOADED"
if [[ $FAILED -gt 0 ]]; then
    log_warn "Secrets failed: $FAILED"
fi

# Verify critical secrets are loaded
CRITICAL_SECRETS=(
    "FLUTTERFLOW_API_TOKEN"
    "FIGMA_API_KEY"
)

MISSING_CRITICAL=0
for secret in "${CRITICAL_SECRETS[@]}"; do
    if [[ -z "${!secret:-}" ]]; then
        log_error "Critical secret not loaded: $secret"
        ((MISSING_CRITICAL++))
    fi
done

if [[ $MISSING_CRITICAL -gt 0 ]]; then
    log_error "Missing $MISSING_CRITICAL critical secret(s). Application may not function correctly."
    exit 1
fi

log_success "All critical secrets loaded successfully!"
echo ""
log_info "Environment: ${NODE_ENV:-development}"
log_info "Ready to start application"
