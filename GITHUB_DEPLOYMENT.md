# GitHub Deployment Guide

This guide will walk you through deploying your Voicer app to GitHub safely.

## 📋 Pre-Deployment Checklist

Before pushing to GitHub, verify these items:

- [x] `.gitignore` is updated with sensitive files
- [x] `lib/config/supabase_config.dart.example` template created
- [ ] `lib/config/supabase_config.dart` exists locally (but is ignored by git)
- [ ] No sensitive data in any committed files
- [ ] All code is working and tested

---

## 🚀 Step-by-Step Deployment

### Step 1: Verify Git Status

First, check if git is already initialized:

```bash
cd voicer_app
git status
```

**If you see "not a git repository":**
```bash
git init
```

**If you see files listed:** Git is already initialized, proceed to Step 2.

---

### Step 2: Check What Will Be Committed

Verify that sensitive files are NOT being tracked:

```bash
# Check if supabase_config.dart is tracked (should return nothing)
git ls-files | grep supabase_config.dart

# Check if local.properties is tracked (should return nothing)
git ls-files | grep local.properties

# See all files that would be committed
git status
```

**Expected result:**
- `lib/config/supabase_config.dart` should NOT appear
- `android/local.properties` should NOT appear
- `build/` folder should NOT appear
- `lib/config/supabase_config.dart.example` SHOULD appear (this is safe to commit)

---

### Step 3: Stage Files for Commit

Add all files except those in `.gitignore`:

```bash
# Add all files (respects .gitignore)
git add .

# Verify what's staged
git status
```

**What should be staged:**
- ✅ All `lib/` source files (except `supabase_config.dart`)
- ✅ `pubspec.yaml` and `pubspec.lock`
- ✅ `lib/config/supabase_config.dart.example` (template)
- ✅ Platform configs (`android/app/src/`, `ios/Runner/`)
- ✅ Documentation files (`.md` files)
- ✅ `images/` assets
- ✅ `.gitignore`

**What should NOT be staged:**
- ❌ `lib/config/supabase_config.dart` (contains real keys)
- ❌ `android/local.properties` (user-specific)
- ❌ `build/` folder
- ❌ `.dart_tool/` folder
- ❌ Any `.iml` files

---

### Step 4: Create Initial Commit

```bash
git commit -m "Initial commit: Voicer app with authentication and TTS features"
```

---

### Step 5: Create GitHub Repository

#### Option A: Using GitHub Website (Recommended)

