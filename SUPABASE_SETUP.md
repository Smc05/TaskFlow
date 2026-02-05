# TaskFlow - Supabase Setup Guide

## Prerequisites
- A Supabase account (sign up at https://supabase.com)
- Flutter SDK installed
- TaskFlow project set up locally

## Step 1: Create Supabase Project

1. Go to [Supabase Dashboard](https://app.supabase.com)
2. Click "New Project"
3. Fill in your project details:
   - Name: TaskFlow (or your preferred name)
   - Database Password: Choose a strong password
   - Region: Select closest to your location
4. Wait for the project to be created (takes ~2 minutes)

## Step 2: Set Up Database Schema

1. In your Supabase project dashboard, navigate to **SQL Editor**
2. Click "New Query"
3. Copy the entire contents of `supabase/schema.sql` from this repository
4. Paste it into the SQL editor
5. Click "Run" to execute the SQL script

This will create:
- Tasks table
- Boards table
- Board Members table
- Necessary indexes for performance
- Row Level Security (RLS) policies
- Database triggers for automatic timestamp updates

## Step 3: Get Your Supabase Credentials

1. In your Supabase dashboard, go to **Settings** > **API**
2. You'll find two important values:
   - **Project URL**: `https://xxxxx.supabase.co`
   - **anon/public key**: A long string starting with `eyJ...`

## Step 4: Configure Flutter App

### Option A: Using Environment Variables (Recommended)

1. Run the app with environment variables:

```bash
flutter run --dart-define=SUPABASE_URL=https://mkgfbkwcakesydvvnxzm.supabase.co --dart-define=SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im1rZ2Zia3djYWtlc3lkdnZueHptIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzAzMTAxODIsImV4cCI6MjA4NTg4NjE4Mn0.poE5xY42yoKOApRN7rtOny49yOPRjQnVdFza8ZVsyjw
```

### Option B: Using a Configuration File

1. Create a file `.env` in the project root:

```env
SUPABASE_URL=https://xxxxx.supabase.co
SUPABASE_ANON_KEY=your_anon_key_here
```

2. Add `.env` to your `.gitignore` to keep credentials private

**Note**: Never commit your actual Supabase credentials to version control!

## Step 5: Enable Authentication (Optional but Recommended)

### For Testing Without Authentication:

You can temporarily disable Row Level Security for testing:

```sql
-- In Supabase SQL Editor
ALTER TABLE tasks DISABLE ROW LEVEL SECURITY;
ALTER TABLE boards DISABLE ROW LEVEL SECURITY;
```

**⚠️ Warning**: Only do this for local testing! Always enable RLS in production.

### For Production with Authentication:

1. In Supabase dashboard, go to **Authentication** > **Providers**
2. Enable "Email" provider
3. Configure email settings
4. In the app, users will need to sign up/sign in before creating tasks

### Create a Test User (if using auth):

```sql
-- This will be handled by Supabase Auth UI in the app
-- Or you can manually create a test user in the Supabase dashboard
```

## Step 6: Create a Default Board

To test the app, create a default board:

1. In Supabase SQL Editor, run:

```sql
-- Replace with your actual user ID if using auth, or any UUID for testing
INSERT INTO boards (id, name, description, owner_id) 
VALUES (
  'default-board'::uuid,
  'My First Board',
  'Default board for testing',
  'your-user-id-here'::uuid  -- Or gen_random_uuid() for testing
);

INSERT INTO board_members (board_id, user_id, role)
VALUES (
  'default-board'::uuid,
  'your-user-id-here'::uuid,  -- Same user ID as above
  'owner'
);
```

**For testing without auth**, you can use a fixed UUID:
```sql
INSERT INTO boards (id, name, description) 
VALUES (
  'default-board'::uuid,
  'My First Board',
  'Default board for testing'
);
```

## Step 7: Test the Application

1. Run the Flutter app:
```bash
flutter run -d chrome  # Or your preferred device
```

2. The app should now:
   - Connect to Supabase
   - Load tasks from the database
   - Sync changes in real-time
   - Show updates instantly across devices

## Testing Real-Time Sync

1. Run the app on two devices or browser windows
2. Drag a task from one column to another on one device
3. Watch it update instantly on the other device!

You can also test by making changes directly in Supabase:
1. Go to **Table Editor** > **tasks**
2. Edit a task's status or title
3. Watch the change appear instantly in your app

## Troubleshooting

### Issue: "Failed to fetch tasks" error

**Solutions:**
- Check your Supabase URL and anon key are correct
- Verify your internet connection
- Check Supabase dashboard for API status
- Ensure RLS policies are correctly set or temporarily disabled for testing

### Issue: "No tasks showing up"

**Solutions:**
- Make sure you've created a board with ID 'default-board'
- Check the tasks table in Supabase Table Editor
- Look at the Flutter console for error messages
- Verify the board_id in tasks matches your board

### Issue: "Permission denied" errors

**Solutions:**
- Disable RLS for testing: `ALTER TABLE tasks DISABLE ROW LEVEL SECURITY;`
- Or set up authentication properly
- Check board_members table has correct entries

### Issue: Real-time updates not working

**Solutions:**
- Real-time is enabled by default in Supabase
- Check **Database** > **Replication** in Supabase dashboard
- Ensure `watchTasks` is being called in your code
- Look for WebSocket connection errors in console

## Security Best Practices

1. **Always use environment variables** for credentials
2. **Never commit** `.env` files or hardcode credentials
3. **Enable RLS** in production
4. **Use authentication** for production apps
5. **Limit API key permissions** in Supabase settings
6. **Use service role key** only on backend/server, never in client apps

## Next Steps

Once real-time sync is working:
- Implement offline support (Step 4)
- Add comprehensive testing (Step 5)
- Set up proper authentication
- Deploy to production

## Additional Resources

- [Supabase Documentation](https://supabase.com/docs)
- [Supabase Flutter SDK](https://supabase.com/docs/reference/dart/introduction)
- [Row Level Security Guide](https://supabase.com/docs/guides/auth/row-level-security)
- [Real-time Subscriptions](https://supabase.com/docs/guides/realtime)
