# How to Update Flutter Packages

## Step 1: Fix Flutter Permissions (Required First)

Before you can update packages, you need to fix the Flutter permission issue. Run this command in your terminal:

```bash
sudo chown -R $(whoami) /opt/homebrew/Caskroom/flutter/3.29.1/flutter/bin/cache
```

You'll be prompted for your password. This fixes the permission issue that's preventing Flutter from working.

**Alternative:** You can also run the provided script:
```bash
cd "/Users/apple/Victor 1.0/awojay/AI-Voicer_app"
./fix_flutter_permissions.sh
```

## Step 2: Update Packages

Once permissions are fixed, navigate to your project directory and run:

### Option A: Get/Install Packages (Recommended)
This installs packages according to your `pubspec.yaml` and `pubspec.lock`:

```bash
cd "/Users/apple/Victor 1.0/awojay/AI-Voicer_app"
flutter pub get
```

### Option B: Upgrade Packages to Latest Versions
This updates packages to the latest compatible versions within the constraints in `pubspec.yaml`:

```bash
cd "/Users/apple/Victor 1.0/awojay/AI-Voicer_app"
flutter pub upgrade
```

### Option C: Upgrade to Latest Major Versions
This updates packages to the latest versions, even if they're major version updates:

```bash
cd "/Users/apple/Victor 1.0/awojay/AI-Voicer_app"
flutter pub upgrade --major-versions
```

## What Each Command Does

- **`flutter pub get`**: Downloads and installs packages specified in `pubspec.yaml`. Uses versions from `pubspec.lock` if it exists, or resolves compatible versions.
- **`flutter pub upgrade`**: Updates packages to the latest versions that still satisfy the version constraints in `pubspec.yaml`.
- **`flutter pub upgrade --major-versions`**: Updates packages to the latest versions, including major version updates (may have breaking changes).

## Verify Installation

After running any of these commands, you should see output like:
```
Running "flutter pub get" in voicer_app...
Resolving dependencies...
Got dependencies!
```

If you see errors, make sure:
1. You've fixed the permissions (Step 1)
2. You have an internet connection
3. Your `pubspec.yaml` file is valid

## Troubleshooting

If you still get permission errors:
1. Make sure you ran the `sudo chown` command
2. Try restarting your terminal
3. Check that Flutter is properly installed: `flutter doctor`

