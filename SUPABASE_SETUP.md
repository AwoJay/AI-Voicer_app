# Supabase Setup Guide

## 1. Create a Supabase Project

1. Go to [https://supabase.com](https://supabase.com)
2. Sign up or log in
3. Create a new project
4. Wait for the project to be set up (takes a few minutes)

## 2. Get Your Credentials

1. Go to your project settings
2. Navigate to "API" section
3. Copy your:
   - **Project URL** (e.g., `https://xxxxx.supabase.co`)
   - **anon/public key** (starts with `eyJ...`)

## 3. Update Configuration

Open `lib/config/supabase_config.dart` and replace:

```dart
static const String supabaseUrl = 'YOUR_SUPABASE_URL';
static const String supabaseAnonKey = 'YOUR_SUPABASE_ANON_KEY';
```

With your actual credentials.

## 4. Create Database Table

Run this SQL in your Supabase SQL Editor:

```sql
-- Create profiles table
CREATE TABLE IF NOT EXISTS profiles (
  id UUID REFERENCES auth.users(id) PRIMARY KEY,
  email TEXT,
  role TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Enable Row Level Security
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;

-- Create policy to allow users to read their own profile
CREATE POLICY "Users can view own profile"
  ON profiles FOR SELECT
  USING (auth.uid() = id);

-- Create policy to allow users to update their own profile
CREATE POLICY "Users can update own profile"
  ON profiles FOR UPDATE
  USING (auth.uid() = id);

-- Create policy to allow users to insert their own profile
CREATE POLICY "Users can insert own profile"
  ON profiles FOR INSERT
  WITH CHECK (auth.uid() = id);
```

## 5. Configure OAuth Providers (Optional)

To enable social login, configure OAuth providers in Supabase:

### Step 1: Add Redirect URL in Supabase Dashboard

**CRITICAL:** This must be done first!

1. Go to your Supabase project dashboard
2. Navigate to **Authentication** > **URL Configuration**
3. Under **Redirect URLs**, click **Add URL**
4. Add: `io.supabase.voicer://login-callback`
5. Click **Save**

**Important:** Do NOT use `localhost:3000` or `http://localhost:3000` - this will not work on mobile devices!

### Step 2: Configure OAuth Providers

#### For Google OAuth (Detailed Guide):

See `GOOGLE_OAUTH_SETUP.md` for complete step-by-step instructions.

**Quick Summary:**
1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Create OAuth 2.0 Client ID (Web application type)
3. Add authorized redirect URI: `https://oujwpfrzabipzdkzuzxp.supabase.co/auth/v1/callback`
4. Copy Client ID and Client Secret
5. In Supabase: **Authentication** > **Providers** > **Google**
   - Enable Google
   - Paste Client ID and Client Secret
   - Save

**Important:** The redirect URI in Google Console should be: `https://oujwpfrzabipzdkzuzxp.supabase.co/auth/v1/callback` (Supabase's callback URL), NOT the app's deep link.

#### For Other Providers:

1. Go to **Authentication** > **Providers** in Supabase
2. Enable the providers you want (Apple, Facebook, Twitter)
3. Follow their setup instructions
4. **In each OAuth provider's settings**, add Supabase's callback URL:
   - **Apple**: Apple Developer Portal > Services IDs > Your Service ID > Redirect URLs
     - Add: `https://oujwpfrzabipzdkzuzxp.supabase.co/auth/v1/callback`
   - **Facebook**: Facebook Developers > Your App > Settings > Basic > Valid OAuth Redirect URIs
     - Add: `https://oujwpfrzabipzdkzuzxp.supabase.co/auth/v1/callback`
   - **Twitter**: Twitter Developer Portal > Your App > Settings > Callback URLs
     - Add: `https://oujwpfrzabipzdkzuzxp.supabase.co/auth/v1/callback`

## 6. Update Android Configuration

Add to `android/app/src/main/AndroidManifest.xml`:

```xml
<activity
    android:name="com.supabase.flutter.MainActivity"
    android:launchMode="singleTop">
    <intent-filter>
        <action android:name="android.intent.action.VIEW" />
        <category android:name="android.intent.category.DEFAULT" />
        <category android:name="android.intent.category.BROWSABLE" />
        <data android:scheme="io.supabase.voicer" />
    </intent-filter>
</activity>
```

## 7. Update iOS Configuration

Add to `ios/Runner/Info.plist`:

```xml
<key>CFBundleURLTypes</key>
<array>
    <dict>
        <key>CFBundleTypeRole</key>
        <string>Editor</string>
        <key>CFBundleURLSchemes</key>
        <array>
            <string>io.supabase.voicer</string>
        </array>
    </dict>
</array>
```

## 8. Run the App

```bash
flutter pub get
flutter run
```


