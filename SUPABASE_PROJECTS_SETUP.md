# Supabase Projects Table Setup

This guide explains how to set up the database table for storing text-to-speech projects in Supabase.

## Step 1: Create the Projects Table

1. Go to your Supabase project dashboard: https://supabase.com/dashboard
2. Navigate to **SQL Editor** in the left sidebar
3. Click **New Query**
4. Copy and paste the contents of `SUPABASE_PROJECTS_TABLE.sql` into the editor
5. Click **Run** to execute the SQL

Alternatively, you can run the SQL directly:

```sql
-- Create projects table for storing text-to-speech projects
CREATE TABLE IF NOT EXISTS projects (
  id TEXT PRIMARY KEY,
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL,
  title TEXT NOT NULL,
  file_path TEXT,
  duration_seconds INTEGER NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW() NOT NULL,
  type TEXT NOT NULL CHECK (type IN ('textToSpeech', 'voiceChanger', 'voiceTranslate')),
  audio_url TEXT,
  -- Voice filter fields (for text-to-speech projects)
  voice_language TEXT,
  voice_gender TEXT,
  voice_age_group TEXT
);

-- Create index on user_id for faster queries
CREATE INDEX IF NOT EXISTS idx_projects_user_id ON projects(user_id);

-- Create index on created_at for sorting
CREATE INDEX IF NOT EXISTS idx_projects_created_at ON projects(created_at DESC);

-- Enable Row Level Security
ALTER TABLE projects ENABLE ROW LEVEL SECURITY;

-- Create policy to allow users to view their own projects
CREATE POLICY "Users can view own projects"
  ON projects FOR SELECT
  USING (auth.uid() = user_id);

-- Create policy to allow users to insert their own projects
CREATE POLICY "Users can insert own projects"
  ON projects FOR INSERT
  WITH CHECK (auth.uid() = user_id);

-- Create policy to allow users to update their own projects
CREATE POLICY "Users can update own projects"
  ON projects FOR UPDATE
  USING (auth.uid() = user_id);

-- Create policy to allow users to delete their own projects
CREATE POLICY "Users can delete own projects"
  ON projects FOR DELETE
  USING (auth.uid() = user_id);
```

## Step 2: Verify Table Creation

1. Go to **Table Editor** in the Supabase dashboard
2. You should see a new table called `projects`
3. Verify the columns match the schema above

## Step 3: Test the Integration

1. Run your Flutter app
2. Sign in to your account
3. Create a new text-to-speech project
4. The project should be saved to Supabase automatically
5. Close and reopen the app - your projects should persist

## Features

- **Automatic Storage**: All text-to-speech projects are automatically saved to Supabase
- **User Isolation**: Each user can only see and manage their own projects (Row Level Security)
- **Voice Filter Storage**: Language, gender, and age group are stored with each project
- **Automatic Loading**: Projects are loaded when the app starts
- **Real-time Sync**: Projects are synced with Supabase in real-time

## Troubleshooting

### Projects not saving?

1. Check that you're signed in (projects require authentication)
2. Verify the `projects` table exists in your Supabase dashboard
3. Check the Flutter console for error messages
4. Verify Row Level Security policies are correctly set up

### Projects not loading?

1. Check your internet connection
2. Verify you're signed in with the same account
3. Check the Supabase dashboard to see if projects exist in the table
4. Look for error messages in the Flutter console

### Permission errors?

1. Make sure Row Level Security policies are created correctly
2. Verify the user is authenticated before creating projects
3. Check that the `user_id` matches the authenticated user's ID










