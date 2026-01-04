# Fix: "localhost:3000 - site can't be reached" Error

## Quick Fix Steps

This error means Supabase is trying to redirect to `localhost:3000` instead of your app's deep link. Here's how to fix it:

### Step 1: Configure Redirect URL in Supabase Dashboard

1. **Go to your Supabase Dashboard**
   - Visit: https://supabase.com/dashboard
   - Select your project

2. **Navigate to Authentication Settings**
   - Click on **Authentication** in the left sidebar
   - Click on **URL Configuration** (or look for "Redirect URLs" section)

3. **Add the Correct Redirect URL**
   - Under **Redirect URLs**, you should see a list
   - Click **"Add URL"** or the **"+"** button
   - Enter: `io.supabase.voicer://login-callback`
   - Click **Save**

4. **Remove localhost URLs (IMPORTANT)**
   - If you see `http://localhost:3000` or `http://127.0.0.1:3000` in the list, **DELETE IT**
   - These won't work on mobile devices
   - Only keep: `io.supabase.voicer://login-callback`

### Step 2: Verify OAuth Provider Settings

For each OAuth provider you're using (Google, Apple, Facebook, Twitter):

1. **In Supabase Dashboard:**
   - Go to **Authentication** > **Providers**
   - Click on the provider (e.g., Google)
   - Check the **Redirect URL** field
   - It should show: `io.supabase.voicer://login-callback`
   - If it shows `localhost:3000`, change it

2. **In the OAuth Provider's Console:**
   - **Google**: Google Cloud Console > Your OAuth Client > Authorized redirect URIs
   - **Apple**: Apple Developer Portal > Your Service ID > Redirect URLs
   - **Facebook**: Facebook Developers > App Settings > Valid OAuth Redirect URIs
   - **Twitter**: Twitter Developer Portal > App Settings > Callback URLs
   
   Add: `io.supabase.voicer://login-callback` to each

### Step 3: Restart Your App

After making changes:
1. Completely close the app
2. Restart it
3. Try OAuth login again

## Why This Happens

- Supabase defaults to `localhost:3000` for web development
- Mobile apps need deep links (like `io.supabase.voicer://login-callback`) instead
- The redirect URL must be configured in Supabase Dashboard, not just in code

## Still Not Working?

1. **Double-check the URL is exactly**: `io.supabase.voicer://login-callback` (no typos)
2. **Check AndroidManifest.xml** - Make sure the deep link intent filter is there (it should be)
3. **Clear app cache** - Sometimes cached redirects cause issues
4. **Check Supabase logs** - Go to Supabase Dashboard > Logs to see what redirect URL is being used

## Visual Guide

In Supabase Dashboard, you should see:

```
Authentication > URL Configuration

Redirect URLs:
✓ io.supabase.voicer://login-callback
✗ http://localhost:3000  (DELETE THIS IF PRESENT)
```

The checkmark (✓) means it's configured correctly, and the X (✗) means delete it.

















