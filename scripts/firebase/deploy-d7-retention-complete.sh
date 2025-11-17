#!/usr/bin/env bash
# Complete D7 Retention System Deployment
# Automates what can be done via API, provides instructions for manual steps

set -e

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'

echo "======================================================================"
echo -e "${BLUE}D7 Retention System - Complete Deployment${NC}"
echo "======================================================================"
echo ""
echo -e "${YELLOW}🎯 RECOMMENDED: Use VS Code Extension for custom actions${NC}"
echo "See: docs/VSCODE_EXTENSION_DEPLOYMENT_GUIDE.md"
echo ""
echo "This script handles Firebase deployment only."
echo "For custom actions, use FlutterFlow VS Code Extension (faster, official)."
echo ""

# Configuration
PROJECT_ID="c-s-c305-capstone-khj14l"
API_BASE="https://api.flutterflow.io/v2"

# Get LEAD API token from Secret Manager
echo "Retrieving API token from Secret Manager..."
LEAD_TOKEN=$(gcloud secrets versions access latest --secret="FLUTTERFLOW_LEAD_API_TOKEN" --project=csc305project-475802 2>/dev/null)

if [ -z "$LEAD_TOKEN" ]; then
    echo "Error: Failed to retrieve LEAD API token from Secret Manager"
    echo "Run: gcloud secrets versions access latest --secret=FLUTTERFLOW_LEAD_API_TOKEN --project=csc305project-475802"
    exit 1
fi

echo "Project ID: $PROJECT_ID"
echo ""

# ============================================================================
# PART 0: VS Code Extension Path (Recommended)
# ============================================================================

echo "======================================================================"
echo -e "${BLUE}RECOMMENDED: FlutterFlow VS Code Extension (Path A1)${NC}"
echo "======================================================================"
echo ""
echo "For deploying custom actions, use the official VS Code extension:"
echo ""
echo "1. Install 'FlutterFlow: Custom Code Editor' in VS Code"
echo "2. Configure with API key and Project ID"
echo "3. Add 3 Dart files to lib/custom_code/actions/"
echo "4. Run 'FlutterFlow: Push to FlutterFlow'"
echo "5. Actions appear in FlutterFlow immediately"
echo ""
echo "Complete guide: docs/VSCODE_EXTENSION_DEPLOYMENT_GUIDE.md"
echo "Time: 30 minutes (vs 2-3 hours manual)"
echo ""
read -p "Have you deployed custom actions via VS Code extension? (y/n): " actions_deployed
echo ""

if [ "$actions_deployed" != "y" ]; then
    echo -e "${YELLOW}⚠️  Custom actions not deployed yet.${NC}"
    echo "Please complete VS Code extension deployment first."
    echo "Guide: docs/VSCODE_EXTENSION_DEPLOYMENT_GUIDE.md"
    echo ""
    echo "You can continue with Firebase deployment now and add actions later."
    echo ""
fi

echo ""

# ============================================================================
# PART 1: What We Can Automate via API
# ============================================================================

echo "======================================================================"
echo -e "${GREEN}PART 1: Automated Deployment via FlutterFlow API${NC}"
echo "======================================================================"
echo ""

echo "✅ App State data type fix - ALREADY DEPLOYED"
echo "   recipesCompletedThisSession: int → List<String>"
echo ""

echo "✅ App State persistence - ALREADY CONFIGURED"
echo "   isUserFirstRecipe, userCohortDate, userTimezone: persisted"
echo ""

# ============================================================================
# PART 2: Firebase Backend Deployment
# ============================================================================

echo "======================================================================"
echo -e "${GREEN}PART 2: Firebase Cloud Functions Deployment${NC}"
echo "======================================================================"
echo ""

if [ ! -d "functions/node_modules" ]; then
    echo "Installing function dependencies..."
    cd functions
    npm install
    cd ..
    echo -e "${GREEN}✅ Dependencies installed${NC}"
else
    echo -e "${GREEN}✅ Dependencies already installed${NC}"
fi

echo ""
echo "Checking Firebase authentication..."
if firebase projects:list &> /dev/null; then
    echo -e "${GREEN}✅ Firebase authenticated${NC}"
else
    echo -e "${YELLOW}⚠️  Firebase not authenticated${NC}"
    echo "Please run: firebase login"
    exit 1
fi

echo ""
echo "Current project:"
firebase use

echo ""
read -p "Deploy Firebase Functions now? (y/n): " deploy_functions

if [ "$deploy_functions" = "y" ]; then
    echo ""
    echo "Deploying cloud functions..."
    firebase deploy --only functions

    echo ""
    echo "Deploying Firestore indexes..."
    firebase deploy --only firestore:indexes

    echo ""
    echo -e "${GREEN}✅ Firebase deployment complete!${NC}"

    echo ""
    echo "Deployed functions:"
    firebase functions:list
else
    echo -e "${YELLOW}⏭️  Skipped Firebase deployment${NC}"
    echo "To deploy later, run: firebase deploy --only functions,firestore:indexes"
fi

# ============================================================================
# PART 3: FlutterFlow Manual Steps (Cannot be Automated)
# ============================================================================

echo ""
echo "======================================================================"
echo -e "${YELLOW}PART 3: FlutterFlow UI Deployment (Manual Steps Required)${NC}"
echo "======================================================================"
echo ""

