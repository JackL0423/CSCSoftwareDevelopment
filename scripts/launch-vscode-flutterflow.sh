#!/usr/bin/env bash
# Launch VS Code with FlutterFlow API token from GCP Secret Manager
# This avoids hardcoding the token in VS Code settings.json
#
# Usage: ./scripts/launch-vscode-flutterflow.sh

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
FLUTTERFLOW_PROJECT_DIR="$PROJECT_ROOT/c_s_c305_capstone"

echo "════════════════════════════════════════════════════════════"
echo "  Launch VS Code with FlutterFlow Extension (Secure)"
echo "════════════════════════════════════════════════════════════"
echo ""

# Check if FlutterFlow project directory exists
if [ ! -d "$FLUTTERFLOW_PROJECT_DIR" ]; then
    echo "Error: FlutterFlow project not found at: $FLUTTERFLOW_PROJECT_DIR"
    echo ""
    echo "Run './scripts/setup-vscode-deployment.sh' first to download the project."
    exit 1
fi

# Fetch API token from Secret Manager
echo "🔐 Retrieving FlutterFlow API token from Secret Manager..."
FLUTTERFLOW_API_TOKEN=$(gcloud secrets versions access latest \
    --secret="FLUTTERFLOW_LEAD_API_TOKEN" \
    --project=csc305project-475802 2>/dev/null)

if [ -z "$FLUTTERFLOW_API_TOKEN" ]; then
    echo "❌ Error: Failed to retrieve API token from Secret Manager"
    echo ""
    echo "Troubleshooting:"
    echo "  1. Verify you're authenticated: gcloud auth list"
    echo "  2. Verify secret exists: gcloud secrets list --project=csc305project-475802"
    echo "  3. Re-authenticate: gcloud auth login"
    exit 1
fi

echo "✅ API token retrieved successfully"
echo ""

# Check VS Code installation
if [ -x "/snap/bin/code" ]; then
    VSCODE_BIN="/snap/bin/code"
elif command -v code &> /dev/null; then
    VSCODE_BIN="code"
else
    echo "❌ Error: VS Code not found"
    echo ""
    echo "Install VS Code:"
    echo "  sudo snap install code --classic"
    exit 1
fi

echo "🚀 Launching VS Code with FlutterFlow project..."
echo "   Project: $FLUTTERFLOW_PROJECT_DIR"
echo "   Token: ${FLUTTERFLOW_API_TOKEN:0:10}... (loaded from Secret Manager)"
echo ""

# Launch VS Code with token as environment variable
# The FlutterFlow extension should check process.env.FLUTTERFLOW_API_TOKEN
# Note: If extension doesn't support env vars, you'll need to enter token manually
export FLUTTERFLOW_API_TOKEN="$FLUTTERFLOW_API_TOKEN"
cd "$FLUTTERFLOW_PROJECT_DIR"
"$VSCODE_BIN" . &

echo ""
echo "════════════════════════════════════════════════════════════"
echo "✅ VS Code Launched"
echo "════════════════════════════════════════════════════════════"
echo ""
echo "⚠️  IMPORTANT: FlutterFlow Extension Token Configuration"
echo ""
echo "The FlutterFlow VS Code extension requires the API token to be"
echo "configured. Since we're using Secret Manager, you have two options:"
echo ""
echo "Option 1 - Environment Variable (If Extension Supports It):"
echo "  The token is available as: \$FLUTTERFLOW_API_TOKEN"
echo "  If the extension checks environment variables, it should work automatically."
echo ""
echo "Option 2 - Manual Entry (One-time Setup):"
echo "  1. In VS Code, press Ctrl+Shift+P (Command Palette)"
echo "  2. Search: 'Preferences: Open Settings (UI)'"
echo "  3. Search: 'flutterflow'"
echo "  4. Find: 'FlutterFlow: User Api Token'"
echo "  5. Click 'Edit in settings.json'"
echo "  6. Add ONLY for this workspace (c_s_c305_capstone/.vscode/settings.json):"
echo "     \"flutterflow.userApiToken\": \"\${env:FLUTTERFLOW_API_TOKEN}\""
echo ""
echo "Option 3 - Per-Session (Most Secure, Requires Re-entry):"
echo "  Enter the token when prompted by the extension."
echo "  Token is available in terminal: echo \$FLUTTERFLOW_API_TOKEN"
echo ""
echo "Next Steps:"
echo "  1. Use Command Palette: 'FlutterFlow: Push to FlutterFlow'"
echo "  2. Verify in FlutterFlow UI: Custom Code → Actions"
echo "  3. Should see 3 actions with 0 compile errors"
echo ""
