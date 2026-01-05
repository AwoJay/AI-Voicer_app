# Quick Start: Building APK for Testing

## The Issue
The build encountered a network error while downloading Gradle dependencies. This is usually temporary and can be resolved.

## Solution 1: Retry the Build

Sometimes network issues are temporary. Try again:

```bash
cd "/Users/apple/Victor 1.0/awojay/AI-Voicer_app"
flutter build apk --release
```

## Solution 2: Build with Better Network Connection

If you're on a slow or unstable network:

1. **Use a stable internet connection**
2. **Wait for Gradle to finish downloading** (first build takes longer)
3. **Retry the build**

## Solution 3: Build Debug APK (Faster, for Testing)

For quick testing, you can build a debug APK which is faster:

```bash
cd "/Users/apple/Victor 1.0/awojay/AI-Voicer_app"
flutter build apk --debug
```

The debug APK will be at: `build/app/outputs/flutter-apk/app-debug.apk`

**Note:** Debug APKs are larger but work fine for testing on physical devices.

## Solution 4: Manual Build Steps

If automated build fails, try step by step:

```bash
# 1. Navigate to project
cd "/Users/apple/Victor 1.0/awojay/AI-Voicer_app"

# 2. Clean and get dependencies
flutter clean
flutter pub get

# 3. Build APK (this may take 5-10 minutes first time)
flutter build apk --release

# 4. Find your APK
# Location: build/app/outputs/flutter-apk/app-release.apk
```

## Installing the APK on Your Android Device

Once you have the APK file:

### Method 1: USB/ADB
```bash
# Connect device via USB, enable USB debugging
adb install build/app/outputs/flutter-apk/app-release.apk
```

### Method 2: Transfer and Install
1. Copy APK to your device (email, cloud storage, etc.)
2. Open file manager on device
3. Tap the APK file
4. Allow "Install from unknown sources" if prompted
5. Install

### Method 3: Share via QR Code
1. Upload APK to Google Drive or similar
2. Get shareable link
3. Generate QR code from link
4. Scan with device and download

## Expected Build Time

- **First build**: 5-15 minutes (downloads dependencies)
- **Subsequent builds**: 2-5 minutes

## Troubleshooting Network Issues

If you keep getting network errors:

1. **Check internet connection**
2. **Try using a VPN** (sometimes helps with Maven repository access)
3. **Use mobile hotspot** if WiFi is problematic
4. **Wait and retry** - Maven repositories can be temporarily unavailable

## Alternative: Use Android Studio

If command line builds fail:

1. Open project in Android Studio
2. Go to **Build → Build Bundle(s) / APK(s) → Build APK(s)**
3. Wait for build to complete
4. APK will be in `app/build/outputs/apk/release/`

## File Size

- **Debug APK**: ~50-100 MB
- **Release APK**: ~20-40 MB (optimized)

Both work on physical devices for testing.

## Next Steps After Building

1. ✅ Test on physical Android device
2. ✅ Test all features (login, audio upload, etc.)
3. ✅ Check performance
4. ✅ Share with testers if needed

## For iOS Build

iOS builds require:
- macOS (you're on macOS ✅)
- Xcode installed
- Apple Developer account (for distribution)

To build iOS:
```bash
flutter build ipa --release
```

See `BUILD_INSTRUCTIONS.md` for detailed iOS setup.

