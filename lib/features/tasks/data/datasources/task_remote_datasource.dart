import 'package:taskflow/features/tasks/data/models/task_model.dart';

/// Remote data source interface for tasks
/// Handles communication with Supabase backend
abstract class TaskRemoteDataSource {
  /// Fetch all tasks for a board
  Future<List<TaskModel>> getTasks(String boardId);

  /// Watch tasks in real-time (stream)
  Stream<List<TaskModel>> watchTasks(String boardId);

  /// Get a single task by ID
  Future<TaskModel> getTaskById(String taskId);

  /// Create a new task
  Future<TaskModel> createTask(TaskModel task);

  /// Update an existing task
  Future<TaskModel> updateTask(TaskModel task);

  /// Delete a task
  Future<void> deleteTask(String taskId);

  /// Move a task to a new status and order
  Future<TaskModel> moveTask({
    required String taskId,
    required String newStatus,
    required int newOrder,
  });
}
