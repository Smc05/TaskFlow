-- TaskFlow Database Schema for Supabase
-- Execute this in your Supabase SQL Editor

-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- ============================================
-- TABLES
-- ============================================

-- Boards Table
CREATE TABLE IF NOT EXISTS boards (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  name TEXT NOT NULL,
  description TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  owner_id UUID REFERENCES auth.users(id) ON DELETE CASCADE
);

-- Tasks Table
CREATE TABLE IF NOT EXISTS tasks (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  title TEXT NOT NULL,
  description TEXT,
  status TEXT NOT NULL CHECK (status IN ('todo', 'inProgress', 'done')),
  priority TEXT NOT NULL CHECK (priority IN ('low', 'medium', 'high')),
  board_id UUID REFERENCES boards(id) ON DELETE CASCADE,
  task_order INTEGER NOT NULL DEFAULT 0,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  user_id UUID REFERENCES auth.users(id) ON DELETE SET NULL
);

-- Board Members Table (for collaboration)
CREATE TABLE IF NOT EXISTS board_members (
  board_id UUID REFERENCES boards(id) ON DELETE CASCADE,
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
  role TEXT NOT NULL CHECK (role IN ('owner', 'editor', 'viewer')),
  added_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  PRIMARY KEY (board_id, user_id)
);

-- ============================================
-- INDEXES FOR PERFORMANCE
-- ============================================

CREATE INDEX IF NOT EXISTS idx_tasks_board_status ON tasks(board_id, status);
CREATE INDEX IF NOT EXISTS idx_tasks_order ON tasks(task_order);
CREATE INDEX IF NOT EXISTS idx_tasks_board_id ON tasks(board_id);
CREATE INDEX IF NOT EXISTS idx_boards_owner_id ON boards(owner_id);
CREATE INDEX IF NOT EXISTS idx_board_members_user_id ON board_members(user_id);

-- ============================================
-- FUNCTIONS
-- ============================================

-- Function to automatically update updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- ============================================
-- TRIGGERS
-- ============================================

-- Trigger for tasks table
DROP TRIGGER IF EXISTS update_tasks_updated_at ON tasks;
CREATE TRIGGER update_tasks_updated_at
  BEFORE UPDATE ON tasks
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

-- Trigger for boards table
DROP TRIGGER IF EXISTS update_boards_updated_at ON boards;
CREATE TRIGGER update_boards_updated_at
  BEFORE UPDATE ON boards
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

-- ============================================
-- ROW LEVEL SECURITY (RLS)
-- ============================================

-- Enable RLS on all tables
ALTER TABLE tasks ENABLE ROW LEVEL SECURITY;
ALTER TABLE boards ENABLE ROW LEVEL SECURITY;
ALTER TABLE board_members ENABLE ROW LEVEL SECURITY;

-- Drop existing policies if they exist
DROP POLICY IF EXISTS "Users can view tasks in their boards" ON tasks;
DROP POLICY IF EXISTS "Users can insert tasks in their boards" ON tasks;
DROP POLICY IF EXISTS "Users can update tasks in their boards" ON tasks;
DROP POLICY IF EXISTS "Users can delete tasks in their boards" ON tasks;

DROP POLICY IF EXISTS "Users can view their boards" ON boards;
DROP POLICY IF EXISTS "Users can insert their own boards" ON boards;
DROP POLICY IF EXISTS "Users can update their boards" ON boards;
DROP POLICY IF EXISTS "Users can delete their boards" ON boards;

DROP POLICY IF EXISTS "Users can view board members" ON board_members;
DROP POLICY IF EXISTS "Anyone authenticated can view board members" ON board_members;
DROP POLICY IF EXISTS "Users can add themselves to boards" ON board_members;
DROP POLICY IF EXISTS "Board owners can manage members" ON board_members;

-- ============================================
-- TASKS POLICIES
-- ============================================

-- Allow users to view tasks in boards they are members of
CREATE POLICY "Users can view tasks in their boards"
  ON tasks FOR SELECT
  USING (
    board_id IN (
      SELECT board_id FROM board_members WHERE user_id = auth.uid()
    )
  );

