#!/bin/bash
#
# GlobalFlavors - Store Secrets in Google Secret Manager
#
# This script reads a temporary .env file and stores all secrets in Google Secret Manager
# Usage: ./scripts/store-secrets.sh [environment]
#
# Arguments:
#   environment: dev (default) | testing | prod
#
# Requirements:
# - gcloud CLI installed and authenticated
# - Access to Google Secret Manager
# - Temporary .env file with actual secret values

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

log_info() { echo -e "${BLUE}[INFO]${NC} $1"; }
log_success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }
log_warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }

# Determine environment (dev, testing, prod)
ENVIRONMENT="${1:-dev}"
SUFFIX=""

case "$ENVIRONMENT" in
    dev|development)
        ENVIRONMENT="development"
        SUFFIX=""
        ;;
    test|testing|staging)
        ENVIRONMENT="testing"
        SUFFIX="_TESTING"
        ;;
    prod|production)
        ENVIRONMENT="production"
        SUFFIX="_PROD"
        ;;
    *)
        log_error "Invalid environment: $ENVIRONMENT. Use: dev, testing, or prod"
        exit 1
        ;;
esac

log_info "Storing secrets for environment: $ENVIRONMENT"

# Temporary .env file (user must create this with actual values)
TEMP_ENV_FILE=".env.tmp"

if [[ ! -f "$TEMP_ENV_FILE" ]]; then
    log_error "Temporary .env file not found: $TEMP_ENV_FILE"
    echo ""
    echo "Please create $TEMP_ENV_FILE with your actual secret values:"
    echo "  1. cp .env.example $TEMP_ENV_FILE"
    echo "  2. Edit $TEMP_ENV_FILE and fill in actual values"
    echo "  3. Run this script again: ./scripts/store-secrets.sh $ENVIRONMENT"
    echo "  4. Delete $TEMP_ENV_FILE: shred -u $TEMP_ENV_FILE"
    exit 1
fi

# Get GCP project ID
GCP_PROJECT_ID=$(gcloud config get-value project 2>/dev/null || echo "")
if [[ -z "$GCP_PROJECT_ID" ]]; then
    read -p "Enter your GCP Project ID: " GCP_PROJECT_ID
    gcloud config set project "$GCP_PROJECT_ID"
fi

log_info "Using GCP Project: $GCP_PROJECT_ID"

# Enable Secret Manager API
log_info "Ensuring Secret Manager API is enabled..."
gcloud services enable secretmanager.googleapis.com --project="$GCP_PROJECT_ID"

# Function to store a secret
store_secret() {
    local secret_name=$1
    local secret_value=$2

    # Add environment suffix
    local full_secret_name="${secret_name}${SUFFIX}"

    # Skip empty values
    if [[ -z "$secret_value" ]]; then
        log_warn "Skipping empty secret: $secret_name"
        return 0
    fi

    log_info "Storing: $full_secret_name"

    # Check if secret already exists
    if gcloud secrets describe "$full_secret_name" --project="$GCP_PROJECT_ID" &>/dev/null; then
        log_warn "Secret '$full_secret_name' already exists. Creating new version..."

        # Add new version
        echo -n "$secret_value" | gcloud secrets versions add "$full_secret_name" \
            --data-file=- \
            --project="$GCP_PROJECT_ID"

        log_success "Updated: $full_secret_name (new version)"
    else
        # Create new secret
        echo -n "$secret_value" | gcloud secrets create "$full_secret_name" \
            --data-file=- \
            --replication-policy="automatic" \
            --project="$GCP_PROJECT_ID"

        log_success "Created: $full_secret_name"
    fi
}

# Counter
STORED=0
SKIPPED=0

# Read and store secrets
log_info "Processing secrets from $TEMP_ENV_FILE..."
echo ""

# Define which variables should be stored as secrets
SECRETS_TO_STORE=(
    "FLUTTERFLOW_API_TOKEN"
    "FIGMA_API_KEY"
    "FIGMA_FILE_ID"
    "FIREBASE_PROJECT_ID"
    "FIREBASE_WEB_API_KEY"
    "FIREBASE_SERVICE_ACCOUNT_JSON"
    "INSTACART_API_KEY"
    "INSTACART_CLIENT_ID"
    "WALMART_API_KEY"
    "WALMART_CLIENT_ID"
    "AMAZON_AFFILIATE_ID"
    "DATABASE_URL_DEV"
    "DATABASE_URL_TESTING"
    "DATABASE_URL_PROD"
    "ENCRYPTION_KEY_PROD"
    "JWT_SECRET_PROD"
    "SENTRY_DSN_PROD"
)

# Load temporary env file and store secrets
source "$TEMP_ENV_FILE"

for secret_name in "${SECRETS_TO_STORE[@]}"; do
    secret_value="${!secret_name:-}"

    if [[ -n "$secret_value" ]]; then
        if store_secret "$secret_name" "$secret_value"; then
            ((STORED++))
        fi
    else
        log_warn "Skipping (not found in $TEMP_ENV_FILE): $secret_name"
        ((SKIPPED++))
    fi
done

# Summary
echo ""
log_success "Secrets stored: $STORED"
log_info "Secrets skipped: $SKIPPED"

# Security reminder
echo ""
log_warn "=========================================="
log_warn "SECURITY REMINDER:"
log_warn "1. Delete temporary file: shred -u $TEMP_ENV_FILE"
log_warn "2. Clear shell history: history -c && history -w"
log_warn "3. Verify secrets: gcloud secrets list --project=$GCP_PROJECT_ID"
log_warn "=========================================="

# Verify critical secrets
echo ""
log_info "Verifying critical secrets..."
CRITICAL_SECRETS=(
    "FLUTTERFLOW_API_TOKEN${SUFFIX}"
    "FIGMA_API_KEY${SUFFIX}"
)

ALL_VERIFIED=true
for secret in "${CRITICAL_SECRETS[@]}"; do
    if gcloud secrets describe "$secret" --project="$GCP_PROJECT_ID" &>/dev/null; then
        log_success "✓ $secret exists"
    else
        log_error "✗ $secret NOT FOUND"
        ALL_VERIFIED=false
    fi
done

if $ALL_VERIFIED; then
    echo ""
    log_success "All critical secrets verified successfully!"
    log_info "You can now delete $TEMP_ENV_FILE and use load-secrets.sh to access them"
else
    echo ""
    log_error "Some critical secrets are missing. Please check and re-run."
    exit 1
fi
