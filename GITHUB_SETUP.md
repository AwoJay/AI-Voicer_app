# GitHub Repository Setup Guide

This document outlines what files should and should NOT be committed to GitHub.

## ❌ DO NOT COMMIT TO GITHUB (Should be in .gitignore)

### 1. **Build Artifacts & Generated Files**
```
/build/                    # All build outputs
/android/app/debug/        # Debug builds
/android/app/profile/      # Profile builds
/android/app/release/      # Release builds
/android/build/            # Android build cache
/android/.gradle/          # Gradle cache
/android/local.properties  # Contains local SDK paths (user-specific)
```

### 2. **IDE & Editor Files**
```
.idea/                     # IntelliJ/Android Studio settings
*.iml                      # IntelliJ module files
.vscode/                   # VS Code settings (optional - can be committed if team uses it)
*.swp                      # Vim swap files
*.swo                      # Vim swap files
.DS_Store                  # macOS system files
```

### 3. **Dependencies & Caches**
```
.dart_tool/                # Dart tool cache
.packages                  # Generated package file
.pub-cache/                # Pub cache
.pub/                      # Pub build cache
.flutter-plugins           # Generated plugin registry
.flutter-plugins-dependencies
```

### 4. **Sensitive Configuration Files**
```
lib/config/supabase_config.dart  # ⚠️ CONTAINS API KEYS - DO NOT COMMIT
android/local.properties          # Contains local paths
ios/Runner/GoogleService-Info.plist  # If using Firebase (if present)
*.env                            # Environment files
*.key                            # Private keys
*.p12                            # Certificates
*.keystore                       # Android signing keys
```

### 5. **Platform-Specific Generated Files**
```
ios/Flutter/ephemeral/           # iOS ephemeral files
ios/Pods/                        # CocoaPods dependencies
ios/.symlinks/                   # iOS symlinks
macos/Flutter/ephemeral/          # macOS ephemeral files
```

### 6. **Test & Coverage**
```
/coverage/                       # Test coverage reports
*.coverage                       # Coverage files
```

### 7. **Logs & Temporary Files**
```
*.log                            # Log files
*.tmp                            # Temporary files
*.cache                          # Cache files
```

---

## ✅ SHOULD BE COMMITTED TO GITHUB

### 1. **Source Code**
```
lib/                            # All Dart source files (EXCEPT supabase_config.dart)
  ├── main.dart
  ├── models/
  ├── providers/
  ├── screens/
  └── config/                   # ⚠️ But NOT supabase_config.dart with real keys
```

### 2. **Configuration Files**
```
pubspec.yaml                    # Dependencies
pubspec.lock                    # Locked dependency versions
analysis_options.yaml           # Linter rules
.gitignore                      # Git ignore rules
README.md                       # Project documentation
```

### 3. **Platform Configuration**
```
android/
  ├── app/build.gradle.kts      # Build configuration
  ├── build.gradle.kts          # Project build config
  ├── gradle.properties         # Gradle properties
  ├── settings.gradle.kts       # Gradle settings
  ├── gradle/wrapper/           # Gradle wrapper (JAR & properties)
  ├── gradlew                   # Gradle wrapper script
  ├── gradlew.bat               # Gradle wrapper script (Windows)
  └── app/src/                  # Android source files
      └── main/
          ├── AndroidManifest.xml
          ├── kotlin/
          └── res/

ios/
  ├── Runner/                   # iOS app source
  │   ├── AppDelegate.swift
  │   ├── Info.plist
  │   └── Assets.xcassets/
  ├── Runner.xcodeproj/         # Xcode project
  └── Runner.xcworkspace/       # Xcode workspace

web/                            # Web platform files
linux/                          # Linux platform files
macos/                          # macOS platform files (except ephemeral)
windows/                        # Windows platform files
```

### 4. **Assets**
```
images/                         # Image assets
  ├── ai voi.jpeg
  ├── ai.jpeg
  └── voice.jpeg
```

### 5. **Documentation**
```
README.md                       # Main project readme
SUPABASE_SETUP.md              # Setup instructions
SUPABASE_PROJECTS_SETUP.md     # Database setup
SUPABASE_PROJECTS_TABLE.sql    # Database schema
GOOGLE_OAUTH_SETUP.md          # OAuth setup guide
FIX_EMULATOR_STORAGE.md        # Troubleshooting guides
FIX_FILE_PICKER_ERROR.md
FIX_LOCALHOST_ERROR.md
OAUTH_TROUBLESHOOTING.md
EMULATOR_FIX.md
```

