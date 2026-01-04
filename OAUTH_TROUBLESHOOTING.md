# OAuth Troubleshooting Guide

## Error: "localhost:3000 - site can't be reached"

This error occurs when the OAuth redirect URL is not properly configured in Supabase.

### Solution:

1. **Go to Supabase Dashboard**
   - Navigate to: **Authentication** > **URL Configuration**
   - Under **Redirect URLs**, ensure you have: `io.supabase.voicer://login-callback`
   - If it's not there, click **Add URL** and add it
   - **DO NOT** use `localhost:3000` or `http://localhost:3000`

2. **Verify in OAuth Provider Settings**
   - For each OAuth provider (Google, Apple, Facebook, Twitter), make sure the redirect URL is added in their developer console
   - The URL should be: `io.supabase.voicer://login-callback`

3. **Check Android Configuration**
   - Ensure `android/app/src/main/AndroidManifest.xml` has the deep link intent filter (already added in the code)

4. **Restart the App**
   - After making changes, completely close and restart the app
   - OAuth redirects are cached, so a fresh start is needed

### Common Issues:

- **"Redirect URL mismatch"**: The URL in Supabase must match exactly with what's in the OAuth provider settings
- **"Site can't be reached"**: This means localhost is being used instead of the deep link - check Supabase URL Configuration
- **OAuth opens but doesn't redirect back**: Check that the deep link is properly configured in AndroidManifest.xml

### Testing:

1. Try signing in with an OAuth provider
2. You should be redirected to the provider's login page
3. After authentication, you should be redirected back to the app automatically
4. If you see a browser error about localhost, the redirect URL is not configured correctly

















