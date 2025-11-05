#!/bin/bash
# Deploy D7 Retention Tracking System to Firebase
# This script handles cloud function and Firestore index deployment

set -e

echo "======================================"
echo "D7 Retention System Deployment Script"
echo "======================================"
echo ""

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Check if Firebase CLI is installed
if ! command -v firebase &> /dev/null; then
    echo -e "${RED}❌ Firebase CLI not found!${NC}"
    echo "Install with: npm install -g firebase-tools"
    exit 1
fi

echo -e "${GREEN}✅ Firebase CLI found${NC}"
echo ""

# Check Firebase authentication
echo "Checking Firebase authentication..."
if ! firebase projects:list &> /dev/null; then
    echo -e "${YELLOW}⚠️  Not authenticated with Firebase${NC}"
    echo "Running: firebase login"
    firebase login
fi

echo -e "${GREEN}✅ Firebase authenticated${NC}"
echo ""

# List available projects
echo "Available Firebase projects:"
firebase projects:list
echo ""

# Select project
echo -e "${YELLOW}📋 Current project:${NC}"
firebase use
echo ""

read -p "Is this the correct project? (y/n): " confirm
if [ "$confirm" != "y" ]; then
    echo "Please run: firebase use [project-id]"
    exit 1
fi

echo ""
echo "======================================"
echo "Step 1: Install Function Dependencies"
echo "======================================"
echo ""

cd functions

if [ ! -d "node_modules" ]; then
    echo "Installing npm dependencies..."
    npm install
else
    echo -e "${GREEN}✅ Dependencies already installed${NC}"
fi

cd ..

echo ""
echo "======================================"
echo "Step 2: Deploy Firestore Indexes"
echo "======================================"
echo ""

if [ -f "firestore.indexes.json" ]; then
    echo "Deploying Firestore indexes..."
    firebase deploy --only firestore:indexes

    echo ""
    echo -e "${YELLOW}⏳ Note: Index creation can take 5-10 minutes${NC}"
    echo "You can monitor progress at:"
    echo "https://console.firebase.google.com/project/$(firebase use | tail -1)/firestore/indexes"
else
    echo -e "${YELLOW}⚠️  firestore.indexes.json not found, skipping index deployment${NC}"
fi

echo ""
echo "======================================"
echo "Step 3: Deploy Cloud Functions"
echo "======================================"
echo ""

echo "Deploying functions..."
firebase deploy --only functions

echo ""
echo "======================================"
echo "Step 4: Verify Deployment"
echo "======================================"
echo ""

echo "Listing deployed functions:"
firebase functions:list

echo ""
echo -e "${GREEN}✅ Deployment complete!${NC}"
echo ""

echo "======================================"
echo "Post-Deployment Checklist"
echo "======================================"
echo ""
echo "☐ Verify functions deployed:"
echo "  - calculateD7Retention (scheduled)"
echo "  - calculateD7RetentionManual (callable)"
echo "  - getD7RetentionMetrics (https)"
echo "  - getRetentionTrend (https)"
echo ""
echo "☐ Check Cloud Scheduler:"
echo "  https://console.cloud.google.com/cloudscheduler"
echo "  - Verify daily 2 AM UTC schedule is active"
echo ""
echo "☐ Monitor index creation:"
echo "  https://console.firebase.google.com/project/$(firebase use | tail -1)/firestore/indexes"
echo "  - Wait for 'Enabled' status on both indexes"
echo ""
echo "☐ Test manual function trigger:"
echo "  Run: ./scripts/test-retention-function.sh"
echo ""
echo "======================================"
