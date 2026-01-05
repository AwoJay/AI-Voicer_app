#!/bin/bash

# Build script for generating APK and IPA files for testing
# This script builds release versions of the app for Android and iOS

set -e  # Exit on error

PROJECT_DIR="/Users/apple/Victor 1.0/awojay/AI-Voicer_app"
BUILD_DIR="$PROJECT_DIR/build_output"

echo "=========================================="
echo "Building Release APK and IPA Files"
echo "=========================================="
echo ""

# Navigate to project directory
cd "$PROJECT_DIR"

# Create output directory
mkdir -p "$BUILD_DIR"

# Check if Flutter is accessible
if ! command -v flutter &> /dev/null; then
    echo "❌ Flutter is not installed or not in PATH"
    exit 1
fi

echo "Step 1: Cleaning previous builds..."
flutter clean

echo ""
echo "Step 2: Getting dependencies..."
flutter pub get

echo ""
echo "Step 3: Building Android APK..."
flutter build apk --release

if [ -f "build/app/outputs/flutter-apk/app-release.apk" ]; then
    cp "build/app/outputs/flutter-apk/app-release.apk" "$BUILD_DIR/voicer_app-release.apk"
    echo "✅ Android APK built successfully!"
    echo "   Location: $BUILD_DIR/voicer_app-release.apk"
else
    echo "❌ APK build failed"
    exit 1
fi

echo ""
echo "Step 4: Building Android App Bundle (AAB) for Play Store..."
flutter build appbundle --release

if [ -f "build/app/outputs/bundle/release/app-release.aab" ]; then
    cp "build/app/outputs/bundle/release/app-release.aab" "$BUILD_DIR/voicer_app-release.aab"
    echo "✅ Android App Bundle built successfully!"
    echo "   Location: $BUILD_DIR/voicer_app-release.aab"
fi

echo ""
echo "Step 5: Building iOS IPA (requires macOS and Xcode)..."
if [[ "$OSTYPE" == "darwin"* ]]; then
    if command -v xcodebuild &> /dev/null; then
        flutter build ipa --release
        
        if [ -f "build/ios/ipa/voicer_app.ipa" ]; then
            cp "build/ios/ipa/voicer_app.ipa" "$BUILD_DIR/voicer_app-release.ipa"
            echo "✅ iOS IPA built successfully!"
            echo "   Location: $BUILD_DIR/voicer_app-release.ipa"
        else
            echo "⚠️  iOS build may have failed or requires additional setup"
        fi
    else
        echo "⚠️  Xcode not found. Skipping iOS build."
        echo "   Install Xcode from App Store to build iOS apps"
    fi
else
    echo "⚠️  Not on macOS. Skipping iOS build."
fi

echo ""
echo "=========================================="
echo "Build Complete!"
echo "=========================================="
echo ""
echo "Output files:"
ls -lh "$BUILD_DIR" | grep -E "\.(apk|aab|ipa)$" || echo "No build files found"
echo ""
echo "To install on Android device:"
echo "  adb install $BUILD_DIR/voicer_app-release.apk"
echo ""
echo "Or transfer the APK file to your device and install it manually."

