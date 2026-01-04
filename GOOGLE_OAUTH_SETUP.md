# Google OAuth Setup Guide

## Step 1: Get Google OAuth Credentials

### 1. Go to Google Cloud Console

1. Visit: https://console.cloud.google.com/
2. Sign in with your Google account
3. Create a new project or select an existing one

### 2. Enable Google+ API

1. In the left sidebar, go to **APIs & Services** > **Library**
2. Search for "Google+ API" or "Google Identity"
3. Click on it and click **Enable**

### 3. Create OAuth 2.0 Credentials

1. Go to **APIs & Services** > **Credentials**
2. Click **+ CREATE CREDENTIALS** at the top
3. Select **OAuth client ID**

### 4. Configure OAuth Consent Screen (First Time Only)

If this is your first time:
1. You'll be prompted to configure the OAuth consent screen
2. Choose **External** (unless you have a Google Workspace)
3. Fill in:
   - **App name**: Voicer (or your app name)
   - **User support email**: Your email
   - **Developer contact information**: Your email
4. Click **Save and Continue**
5. Skip **Scopes** (click **Save and Continue**)
6. Add test users if needed, then click **Save and Continue**
7. Review and click **Back to Dashboard**

### 5. Create OAuth Client ID

1. Under **Application type**, select **Web application**
2. Give it a name (e.g., "Voicer Web Client")
3. **Authorized JavaScript origins**:
   - Add: `https://oujwpfrzabipzdkzuzxp.supabase.co`
4. **Authorized redirect URIs**:
   - Add: `https://oujwpfrzabipzdkzuzxp.supabase.co/auth/v1/callback`
   - This is the Supabase callback URL you mentioned
5. Click **Create**

### 6. Copy Your Credentials

After creating, you'll see a popup with:
- **Your Client ID** (looks like: `123456789-abcdefghijklmnop.apps.googleusercontent.com`)
- **Your Client Secret** (looks like: `GOCSPX-abcdefghijklmnopqrstuvwxyz`)

**IMPORTANT**: Copy both of these immediately - you won't see the secret again!

## Step 2: Configure in Supabase

### 1. Go to Supabase Dashboard

1. Visit: https://supabase.com/dashboard
2. Select your project

### 2. Configure Google Provider

1. Go to **Authentication** > **Providers**
2. Find **Google** in the list
3. Click to enable it
4. Enter:
   - **Client ID (for OAuth)**: Paste your Google Client ID
   - **Client Secret (for OAuth)**: Paste your Google Client Secret
5. Click **Save**

### 3. Configure Redirect URLs

1. Go to **Authentication** > **URL Configuration**
2. Under **Redirect URLs**, make sure you have:
   - `io.supabase.voicer://login-callback` (for mobile app)
   - `https://oujwpfrzabipzdkzuzxp.supabase.co/auth/v1/callback` (for web - this is automatic)

## Step 3: Verify Configuration

### In Google Cloud Console:

1. Go to **APIs & Services** > **Credentials**
2. Click on your OAuth 2.0 Client ID
3. Under **Authorized redirect URIs**, you should see:
   - `https://oujwpfrzabipzdkzuzxp.supabase.co/auth/v1/callback`

### In Supabase Dashboard:

1. **Authentication** > **Providers** > **Google** should be enabled
2. **Authentication** > **URL Configuration** should have:
   - `io.supabase.voicer://login-callback`

## Important Notes

- **The Supabase callback URL** (`https://oujwpfrzabipzdkzuzxp.supabase.co/auth/v1/callback`) is what Google redirects to
- **Supabase then redirects** to your app using the deep link (`io.supabase.voicer://login-callback`)
- Both URLs need to be configured correctly for OAuth to work

## Troubleshooting

### "Redirect URI mismatch" error:
- Make sure the redirect URI in Google Console exactly matches: `https://oujwpfrzabipzdkzuzxp.supabase.co/auth/v1/callback`
- No trailing slashes, no typos

### "Invalid client" error:
- Double-check your Client ID and Secret in Supabase
- Make sure you copied them correctly (no extra spaces)

### Still getting localhost error:
- Make sure `io.supabase.voicer://login-callback` is in Supabase > Authentication > URL Configuration
- Remove any localhost URLs from the list

