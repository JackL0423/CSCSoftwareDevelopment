#!/usr/bin/env bash
# Setup Flutter SDK for FlutterFlow VS Code Extension
# This script installs the project-level Flutter SDK required for IntelliSense and validation

set -e

# Configuration
FLUTTER_SDK_DIR="flutter-sdk"
FLUTTER_VERSION="stable"
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

echo "════════════════════════════════════════════════════════════"
echo "  FlutterFlow Project - Flutter SDK Setup"
echo "════════════════════════════════════════════════════════════"
echo ""
echo "This script installs a project-level Flutter SDK for the"
echo "FlutterFlow VS Code Extension to use for IntelliSense,"
echo "code validation, and hot reload."
echo ""
echo "SDK Location: $REPO_ROOT/$FLUTTER_SDK_DIR"
echo "Flutter Version: $FLUTTER_VERSION channel"
echo ""

# Check if flutter-sdk already exists
if [ -d "$REPO_ROOT/$FLUTTER_SDK_DIR" ]; then
    echo "⚠️  Flutter SDK already exists at: $FLUTTER_SDK_DIR/"
    echo ""
    read -p "Do you want to reinstall? This will delete the existing SDK. (y/N): " -n 1 -r
    echo ""

    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo "Removing existing Flutter SDK..."
        rm -rf "$REPO_ROOT/$FLUTTER_SDK_DIR"
    else
        echo "Keeping existing Flutter SDK. Verifying installation..."
        cd "$REPO_ROOT/$FLUTTER_SDK_DIR"
        ./bin/flutter --version
        echo ""
        echo "✅ Flutter SDK is already installed and working!"
        exit 0
    fi
fi

echo "────────────────────────────────────────────────────────────"
echo "Step 1: Cloning Flutter SDK from GitHub"
echo "────────────────────────────────────────────────────────────"
echo ""

cd "$REPO_ROOT"
git clone https://github.com/flutter/flutter.git "$FLUTTER_SDK_DIR"

echo ""
echo "────────────────────────────────────────────────────────────"
echo "Step 2: Switching to $FLUTTER_VERSION channel"
echo "────────────────────────────────────────────────────────────"
echo ""

cd "$FLUTTER_SDK_DIR"
git checkout "$FLUTTER_VERSION"

echo ""
echo "────────────────────────────────────────────────────────────"
echo "Step 3: Running Flutter doctor (first run - downloads Dart SDK)"
echo "────────────────────────────────────────────────────────────"
echo ""

./bin/flutter --version
./bin/flutter doctor

echo ""
echo "────────────────────────────────────────────────────────────"
echo "Step 4: Verifying VS Code settings"
echo "────────────────────────────────────────────────────────────"
echo ""

VSCODE_SETTINGS="$REPO_ROOT/c_s_c305_capstone/.vscode/settings.json"

if [ -f "$VSCODE_SETTINGS" ]; then
    if grep -q "flutter-sdk" "$VSCODE_SETTINGS"; then
        echo "✓ VS Code workspace settings correctly reference flutter-sdk/"
    else
        echo "⚠️  Warning: VS Code settings may need updating"
        echo "   File: c_s_c305_capstone/.vscode/settings.json"
        echo "   Should contain: \"dart.flutterSdkPath\": \"../flutter-sdk\""
    fi
else
    echo "ℹ️  VS Code workspace settings not found (will be created when FlutterFlow project is downloaded)"
fi

echo ""
echo "════════════════════════════════════════════════════════════"
echo "✅ Flutter SDK Setup Complete!"
echo "════════════════════════════════════════════════════════════"
echo ""
echo "Flutter SDK installed at: $FLUTTER_SDK_DIR/"
echo "Version: $(cd "$REPO_ROOT/$FLUTTER_SDK_DIR" && ./bin/flutter --version | head -1)"
echo ""
echo "Next steps:"
echo "  1. Restart VS Code to pick up the new Flutter SDK"
echo "  2. Open the c_s_c305_capstone/ directory in VS Code"
echo "  3. FlutterFlow VS Code Extension should now have IntelliSense"
echo ""
echo "Note: The flutter-sdk/ directory is gitignored and won't be"
echo "      committed to the repository."
echo ""
