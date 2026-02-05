import 'package:taskflow/features/tasks/data/models/task_model.dart';

/// Local data source interface for tasks
/// Handles local storage with SQLite
abstract class TaskLocalDataSource {
  /// Get all tasks for a board from local storage
  Future<List<TaskModel>> getTasks(String boardId);

  /// Watch tasks from local storage (stream)
  Stream<List<TaskModel>> watchTasks(String boardId);

  /// Get a single task by ID from local storage
  Future<TaskModel?> getTaskById(String taskId);

  /// Save a single task to local storage
  Future<void> saveTask(TaskModel task);

  /// Save multiple tasks to local storage
  Future<void> saveTasks(List<TaskModel> tasks);

  /// Delete a task from local storage
  Future<void> deleteTask(String taskId);

  /// Mark a task as synced
  Future<void> markAsSynced(String taskId);

  /// Get all unsynced tasks
  Future<List<TaskModel>> getUnsyncedTasks();

  /// Clear all tasks (for logout/reset)
  Future<void> clearAll();

  /// Add operation to sync queue
  Future<void> addToSyncQueue({
    required String entityType,
    required String entityId,
    required String operation,
    required Map<String, dynamic> data,
  });

  /// Remove operation from sync queue
  Future<void> removeFromSyncQueue(int queueId);

  /// Get pending sync operations
  Future<List<Map<String, dynamic>>> getPendingSyncOperations();
}
