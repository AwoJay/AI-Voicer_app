#!/bin/bash

# Comprehensive script to fix all Flutter errors
# This script fixes permissions and installs packages

echo "=========================================="
echo "Flutter Project Error Fix Script"
echo "=========================================="
echo ""

# Step 1: Fix Flutter permissions
echo "Step 1: Fixing Flutter permissions..."
echo "You may be prompted for your password."
sudo chown -R $(whoami) /opt/homebrew/Caskroom/flutter/3.29.1/flutter/bin/cache

if [ $? -eq 0 ]; then
    echo "✅ Permissions fixed successfully!"
else
    echo "❌ Failed to fix permissions. Please run manually:"
    echo "   sudo chown -R \$(whoami) /opt/homebrew/Caskroom/flutter/3.29.1/flutter/bin/cache"
    exit 1
fi

echo ""

# Step 2: Navigate to project directory
echo "Step 2: Navigating to project directory..."
cd "/Users/apple/Victor 1.0/awojay/AI-Voicer_app"

if [ $? -ne 0 ]; then
    echo "❌ Failed to navigate to project directory"
    exit 1
fi

echo "✅ In project directory: $(pwd)"
echo ""

# Step 3: Clean Flutter build
echo "Step 3: Cleaning Flutter build cache..."
flutter clean

if [ $? -eq 0 ]; then
    echo "✅ Build cache cleaned!"
else
    echo "⚠️  Warning: flutter clean had issues, but continuing..."
fi

echo ""

# Step 4: Get Flutter packages
echo "Step 4: Installing Flutter packages..."
flutter pub get

if [ $? -eq 0 ]; then
    echo "✅ Packages installed successfully!"
else
    echo "❌ Failed to install packages"
    exit 1
fi

echo ""

# Step 5: Analyze code
echo "Step 5: Analyzing code for errors..."
flutter analyze

if [ $? -eq 0 ]; then
    echo "✅ No errors found!"
else
    echo "⚠️  Some warnings/errors found, but packages are installed"
fi

echo ""
echo "=========================================="
echo "Setup Complete!"
echo "=========================================="
echo ""
echo "You can now run the app with:"
echo "  flutter run"
echo ""
echo "Or open it in your IDE and the errors should be resolved."

