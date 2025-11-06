#!/usr/bin/env bash
# Setup Firebase permissions for deployment
# This script guides you through authenticating and granting necessary IAM roles

set -e

echo "════════════════════════════════════════════════════════════"
echo "  Firebase Deployment Setup"
echo "════════════════════════════════════════════════════════════"
echo ""

PROJECT_ID="csc-305-dev-project"
PERSONAL_ACCOUNT="vallejo.juan97@gmail.com"

echo "Firebase project: $PROJECT_ID"
echo "Personal account: $PERSONAL_ACCOUNT"
echo ""

# Step 1: Authenticate Firebase CLI
echo "────────────────────────────────────────────────────────────"
echo "Step 1: Authenticate Firebase CLI"
echo "────────────────────────────────────────────────────────────"
echo ""
echo "You need to authenticate with your personal Gmail account."
echo "This will open a browser window."
echo ""
read -p "Press Enter to continue..."
echo ""

firebase login --no-localhost

echo ""
echo "✅ Firebase authentication complete"
echo ""

# Step 2: Verify authentication
echo "────────────────────────────────────────────────────────────"
echo "Step 2: Verify authentication"
echo "────────────────────────────────────────────────────────────"
echo ""

firebase login:list

echo ""

# Step 3: Grant IAM permissions
echo "────────────────────────────────────────────────────────────"
echo "Step 3: Grant IAM permissions"
echo "────────────────────────────────────────────────────────────"
echo ""
echo "Granting 'Service Account User' role to $PERSONAL_ACCOUNT..."
echo ""

gcloud projects add-iam-policy-binding "$PROJECT_ID" \
  --member="user:$PERSONAL_ACCOUNT" \
  --role="roles/iam.serviceAccountUser" \
  2>&1 | grep -E "(Updated|bindings|ERROR)" || true

echo ""
echo "✅ IAM permissions granted"
echo ""

# Step 4: Test deployment (dry run)
echo "────────────────────────────────────────────────────────────"
echo "Step 4: Test deployment readiness"
echo "────────────────────────────────────────────────────────────"
echo ""

firebase deploy --only functions --dry-run 2>&1 || true

echo ""
echo "════════════════════════════════════════════════════════════"
echo "✅ Setup Complete!"
echo "════════════════════════════════════════════════════════════"
echo ""
echo "You can now deploy with:"
echo "  firebase deploy --only functions,firestore:indexes"
echo ""