### 6. **Tests**
```
test/                           # Test files
  └── widget_test.dart
```

---

## 🔒 SECURITY: Sensitive Files That MUST Be Excluded

### Critical: `lib/config/supabase_config.dart`

**Current Status:** ⚠️ **CONTAINS REAL API KEYS - MUST NOT BE COMMITTED**

This file currently contains:
- Supabase URL: `https://oujwpfrzabipzdkzuzxp.supabase.co`
- Supabase Anon Key: `eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...`

**Solution:** Create a template file instead:

1. **Create `lib/config/supabase_config.dart.example`:**
```dart
/// Supabase configuration template
/// Copy this file to supabase_config.dart and fill in your credentials
class SupabaseConfig {
  static const String supabaseUrl = 'YOUR_SUPABASE_URL_HERE';
  static const String supabaseAnonKey = 'YOUR_SUPABASE_ANON_KEY_HERE';
}
```

2. **Add to .gitignore:**
```
lib/config/supabase_config.dart
```

3. **Commit the template:**
```
lib/config/supabase_config.dart.example
```

---

## 📝 Recommended .gitignore Updates

Your current `.gitignore` is good, but add these:

```gitignore
# Supabase config with real keys
lib/config/supabase_config.dart

# Android local properties (contains user-specific paths)
android/local.properties

# iOS/Mac specific
ios/Pods/
ios/.symlinks/
*.xcuserdata
*.xcworkspace/xcuserdata/

# Additional IDE files
*.swp
*.swo
*~

# Environment files
.env
.env.local
.env.*.local

# Keystore files
*.keystore
*.jks
*.p12
*.key

# Coverage
coverage/
*.lcov
```

---

## 🚀 Setup Checklist Before First Commit

- [ ] Review `lib/config/supabase_config.dart` - ensure it's in `.gitignore`
- [ ] Create `lib/config/supabase_config.dart.example` template
- [ ] Verify `android/local.properties` is ignored
- [ ] Run `flutter clean` to remove build artifacts
- [ ] Check `.gitignore` includes all sensitive files
- [ ] Review all `.md` files - ensure no sensitive info
- [ ] Test that `git status` doesn't show sensitive files

---

## 📋 Files Summary

| File/Folder | Status | Action |
|------------|--------|--------|
| `lib/config/supabase_config.dart` | ⚠️ Contains keys | Add to .gitignore, create template |
| `android/local.properties` | ⚠️ User-specific | Already ignored (good) |
| `build/` | ❌ Build artifacts | Already ignored (good) |
| `*.iml` | ❌ IDE files | Already ignored (good) |
| `.dart_tool/` | ❌ Cache | Already ignored (good) |
| `images/` | ✅ Assets | Commit |
| `lib/` (except config) | ✅ Source code | Commit |
| `pubspec.yaml` | ✅ Dependencies | Commit |
| `*.md` files | ✅ Documentation | Commit |
| `android/app/src/` | ✅ Platform code | Commit |
| `ios/Runner/` | ✅ Platform code | Commit |

---

## 🔍 Verify Before Committing

Run these commands to check what will be committed:

```bash
# See what files are tracked/untracked
git status

# See what would be committed
git add -n .

# Check for sensitive files
git ls-files | grep -E "(config|key|secret|password|token)"
```

---

## ⚠️ If You Already Committed Sensitive Files

If you accidentally committed `supabase_config.dart` with real keys:

1. **Remove from Git history:**
```bash
git rm --cached lib/config/supabase_config.dart
git commit -m "Remove sensitive config file"
```

2. **Add to .gitignore:**
```bash
echo "lib/config/supabase_config.dart" >> .gitignore
git add .gitignore
git commit -m "Add sensitive config to gitignore"
```

3. **Rotate your Supabase keys** (if the repo is public):
   - Go to Supabase Dashboard → Settings → API
   - Generate new anon key
   - Update your local config

---

## 📚 Additional Resources

- [Flutter .gitignore best practices](https://github.com/flutter/flutter/blob/master/.gitignore)
- [GitHub's .gitignore templates](https://github.com/github/gitignore)
- [Supabase Security Best Practices](https://supabase.com/docs/guides/platform/security)

