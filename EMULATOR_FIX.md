# Android Emulator Fix Guide

## Error: "Emulator didn't connect within 60 seconds"

This error occurs when the Android emulator fails to start properly. Here are solutions:

## Solution 1: Cold Boot the Emulator

1. Close all emulator instances
2. Open Android Studio
3. Go to **Tools → AVD Manager**
4. Find "Pixel 6" emulator
5. Click the dropdown arrow (▼) next to it
6. Select **"Cold Boot Now"**

## Solution 2: Wipe Emulator Data

1. In AVD Manager, click the dropdown next to "Pixel 6"
2. Select **"Wipe Data"**
3. Confirm the action
4. Try launching again

## Solution 3: Check Hardware Acceleration

### Enable Windows Hypervisor Platform:

1. Open **Control Panel → Programs → Turn Windows features on or off**
2. Enable:
   - ✅ **Windows Hypervisor Platform**
   - ✅ **Virtual Machine Platform**
   - ✅ **Hyper-V** (if available)
3. Restart your computer

### Check BIOS Settings:

1. Restart and enter BIOS (usually F2, F10, or Del during boot)
2. Enable:
   - **Intel Virtualization Technology (VT-x)** or **AMD-V**
3. Save and exit

## Solution 4: Reduce Emulator Resources

1. In AVD Manager, click **Edit** (pencil icon) next to "Pixel 6"
2. Click **Show Advanced Settings**
3. Reduce:
   - **RAM**: Try 2048 MB or 1536 MB (instead of 4096 MB)
   - **VM heap**: 256 MB
   - **Graphics**: Try "Software - GLES 2.0" instead of "Hardware - GLES 2.0"
4. Click **Finish**
5. Try launching again

## Solution 5: Use a Different Emulator

Try using the "Medium Phone API 36.1" emulator which might have better compatibility:

```bash
flutter emulators --launch Medium_Phone_API_36.1
```

## Solution 6: Check System Resources

- **Close other applications** to free up RAM
- Ensure you have at least **8GB free disk space**
- Close Android Studio if not needed

## Solution 7: Recreate the Emulator

If nothing works, create a new emulator:

1. In AVD Manager, delete "Pixel 6"
2. Click **Create Virtual Device**
3. Choose a device (e.g., Pixel 5 or Pixel 4)
4. Select **API 36** system image
5. Click **Finish**
6. Launch the new emulator

## Solution 8: Use a Physical Device

As an alternative, you can use a physical Android device:

1. Enable **Developer Options** on your phone
2. Enable **USB Debugging**
3. Connect via USB
4. Run: `flutter run`

## Quick Test Command

After trying the fixes above, test with:

```bash
flutter emulators --launch Medium_Phone_API_36.1
flutter run
```

## Common Causes:

- **Hyper-V conflicts** with other virtualization software
- **Insufficient RAM** (emulator needs 2-4GB)
- **Corrupted AVD files**
- **Hardware acceleration disabled**
- **Antivirus blocking** emulator processes

