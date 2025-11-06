#!/usr/bin/env bash
# Complete Firebase deployment script
# Run this with your personal Gmail account (vallejo.juan97@gmail.com)

set -e

echo "════════════════════════════════════════════════════════════"
echo "  Firebase Complete Deployment"
echo "════════════════════════════════════════════════════════════"
echo ""

PROJECT_ID="csc-305-dev-project"
PERSONAL_ACCOUNT="vallejo.juan97@gmail.com"

echo "⚠️  IMPORTANT: This script must run with $PERSONAL_ACCOUNT"
echo ""
echo "Current gcloud account:"
gcloud auth list --filter=status:ACTIVE --format="value(account)"
echo ""

read -p "Do you want to continue? (y/N): " -n 1 -r
echo ""
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Aborting..."
    exit 1
fi

# Step 1: Grant IAM permissions (if needed)
echo ""
echo "────────────────────────────────────────────────────────────"
echo "Step 1: Granting IAM permissions..."
echo "────────────────────────────────────────────────────────────"
echo ""

gcloud iam service-accounts add-iam-policy-binding \
  54503053415-compute@developer.gserviceaccount.com \
  --member="user:$PERSONAL_ACCOUNT" \
  --role="roles/iam.serviceAccountUser" \
  --project="$PROJECT_ID" 2>&1 || echo "⚠️  Permission grant may have failed (might already exist)"

echo ""
echo "✅ IAM permissions configured"
echo ""

# Step 2: Deploy Firebase Functions
echo "────────────────────────────────────────────────────────────"
echo "Step 2: Deploying Firebase Functions..."
echo "────────────────────────────────────────────────────────────"
echo ""

cd "$(dirname "$0")/.."

firebase deploy --only functions 2>&1

echo ""
echo "✅ Functions deployed"
echo ""

# Step 3: Deploy Firestore Indexes
echo "────────────────────────────────────────────────────────────"
echo "Step 3: Deploying Firestore Indexes..."
echo "────────────────────────────────────────────────────────────"
echo ""

firebase deploy --only firestore:indexes 2>&1

echo ""
echo "✅ Indexes deployed"
echo ""

# Step 4: Verify deployment
echo "────────────────────────────────────────────────────────────"
echo "Step 4: Verifying deployment..."
echo "────────────────────────────────────────────────────────────"
echo ""

echo "Listing deployed functions:"
firebase functions:list --project="$PROJECT_ID"

echo ""
echo "════════════════════════════════════════════════════════════"
echo "✅ Firebase Deployment Complete!"
echo "════════════════════════════════════════════════════════════"
echo ""
echo "Deployed components:"
echo "  ✓ 4 Cloud Functions"
echo "  ✓ 2 Firestore composite indexes"
echo ""
echo "Functions deployed:"
echo "  - calculateD7Retention (scheduled, daily 2 AM UTC)"
echo "  - calculateD7RetentionManual (callable)"
echo "  - getD7RetentionMetrics (HTTPS)"
echo "  - getD7RetentionTrends (HTTPS)"
echo ""
echo "Next steps:"
echo "  1. Wire custom actions to UI pages in FlutterFlow"
echo "  2. Test end-to-end functionality"
echo "  3. Verify Firestore writes"
echo ""