-- Allow users to insert tasks in boards where they are owner or editor
CREATE POLICY "Users can insert tasks in their boards"
  ON tasks FOR INSERT
  WITH CHECK (
    board_id IN (
      SELECT board_id FROM board_members 
      WHERE user_id = auth.uid() AND role IN ('owner', 'editor')
    )
  );

-- Allow users to update tasks in boards where they are owner or editor
CREATE POLICY "Users can update tasks in their boards"
  ON tasks FOR UPDATE
  USING (
    board_id IN (
      SELECT board_id FROM board_members 
      WHERE user_id = auth.uid() AND role IN ('owner', 'editor')
    )
  );

-- Allow users to delete tasks in boards where they are owner or editor
CREATE POLICY "Users can delete tasks in their boards"
  ON tasks FOR DELETE
  USING (
    board_id IN (
      SELECT board_id FROM board_members 
      WHERE user_id = auth.uid() AND role IN ('owner', 'editor')
    )
  );

-- ============================================
-- BOARDS POLICIES
-- ============================================

-- Allow users to view boards they are members of
CREATE POLICY "Users can view their boards"
  ON boards FOR SELECT
  USING (
    id IN (
      SELECT board_id FROM board_members WHERE user_id = auth.uid()
    )
  );

-- Allow users to create new boards (they become owner)
CREATE POLICY "Users can insert their own boards"
  ON boards FOR INSERT
  WITH CHECK (auth.uid() = owner_id);

-- Allow board owners to update their boards
CREATE POLICY "Users can update their boards"
  ON boards FOR UPDATE
  USING (
    id IN (
      SELECT board_id FROM board_members 
      WHERE user_id = auth.uid() AND role = 'owner'
    )
  );

-- Allow board owners to delete their boards
CREATE POLICY "Users can delete their boards"
  ON boards FOR DELETE
  USING (
    id IN (
      SELECT board_id FROM board_members 
      WHERE user_id = auth.uid() AND role = 'owner'
    )
  );

-- ============================================
-- BOARD MEMBERS POLICIES
-- ============================================

-- Allow users to view all board members (no recursion)
-- Users need to see board members to check permissions
CREATE POLICY "Anyone authenticated can view board members"
  ON board_members FOR SELECT
  USING (auth.uid() IS NOT NULL);

-- Allow users to insert themselves as members
CREATE POLICY "Users can add themselves to boards"
  ON board_members FOR INSERT
  WITH CHECK (user_id = auth.uid());

-- Allow board owners to manage all members
-- Use board's owner_id directly to avoid recursion
CREATE POLICY "Board owners can manage members"
  ON board_members FOR ALL
  USING (
    board_id IN (
      SELECT id FROM boards WHERE owner_id = auth.uid()
    )
  );

-- ============================================
-- SEED DATA (Optional - for testing)
-- ============================================

-- Create a default board for testing (requires authentication to be set up)
-- Uncomment and modify the user_id after creating a user in Supabase Auth

-- INSERT INTO boards (id, name, description, owner_id) 
-- VALUES (
--   'default-board'::uuid,
--   'My First Board',
--   'Default board for testing',
--   'YOUR_USER_ID_HERE'::uuid
-- );

-- INSERT INTO board_members (board_id, user_id, role)
-- VALUES (
--   'default-board'::uuid,
--   'YOUR_USER_ID_HERE'::uuid,
--   'owner'
-- );

-- Sample tasks for testing
-- INSERT INTO tasks (title, description, status, priority, board_id, task_order)
-- VALUES 
--   ('Design login screen', 'Create mockups for the login and registration screens', 'todo', 'high', 'default-board'::uuid, 0),
--   ('Setup Firebase', 'Configure Firebase project and add to the app', 'todo', 'medium', 'default-board'::uuid, 1),
--   ('Implement authentication', 'Build login, registration, and password reset features', 'inProgress', 'high', 'default-board'::uuid, 0),
--   ('Create API service', 'Build the REST API service layer', 'inProgress', 'medium', 'default-board'::uuid, 1),
--   ('Write unit tests', 'Add unit tests for authentication module', 'done', 'low', 'default-board'::uuid, 0);
