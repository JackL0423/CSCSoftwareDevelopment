#!/usr/bin/env bash
# Deploy Firebase Functions using service account credentials from Secret Manager
# This script uses the service account JSON for authentication

set -e

echo "════════════════════════════════════════════════════════════"
echo "  Firebase Functions Deployment (Service Account)"
echo "════════════════════════════════════════════════════════════"
echo ""

PROJECT_ID="csc-305-dev-project"
SERVICE_ACCOUNT_EMAIL="firebase-adminsdk-fbsvc@csc-305-dev-project.iam.gserviceaccount.com"

# Step 1: Retrieve service account credentials from Secret Manager
echo "────────────────────────────────────────────────────────────"
echo "Step 1: Retrieving service account credentials..."
echo "────────────────────────────────────────────────────────────"
echo ""

gcloud secrets versions access latest \
    --secret="FIREBASE_SERVICE_ACCOUNT_JSON" \
    --project=csc305project-475802 > /tmp/firebase-service-account.json

if [ ! -s /tmp/firebase-service-account.json ]; then
    echo "❌ Failed to retrieve service account credentials"
    exit 1
fi

echo "✅ Service account credentials retrieved"
echo ""

# Step 2: Set environment variable for Firebase CLI
echo "────────────────────────────────────────────────────────────"
echo "Step 2: Configuring Firebase CLI..."
echo "────────────────────────────────────────────────────────────"
echo ""

export GOOGLE_APPLICATION_CREDENTIALS="/tmp/firebase-service-account.json"
echo "GOOGLE_APPLICATION_CREDENTIALS=/tmp/firebase-service-account.json"
echo ""

# Step 3: Navigate to project root
cd "$(dirname "$0")/.."
echo "Working directory: $(pwd)"
echo ""

# Step 4: Deploy functions
echo "────────────────────────────────────────────────────────────"
echo "Step 3: Deploying Firebase Functions..."
echo "────────────────────────────────────────────────────────────"
echo ""

# Use gcloud to activate the service account first
gcloud auth activate-service-account \
    "$SERVICE_ACCOUNT_EMAIL" \
    --key-file="/tmp/firebase-service-account.json" \
    --project="$PROJECT_ID"

# Deploy with the service account active
firebase deploy --only functions --project="$PROJECT_ID"

DEPLOY_STATUS=$?

# Clean up
rm -f /tmp/firebase-service-account.json

if [ $DEPLOY_STATUS -eq 0 ]; then
    echo ""
    echo "════════════════════════════════════════════════════════════"
    echo "✅ Firebase Functions Deployed Successfully!"
    echo "════════════════════════════════════════════════════════════"
    echo ""
    echo "Deployed functions:"
    firebase functions:list --project="$PROJECT_ID"
else
    echo ""
    echo "════════════════════════════════════════════════════════════"
    echo "❌ Firebase Functions Deployment Failed"
    echo "════════════════════════════════════════════════════════════"
    exit 1
fi
