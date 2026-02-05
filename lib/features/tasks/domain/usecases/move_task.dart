import 'package:taskflow/core/types/result.dart';
import 'package:taskflow/features/tasks/domain/entities/task_entity.dart';
import 'package:taskflow/features/tasks/domain/repositories/task_repository.dart';

/// Use case for moving a task to a different status/column
class MoveTask {
  final TaskRepository repository;

  const MoveTask(this.repository);

  /// Execute the use case - move task to new status and order
  AsyncResult<Task> call({
    required String taskId,
    required TaskStatus newStatus,
    required int newOrder,
  }) {
    return repository.moveTask(
      taskId: taskId,
      newStatus: newStatus,
      newOrder: newOrder,
    );
  }

  /// Reorder task within the same status
  AsyncResult<Task> reorder({required String taskId, required int newOrder}) {
    return repository.reorderTask(taskId: taskId, newOrder: newOrder);
  }
}
