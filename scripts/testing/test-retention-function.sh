#!/bin/bash
# Test D7 Retention Cloud Function
# This script tests the calculateD7RetentionManual callable function

set -e

echo "======================================"
echo "Test D7 Retention Function"
echo "======================================"
echo ""

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Calculate cohort date (7 days ago)
COHORT_DATE=$(date -d "7 days ago" +%Y-%m-%d)

echo -e "${YELLOW}Testing cohort date: $COHORT_DATE${NC}"
echo ""

# Get Firebase project ID
PROJECT_ID=$(firebase use | tail -1 | tr -d '[:space:]')

echo "Project ID: $PROJECT_ID"
echo ""

echo "======================================"
echo "Option 1: Test via Firebase Functions Shell"
echo "======================================"
echo ""

echo "Run the following commands:"
echo ""
echo "  firebase functions:shell"
echo "  calculateD7RetentionManual({cohortDate: \"$COHORT_DATE\"})"
echo ""

echo "======================================"
echo "Option 2: Test via gcloud CLI"
echo "======================================"
echo ""

echo "Run:"
echo ""
echo "  gcloud functions call calculateD7RetentionManual \\"
echo "    --data '{\"cohortDate\":\"$COHORT_DATE\"}'"
echo ""

echo "======================================"
echo "Option 3: Check Scheduled Function Logs"
echo "======================================"
echo ""

echo "View last 50 function logs:"
echo ""
echo "  firebase functions:log --limit 50"
echo ""
echo "Or filter for retention function:"
echo ""
echo "  firebase functions:log --only calculateD7Retention"
echo ""

echo "======================================"
echo "Verify Results in Firestore"
echo "======================================"
echo ""

echo "After running the function, check Firestore:"
echo ""
echo "1. Open Firebase Console:"
echo "   https://console.firebase.google.com/project/$PROJECT_ID/firestore"
echo ""
echo "2. Navigate to 'retention_metrics' collection"
echo ""
echo "3. Look for document: d7_$COHORT_DATE"
echo ""
echo "4. Verify fields:"
echo "   - cohort_date: $COHORT_DATE"
echo "   - cohort_size: number of users in cohort"
echo "   - users_with_repeat_recipes: count"
echo "   - d7_repeat_recipe_rate: percentage"
echo "   - retention_category: Excellent/Good/Fair/Poor/Critical"
echo ""

echo -e "${GREEN}Ready to test!${NC}"
