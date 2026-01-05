#!/bin/bash

# Script to fix Flutter permissions issue
echo "Fixing Flutter permissions..."
echo "You may be prompted for your password."

# Fix the lockfile permission
sudo chown -R $(whoami) /opt/homebrew/Caskroom/flutter/3.29.1/flutter/bin/cache/lockfile

# Also fix the entire cache directory to prevent future issues
sudo chown -R $(whoami) /opt/homebrew/Caskroom/flutter/3.29.1/flutter/bin/cache

echo "Permissions fixed! You can now run 'flutter pub get' and 'flutter run'"

