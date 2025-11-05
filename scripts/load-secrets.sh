#!/usr/bin/env bash
# Load secrets from GCP Secret Manager (csc305project-475802)
# Usage: source ./scripts/load-secrets.sh
#
# This script retrieves all project secrets from Secret Manager and exports them
# as environment variables for convenient access in other scripts or interactive sessions.

set -e

# GCP project containing secrets
SECRETS_PROJECT="csc305project-475802"

echo "Loading secrets from GCP Secret Manager (project: $SECRETS_PROJECT)..."

# Check if gcloud is authenticated
if ! gcloud auth list --filter=status:ACTIVE --format="value(account)" &>/dev/null; then
    echo "Error: No active gcloud account. Run: gcloud auth login"
    return 1 2>/dev/null || exit 1
fi

# Function to safely load a secret
load_secret() {
    local secret_name="$1"
    local env_var_name="${2:-$secret_name}"

    local value=$(gcloud secrets versions access latest --secret="$secret_name" --project="$SECRETS_PROJECT" 2>/dev/null)

    if [ -n "$value" ]; then
        export "$env_var_name"="$value"
        echo "✓ Loaded: $env_var_name"
    else
        echo "⚠ Warning: Could not load secret '$secret_name'"
    fi
}

# Load all project secrets
load_secret "FLUTTERFLOW_LEAD_API_TOKEN" "FLUTTERFLOW_API_TOKEN"
load_secret "FLUTTERFLOW_LEAD_API_TOKEN" "LEAD_TOKEN"  # Alias for compatibility
load_secret "FIREBASE_PROJECT_ID"
load_secret "GEMINI_API_KEY"
load_secret "FIREBASE_API_KEY"
load_secret "FIREBASE_AUTH_DOMAIN"
load_secret "FIREBASE_STORAGE_BUCKET"
load_secret "FIREBASE_MESSAGING_SENDER_ID"
load_secret "FIREBASE_APP_ID"
load_secret "FIREBASE_MEASUREMENT_ID"

echo ""
echo "✅ Secrets loaded successfully!"
echo ""
echo "Available environment variables:"
echo "  - \$FLUTTERFLOW_API_TOKEN (or \$LEAD_TOKEN)"
echo "  - \$FIREBASE_PROJECT_ID"
echo "  - \$GEMINI_API_KEY"
echo "  - \$FIREBASE_API_KEY"
echo "  - \$FIREBASE_AUTH_DOMAIN"
echo "  - \$FIREBASE_STORAGE_BUCKET"
echo "  - \$FIREBASE_MESSAGING_SENDER_ID"
echo "  - \$FIREBASE_APP_ID"
echo "  - \$FIREBASE_MEASUREMENT_ID"
echo ""
echo "Usage examples:"
echo "  ./scripts/flutterflow.sh list"
echo "  firebase deploy"
echo ""
