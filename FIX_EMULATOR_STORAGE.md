# Fix Android Emulator Insufficient Storage Error

## Error Message
```
INSTALL_FAILED_INSUFFICIENT_STORAGE: Failed to override installation location
```

This error occurs when the Android emulator runs out of storage space.

## Quick Fixes

### Solution 1: Clear Emulator Storage (Recommended)

1. **Close the emulator completely**
2. **Open Android Studio**
3. Go to **Tools → AVD Manager**
4. Find your emulator (e.g., "sdk gphone64 x86 64")
5. Click the dropdown arrow (▼) next to it
6. Select **"Wipe Data"**
7. Confirm the action
8. Start the emulator again
9. Run `flutter run`

### Solution 2: Free Up Space via ADB

Run these commands to free up space:

```bash
# Check storage
adb shell df -h

# Clear app cache
adb shell pm trim-caches 500M

# Uninstall unused apps (optional)
adb uninstall com.example.unused_app
```

### Solution 3: Increase Emulator Storage

1. **Open Android Studio**
2. Go to **Tools → AVD Manager**
3. Click **Edit** (pencil icon) next to your emulator
4. Click **Show Advanced Settings**
5. Increase **Internal Storage** (e.g., from 2GB to 4GB or more)
6. Click **Finish**
7. Restart the emulator

### Solution 4: Use a Physical Device

If the emulator continues to have issues:
1. Connect a physical Android device via USB
2. Enable **Developer Options** and **USB Debugging** on the device
3. Run `flutter devices` to see connected devices
4. Run `flutter run` - it will use the physical device

### Solution 5: Clean Build and Reinstall

```bash
cd voicer_app
flutter clean
flutter pub get
flutter run
```

## Prevention

- Regularly wipe emulator data when storage gets low
- Increase emulator storage when creating new AVDs
- Use physical devices for testing when possible

