import 'package:taskflow/core/types/result.dart';
import 'package:taskflow/features/tasks/domain/entities/task_entity.dart';

/// Repository interface for task operations
/// This defines the contract that data layer implementations must follow
abstract class TaskRepository {
  /// Get all tasks for a specific board
  AsyncResult<List<Task>> getTasks(String boardId);

  /// Watch tasks for a specific board (real-time stream)
  Stream<Result<List<Task>>> watchTasks(String boardId);

  /// Get a single task by ID
  AsyncResult<Task> getTaskById(String taskId);

  /// Create a new task
  AsyncResult<Task> createTask(Task task);

  /// Update an existing task
  AsyncResult<Task> updateTask(Task task);

  /// Delete a task by ID
  AsyncResult<void> deleteTask(String taskId);

  /// Move a task to a new status and order
  AsyncResult<Task> moveTask({
    required String taskId,
    required TaskStatus newStatus,
    required int newOrder,
  });

  /// Reorder a task within the same status
  AsyncResult<Task> reorderTask({
    required String taskId,
    required int newOrder,
  });

  /// Get tasks by status
  AsyncResult<List<Task>> getTasksByStatus(String boardId, TaskStatus status);
}