1. Go to [GitHub.com](https://github.com) and sign in
2. Click the **"+"** icon in the top right → **"New repository"**
3. Fill in the details:
   - **Repository name:** `voicer-app` (or your preferred name)
   - **Description:** "AI Voice App - Text to Speech and Voice Changer"
   - **Visibility:** 
     - Choose **Private** if you want to keep it private
     - Choose **Public** if you want it open source
   - **DO NOT** check "Initialize with README" (you already have files)
   - **DO NOT** add .gitignore or license (you already have them)
4. Click **"Create repository"**

#### Option B: Using GitHub CLI (if installed)

```bash
gh repo create voicer-app --private --source=. --remote=origin --push
```

---

### Step 6: Connect Local Repository to GitHub

After creating the repository on GitHub, you'll see instructions. Use these commands:

```bash
# Add the remote repository (replace YOUR_USERNAME with your GitHub username)
git remote add origin https://github.com/YOUR_USERNAME/voicer-app.git

# Verify the remote was added
git remote -v
```

**Note:** If you used a different repository name, adjust the URL accordingly.

---

### Step 7: Push to GitHub

```bash
# Push to main branch (or master, depending on your default)
git branch -M main
git push -u origin main
```

If you're prompted for credentials:
- **Username:** Your GitHub username
- **Password:** Use a **Personal Access Token** (not your GitHub password)
  - Generate one at: https://github.com/settings/tokens
  - Select scope: `repo` (full control of private repositories)

---

### Step 8: Verify on GitHub

1. Go to your repository on GitHub
2. Verify that:
   - ✅ All source code is there
   - ✅ `lib/config/supabase_config.dart.example` is visible
   - ❌ `lib/config/supabase_config.dart` is NOT visible (it's ignored)
   - ❌ `android/local.properties` is NOT visible
   - ❌ `build/` folder is NOT visible

---

## 🔒 Security Verification

After pushing, double-check that sensitive files are NOT on GitHub:

1. Go to your repository on GitHub
2. Search for `supabase_config.dart` - should return no results
3. Search for your Supabase URL - should return no results
4. Search for your API key - should return no results

If you find any sensitive data:
- **Immediately** rotate your Supabase keys
- Remove the file from git history (see "If You Already Committed Sensitive Files" below)

---

## 📝 Repository Setup for Team Members

When someone clones your repository, they need to:

1. **Clone the repository:**
```bash
git clone https://github.com/YOUR_USERNAME/voicer-app.git
cd voicer-app
```

2. **Copy the template file:**
```bash
cp lib/config/supabase_config.dart.example lib/config/supabase_config.dart
```

3. **Fill in their Supabase credentials:**
   - Open `lib/config/supabase_config.dart`
   - Replace `YOUR_SUPABASE_URL_HERE` with their Supabase URL
   - Replace `YOUR_SUPABASE_ANON_KEY_HERE` with their Supabase anon key

4. **Install dependencies:**
```bash
flutter pub get
```

5. **Run the app:**
```bash
flutter run
```

---

## 🔄 Future Updates

For future changes:

```bash
# Check what changed
git status

# Stage changes
git add .

# Commit with descriptive message
git commit -m "Description of changes"

# Push to GitHub
git push
```

---

## ⚠️ If You Already Committed Sensitive Files

If you accidentally committed `supabase_config.dart` with real keys before setting up `.gitignore`:

### Option 1: Remove from Git History (Recommended)

```bash
# Remove from git tracking (but keep local file)
git rm --cached lib/config/supabase_config.dart

# Commit the removal
git commit -m "Remove sensitive config file from version control"

# Push the change
git push

# IMPORTANT: Rotate your Supabase keys immediately!
```

### Option 2: Use Git Filter-Branch (Advanced)

If the file was committed in previous commits:

```bash
# Remove file from entire git history
git filter-branch --force --index-filter \
  "git rm --cached --ignore-unmatch lib/config/supabase_config.dart" \
  --prune-empty --tag-name-filter cat -- --all

# Force push (WARNING: This rewrites history)
git push origin --force --all
```

**⚠️ Warning:** Force pushing rewrites history. Only do this if:
- The repository is new/private
- You've coordinated with your team
- You've rotated your API keys

---

## 📚 Additional GitHub Features to Set Up

### 1. Add README.md

Create a comprehensive README:

```markdown
# Voicer App

AI-powered voice application with text-to-speech and voice changer features.

## Features

- Text-to-Speech conversion
- AI Voice Changer
- Multiple language support
- User authentication
- Project management

## Setup

1. Clone the repository
2. Copy `lib/config/supabase_config.dart.example` to `lib/config/supabase_config.dart`
3. Fill in your Supabase credentials
4. Run `flutter pub get`
5. Run `flutter run`

## Requirements

- Flutter SDK 3.10.0 or higher
- Supabase account
- Android Studio / Xcode (for mobile development)
```

### 2. Add License

If you want to add a license:

```bash
# Create LICENSE file (e.g., MIT License)
# Then commit it
git add LICENSE
git commit -m "Add MIT license"
git push
```

### 3. Add .github/workflows (Optional)

For CI/CD, create `.github/workflows/` directory with workflow files.

---

## 🎯 Quick Command Reference

```bash
# Initialize git (if not done)
git init

# Check status
git status

# Add all files (respects .gitignore)
git add .

# Commit
git commit -m "Your commit message"

# Add remote
git remote add origin https://github.com/YOUR_USERNAME/REPO_NAME.git

# Push to GitHub
git push -u origin main

# Verify remote
git remote -v
```

---

## ✅ Final Checklist

Before considering deployment complete:

- [ ] Repository created on GitHub
- [ ] Local repository connected to GitHub
- [ ] Initial commit pushed successfully
- [ ] Verified sensitive files are NOT on GitHub
- [ ] `supabase_config.dart.example` is visible on GitHub
- [ ] README.md is updated (optional but recommended)
- [ ] Team members know how to set up the project

---

## 🆘 Troubleshooting

### Error: "remote origin already exists"
```bash
# Remove existing remote
git remote remove origin

# Add new remote
git remote add origin https://github.com/YOUR_USERNAME/REPO_NAME.git
```

### Error: "failed to push some refs"
```bash
# Pull first, then push
git pull origin main --allow-unrelated-histories
git push -u origin main
```

### Error: Authentication failed
- Use Personal Access Token instead of password
- Generate token: https://github.com/settings/tokens
- Use token as password when prompted

---

## 📞 Need Help?

- [GitHub Docs](https://docs.github.com)
- [Git Basics](https://git-scm.com/book/en/v2/Getting-Started-Git-Basics)
- [Flutter Deployment](https://docs.flutter.dev/deployment)

---

**Remember:** Never commit sensitive files! Always verify before pushing.

