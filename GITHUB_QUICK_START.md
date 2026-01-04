# GitHub Quick Start Checklist

## ✅ Pre-Flight Check

```bash
# 1. Verify sensitive files are NOT tracked
git ls-files | grep supabase_config.dart    # Should return nothing
git ls-files | grep local.properties         # Should return nothing

# 2. Check what will be committed
git status
```

---

## 🚀 Deployment Steps

### 1. Initialize Git (if needed)
```bash
cd voicer_app
git init
```

### 2. Stage Files
```bash
git add .
```

### 3. First Commit
```bash
git commit -m "Initial commit: Voicer app"
```

### 4. Create GitHub Repository
- Go to https://github.com/new
- Name: `voicer-app`
- Choose Private or Public
- **Don't** initialize with README
- Click "Create repository"

### 5. Connect & Push
```bash
# Add remote (replace YOUR_USERNAME)
git remote add origin https://github.com/YOUR_USERNAME/voicer-app.git

# Push to GitHub
git branch -M main
git push -u origin main
```

### 6. Verify Security
- Go to your GitHub repo
- Search for `supabase_config.dart` → Should find nothing
- Search for your API key → Should find nothing
- ✅ `supabase_config.dart.example` should be visible

---

## 🔐 Security Reminder

**Before pushing, ensure:**
- ❌ `lib/config/supabase_config.dart` is NOT in `git status`
- ✅ `lib/config/supabase_config.dart.example` IS in `git status`

---

## 📖 Full Guide

See `GITHUB_DEPLOYMENT.md` for detailed instructions and troubleshooting.

