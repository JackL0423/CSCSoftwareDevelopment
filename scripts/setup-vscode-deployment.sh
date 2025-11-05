#!/bin/bash
# Setup script for FlutterFlow VS Code Extension deployment
# This script prepares everything needed for custom action deployment

set -e

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo "=========================================="
echo -e "${BLUE}FlutterFlow VS Code Extension Setup${NC}"
echo "=========================================="
echo ""

PROJECT_ID="c-s-c305-capstone-khj14l"
WORKSPACE_NAME="flutterflow-globalflavors"

# Step 1: Check prerequisites
echo "Step 1: Checking prerequisites..."
echo ""

# Check if VS Code is installed
if ! command -v code &> /dev/null; then
    echo -e "${YELLOW}⚠️  VS Code not found in PATH${NC}"
    echo "Please ensure VS Code is installed and 'code' command is available."
    echo "On some systems, you may need to add VS Code to PATH manually."
    echo ""
    read -p "Press Enter to continue anyway, or Ctrl+C to exit..."
else
    echo -e "${GREEN}✅ VS Code found${NC}"
fi

# Check if custom action files exist
if [ ! -d "vscode-extension-ready/lib/custom_code/actions" ]; then
    echo -e "${YELLOW}⚠️  VS Code extension-ready files not found${NC}"
    exit 1
else
    echo -e "${GREEN}✅ Custom action files ready${NC}"
    echo "   Found 3 action files:"
    ls -1 vscode-extension-ready/lib/custom_code/actions/*.dart | xargs -n1 basename
fi

echo ""

# Step 2: Guide through extension installation
echo "=========================================="
echo "Step 2: Install FlutterFlow VS Code Extension"
echo "=========================================="
echo ""
echo "1. Open VS Code"
echo "2. Go to Extensions (Ctrl+Shift+X or Cmd+Shift+X)"
echo "3. Search for: 'FlutterFlow: Custom Code Editor'"
echo "4. Click 'Install'"
echo ""
read -p "Press Enter when extension is installed..."
echo ""

# Step 3: Generate API Key instructions
echo "=========================================="
echo "Step 3: Generate FlutterFlow API Key"
echo "=========================================="
echo ""
echo "1. Open https://app.flutterflow.io"
echo "2. Click Profile → Account → API"
echo "3. Click 'Generate API Key'"
echo "4. Copy the key (you won't see it again!)"
echo ""
echo -e "${YELLOW}NOTE: The existing LEAD_TOKEN may work, or you may need a new key.${NC}"
echo ""
read -p "Press Enter when you have your API key ready..."
echo ""

# Step 4: Configure extension
echo "=========================================="
echo "Step 4: Configure VS Code Extension"
echo "=========================================="
echo ""
echo "In VS Code:"
echo "1. Open Command Palette (Ctrl+Shift+P or Cmd+Shift+P)"
echo "2. Run: 'FlutterFlow: Configure'"
echo "3. Enter:"
echo "   - API Key: [paste your key]"
echo "   - Project ID: ${PROJECT_ID}"
echo "   - Branch: main"
echo ""
read -p "Press Enter when configuration is complete..."
echo ""

# Step 5: Download project structure
echo "=========================================="
echo "Step 5: Download FlutterFlow Project"
echo "=========================================="
echo ""
echo "In VS Code:"
echo "1. Open Command Palette"
echo "2. Run: 'FlutterFlow: Download Code'"
echo "3. Select a workspace directory (suggest: ~/${WORKSPACE_NAME})"
echo "4. Wait for download to complete"
echo ""
read -p "Press Enter when download is complete..."
echo ""

# Step 6: Get workspace path
echo "Please enter the full path to your FlutterFlow workspace:"
echo "(Example: /home/yourname/${WORKSPACE_NAME})"
read -p "Workspace path: " WORKSPACE_PATH

if [ ! -d "$WORKSPACE_PATH" ]; then
    echo -e "${YELLOW}⚠️  Directory not found: $WORKSPACE_PATH${NC}"
    echo "Please make sure you've downloaded the project first."
    exit 1
fi

echo ""

# Step 7: Copy custom action files
echo "=========================================="
echo "Step 7: Copying Custom Actions"
echo "=========================================="
echo ""

TARGET_DIR="$WORKSPACE_PATH/lib/custom_code/actions"

if [ ! -d "$TARGET_DIR" ]; then
    echo "Creating actions directory..."
    mkdir -p "$TARGET_DIR"
fi

echo "Copying action files to workspace..."
cp vscode-extension-ready/lib/custom_code/actions/*.dart "$TARGET_DIR/"

echo -e "${GREEN}✅ Copied 3 action files:${NC}"
ls -1 "$TARGET_DIR"/*.dart | xargs -n1 basename
echo ""

# Step 8: Start code editing session
echo "=========================================="
echo "Step 8: Start Code Editing Session"
echo "=========================================="
echo ""
echo "In VS Code:"
echo "1. Open the workspace folder: $WORKSPACE_PATH"
echo "2. Open Command Palette"
echo "3. Run: 'FlutterFlow: Start Code Editing Session'"
echo "4. Wait for session to initialize"
echo ""
read -p "Press Enter when session is started..."
echo ""

# Step 9: Push to FlutterFlow
echo "=========================================="
echo "Step 9: Push Custom Actions to FlutterFlow"
echo "=========================================="
echo ""
echo "In VS Code:"
echo "1. Open Command Palette"
echo "2. Run: 'FlutterFlow: Push to FlutterFlow'"
echo "3. Wait for upload (≤2 minutes)"
echo "4. Watch for success message"
echo ""
echo -e "${YELLOW}This will create 3 new Custom Actions in your FlutterFlow project.${NC}"
echo ""
read -p "Press Enter when push is complete..."
echo ""

# Step 10: Verify
echo "=========================================="
echo "Step 10: Verify in FlutterFlow UI"
echo "=========================================="
echo ""
echo "1. Open https://app.flutterflow.io/project/${PROJECT_ID}"
echo "2. Navigate to: Custom Code → Actions"
echo "3. Verify you see:"
echo "   ✓ initializeUserSession"
echo "   ✓ checkAndLogRecipeCompletion"
echo "   ✓ checkScrollCompletion"
echo "4. Check for 0 compile errors"
echo ""
read -p "Press Enter when verified..."
echo ""

# Success
echo "=========================================="
echo -e "${GREEN}✅ VS Code Extension Setup Complete!${NC}"
echo "=========================================="
echo ""
echo "Next Steps:"
echo "1. Wire actions to pages (see guide below)"
echo "2. Deploy Firebase backend: ./scripts/deploy-d7-retention-complete.sh"
echo "3. Test end-to-end"
echo ""
echo "Wiring Guide:"
echo "  - HomePage OnLoad: initializeUserSession"
echo "  - login page (after auth): initializeUserSession"
echo "  - GoldenPath OnLoad: initializeUserSession"
echo "  - RecipeViewPage OnLoad: Set recipe tracking variables"
echo "  - RecipeViewPage button: checkAndLogRecipeCompletion"
echo ""
echo "Complete instructions: docs/VSCODE_EXTENSION_DEPLOYMENT_GUIDE.md"
echo ""
echo "=========================================="
