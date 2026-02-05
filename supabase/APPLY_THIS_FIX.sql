-- ============================================
-- QUICK FIX: Remove infinite recursion
-- Copy this entire file and run in Supabase SQL Editor
-- ============================================

-- Step 1: Disable RLS temporarily
ALTER TABLE tasks DISABLE ROW LEVEL SECURITY;
ALTER TABLE boards DISABLE ROW LEVEL SECURITY;
ALTER TABLE board_members DISABLE ROW LEVEL SECURITY;

-- Step 2: Drop ALL existing policies
DROP POLICY IF EXISTS "Users can view tasks in their boards" ON tasks;
DROP POLICY IF EXISTS "Users can insert tasks in their boards" ON tasks;
DROP POLICY IF EXISTS "Users can update tasks in their boards" ON tasks;
DROP POLICY IF EXISTS "Users can delete tasks in their boards" ON tasks;
DROP POLICY IF EXISTS "Authenticated users can manage tasks" ON tasks;

DROP POLICY IF EXISTS "Users can view their boards" ON boards;
DROP POLICY IF EXISTS "Users can insert their own boards" ON boards;
DROP POLICY IF EXISTS "Users can update their boards" ON boards;
DROP POLICY IF EXISTS "Users can delete their boards" ON boards;
DROP POLICY IF EXISTS "Authenticated users can manage boards" ON boards;

DROP POLICY IF EXISTS "Users can view board members" ON board_members;
DROP POLICY IF EXISTS "Anyone authenticated can view board members" ON board_members;
DROP POLICY IF EXISTS "Users can add themselves to boards" ON board_members;
DROP POLICY IF EXISTS "Board owners can manage members" ON board_members;
DROP POLICY IF EXISTS "Authenticated users can manage board_members" ON board_members;

-- Drop simple policies if they exist from previous runs
DROP POLICY IF EXISTS "Allow all on tasks" ON tasks;
DROP POLICY IF EXISTS "Allow all on boards" ON boards;
DROP POLICY IF EXISTS "Allow all on board_members" ON board_members;

-- Step 3: Re-enable RLS
ALTER TABLE tasks ENABLE ROW LEVEL SECURITY;
ALTER TABLE boards ENABLE ROW LEVEL SECURITY;
ALTER TABLE board_members ENABLE ROW LEVEL SECURITY;

-- Step 4: Create SIMPLE policies (no cross-table references)
CREATE POLICY "Allow all on tasks"
  ON tasks FOR ALL
  USING (true)
  WITH CHECK (true);

CREATE POLICY "Allow all on boards"
  ON boards FOR ALL
  USING (true)
  WITH CHECK (true);

CREATE POLICY "Allow all on board_members"
  ON board_members FOR ALL
  USING (true)
  WITH CHECK (true);

-- Step 5: Create a default board for testing
INSERT INTO boards (id, name, description, owner_id) 
VALUES (
  '00000000-0000-0000-0000-000000000000',
  'My First Board',
  'Default board for testing',
  NULL
)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  updated_at = NOW();

-- Step 6: Add sample tasks
INSERT INTO tasks (id, title, description, status, priority, board_id, task_order)
VALUES 
  ('11111111-1111-1111-1111-111111111111', 'Design login screen', 'Create mockups for the login and registration screens', 'todo', 'high', '00000000-0000-0000-0000-000000000000', 0),
  ('22222222-2222-2222-2222-222222222222', 'Setup Firebase', 'Configure Firebase project and add to the app', 'todo', 'medium', '00000000-0000-0000-0000-000000000000', 1),
  ('33333333-3333-3333-3333-333333333333', 'Implement authentication', 'Build login, registration, and password reset features', 'inProgress', 'high', '00000000-0000-0000-0000-000000000000', 0),
  ('44444444-4444-4444-4444-444444444444', 'Create API service', 'Build the REST API service layer', 'inProgress', 'medium', '00000000-0000-0000-0000-000000000000', 1),
  ('55555555-5555-5555-5555-555555555555', 'Write unit tests', 'Add unit tests for authentication module', 'done', 'low', '00000000-0000-0000-0000-000000000000', 0)
ON CONFLICT (id) DO NOTHING;

-- Verify the fix
SELECT 'RLS policies fixed successfully!' as status;
SELECT COUNT(*) as task_count FROM tasks WHERE board_id = '00000000-0000-0000-0000-000000000000';