echo -e "${YELLOW}⚠️  The following steps MUST be done in FlutterFlow UI:${NC}"
echo ""
echo "FlutterFlow's Growth Plan API currently supports YAML file updates but"
echo "does not provide endpoints for creating custom actions programmatically."
echo ""
echo "Custom actions must be added through the FlutterFlow web interface."
echo ""

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo -e "${BLUE}STEP 1: Deploy Custom Actions to FlutterFlow UI${NC}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "1. Open: https://app.flutterflow.io/project/$PROJECT_ID"
echo ""
echo "2. Navigate to: Custom Code > Actions"
echo ""
echo "3. Add Custom Action #1: initializeUserSession"
echo "   - Click '+ Add Action'"
echo "   - Name: initializeUserSession"
echo "   - Return Type: Future<void>"
echo "   - Parameters: None"
echo "   - Copy code from:"
echo "     metrics-implementation/custom-actions/initializeUserSession.dart"
echo "   - Add dependencies: uuid: ^4.0.0, intl: ^0.18.0"
echo "   - Save and compile"
echo ""
echo "4. Add Custom Action #2: checkAndLogRecipeCompletion"
echo "   - Click '+ Add Action'"
echo "   - Name: checkAndLogRecipeCompletion"
echo "   - Return Type: Future<bool>"
echo "   - Parameters:"
echo "     • recipeId (String, required)"
echo "     • recipeName (String, required)"
echo "     • cuisine (String, required)"
echo "     • prepTimeMinutes (int, required)"
echo "     • source (String, required)"
echo "     • completionMethod (String, required)"
echo "   - Copy code from:"
echo "     metrics-implementation/custom-actions/checkAndLogRecipeCompletion.dart"
echo "   - Save and compile"
echo ""
echo "5. Add Custom Action #3: checkScrollCompletion"
echo "   - Click '+ Add Action'"
echo "   - Name: checkScrollCompletion"
echo "   - Return Type: Future<bool>"
echo "   - Parameters:"
echo "     • scrollController (ScrollController, required)"
echo "     • threshold (double, optional, default: 0.9)"
echo "   - Copy code from:"
echo "     metrics-implementation/custom-actions/checkScrollCompletion.dart"
echo "   - Save and compile"
echo ""

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo -e "${BLUE}STEP 2: Wire Actions to Pages${NC}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "A. Initialize Session (3 triggers):"
echo "   - App startup page > OnInit > Add Action > initializeUserSession"
echo "   - Login page > After successful login > Add Action > initializeUserSession"
echo "   - GoldenPath page > OnLoad > Add Action > initializeUserSession"
echo ""
echo "B. Track Recipe Start:"
echo "   - Recipe detail page > OnLoad > Update App State:"
echo "     • currentRecipeId = recipe.id"
echo "     • currentRecipeName = recipe.name"
echo "     • currentRecipeCuisine = recipe.cuisine"
echo "     • currentRecipePrepTime = recipe.prepTime"
echo "     • recipeStartTime = Now()"
echo ""
echo "C. Add Completion Button:"
echo "   - Recipe detail page > Add Button widget"
echo "   - Text: 'Mark as Complete' or 'I Made This!'"
echo "   - OnTap > Add Action > checkAndLogRecipeCompletion"
echo "     • recipeId: App State.currentRecipeId"
echo "     • recipeName: App State.currentRecipeName"
echo "     • cuisine: App State.currentRecipeCuisine"
echo "     • prepTimeMinutes: App State.currentRecipePrepTime"
echo "     • source: 'search' (or tracked value)"
echo "     • completionMethod: 'button'"
echo "   - Add conditional snackbar on success"
echo ""

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo -e "${BLUE}Detailed Instructions:${NC}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "See complete step-by-step guide:"
echo "  docs/RETENTION_IMPLEMENTATION_GUIDE.md"
echo ""

# ============================================================================
# PART 4: Testing
# ============================================================================

echo "======================================================================"
echo -e "${GREEN}PART 4: Testing${NC}"
echo "======================================================================"
echo ""

echo "After completing manual steps, run tests:"
echo ""
echo "1. Test Firebase Functions:"
echo "   ./scripts/test-retention-function.sh"
echo ""
echo "2. Test in FlutterFlow:"
echo "   - Open Test Mode in FlutterFlow"
echo "   - Check session initialization (App State variables)"
echo "   - Navigate to recipe page"
echo "   - Click 'Mark as Complete' button"
echo "   - Verify Firestore writes in Firebase Console"
echo ""

# ============================================================================
# Summary
# ============================================================================

echo "======================================================================"
echo -e "${GREEN}Deployment Summary${NC}"
echo "======================================================================"
echo ""

echo -e "${GREEN}✅ Automated (Complete):${NC}"
echo "   - App State data type fix"
echo "   - App State persistence configuration"
if [ "$deploy_functions" = "y" ]; then
    echo "   - Firebase cloud functions deployed"
    echo "   - Firestore indexes deployed"
else
    echo -e "   ${YELLOW}- Firebase deployment (pending)${NC}"
fi

echo ""
echo -e "${YELLOW}📋 Manual (Pending):${NC}"
echo "   - Upload 3 custom actions to FlutterFlow UI"
echo "   - Wire actions to app pages"
echo "   - Add 'Mark as Complete' button"
echo ""
echo "Estimated time for manual steps: 2-3 hours"
echo ""

echo "======================================================================"
echo -e "${BLUE}Next Steps:${NC}"
echo "======================================================================"
echo ""
echo "1. Follow STEP 1 & 2 above to complete FlutterFlow UI deployment"
echo "2. Run testing scripts to verify functionality"
echo "3. Monitor Firestore for data collection"
echo "4. Review metrics after first D7 cohort (7 days)"
echo ""
echo "For detailed instructions, see:"
echo "  docs/RETENTION_IMPLEMENTATION_GUIDE.md"
echo ""
echo "======================================================================"
