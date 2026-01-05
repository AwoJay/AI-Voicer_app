# Building APK and IPA Files for Testing

This guide explains how to build release versions of the app for testing on physical Android and iOS devices.

## Prerequisites

### For Android:
- Flutter SDK installed
- Android SDK installed
- Java Development Kit (JDK) installed

### For iOS:
- macOS (required)
- Xcode installed from App Store
- Apple Developer account (for distribution, not needed for local testing)
- CocoaPods installed (`sudo gem install cocoapods`)

## Quick Build

Run the automated build script:

```bash
cd "/Users/apple/Victor 1.0/awojay/AI-Voicer_app"
chmod +x build_release.sh
./build_release.sh
```

This will create:
- **Android APK**: `build_output/voicer_app-release.apk`
- **Android AAB**: `build_output/voicer_app-release.aab` (for Play Store)
- **iOS IPA**: `build_output/voicer_app-release.ipa` (if on macOS with Xcode)

## Manual Build Commands

### Android APK

```bash
cd "/Users/apple/Victor 1.0/awojay/AI-Voicer_app"

# Clean previous builds
flutter clean

# Get dependencies
flutter pub get

# Build release APK
flutter build apk --release

# The APK will be at:
# build/app/outputs/flutter-apk/app-release.apk
```

### Android App Bundle (AAB)

For Google Play Store submission:

```bash
flutter build appbundle --release

# The AAB will be at:
# build/app/outputs/bundle/release/app-release.aab
```

### iOS IPA

**Note:** Requires macOS and Xcode

```bash
cd "/Users/apple/Victor 1.0/awojay/AI-Voicer_app"

# Install iOS dependencies
cd ios
pod install
cd ..

# Build iOS IPA
flutter build ipa --release

# The IPA will be at:
# build/ios/ipa/voicer_app.ipa
```

## Installing on Devices

### Android

**Option 1: Using ADB (Android Debug Bridge)**
```bash
# Connect your Android device via USB
# Enable USB Debugging in Developer Options

adb install build/app/outputs/flutter-apk/app-release.apk
```

**Option 2: Manual Installation**
1. Transfer the APK file to your Android device (via email, cloud storage, etc.)
2. On your device, open the APK file
3. Allow installation from unknown sources if prompted
4. Install the app

**Option 3: Using QR Code**
1. Upload APK to a file sharing service
2. Generate a QR code with the download link
3. Scan with your Android device

### iOS

**Option 1: Using Xcode**
1. Open `ios/Runner.xcworkspace` in Xcode
2. Connect your iPhone via USB
3. Select your device in Xcode
4. Click the Run button

**Option 2: Using TestFlight (for distribution)**
1. Build and upload to App Store Connect
2. Add testers in TestFlight
3. Testers receive email invitation

**Option 3: Using Ad Hoc Distribution**
1. Register device UDID in Apple Developer Portal
2. Build with ad hoc provisioning profile
3. Install via Xcode or Apple Configurator

## Build Variants

### Debug Build (for development)
```bash
flutter build apk --debug
# or
flutter build ios --debug
```

### Profile Build (for performance testing)
```bash
flutter build apk --profile
# or
flutter build ios --profile
```

### Release Build (for production)
```bash
flutter build apk --release
# or
flutter build ios --release
```

## Troubleshooting

### Android Build Issues

**Error: "Gradle build failed"**
- Check Android SDK is properly installed
- Run `flutter doctor` to check setup
- Try `flutter clean` and rebuild

**Error: "SDK location not found"**
- Set `ANDROID_HOME` environment variable
- Or create `android/local.properties` with:
  ```
  sdk.dir=/path/to/android/sdk
  ```

### iOS Build Issues

**Error: "No valid code signing certificates"**
- Open Xcode and sign in with Apple ID
- Go to Xcode → Settings → Accounts
- Download certificates

**Error: "CocoaPods not installed"**
```bash
sudo gem install cocoapods
cd ios
pod install
```

**Error: "Provisioning profile issues"**
- Open project in Xcode
- Select Runner target
- Go to Signing & Capabilities
- Select your team and let Xcode manage signing

## File Locations

After building, files will be located at:

- **Android APK**: `build/app/outputs/flutter-apk/app-release.apk`
- **Android AAB**: `build/app/outputs/bundle/release/app-release.aab`
- **iOS IPA**: `build/ios/ipa/voicer_app.ipa`

The build script copies these to `build_output/` for easy access.

## Sharing Builds

### For Android:
- Upload APK to Google Drive, Dropbox, or similar
- Share download link
- Users can install directly from link

### For iOS:
- Use TestFlight for beta testing (recommended)
- Or use ad hoc distribution with registered devices
- Note: IPA files can only be installed on registered devices

## Next Steps

1. **Test on physical devices** - Install and test all features
2. **Performance testing** - Use profile builds to check performance
3. **Beta testing** - Share with testers for feedback
4. **App Store submission** - Use AAB for Play Store, IPA for App Store

## Notes

- Release builds are optimized and smaller than debug builds
- APK files can be installed on any Android device
- IPA files require device registration or TestFlight
- Always test on physical devices before release

