import 'package:taskflow/core/types/result.dart';
import 'package:taskflow/features/tasks/domain/entities/task_entity.dart';
import 'package:taskflow/features/tasks/domain/repositories/task_repository.dart';

/// Use case for creating a new task
class CreateTask {
  final TaskRepository repository;

  const CreateTask(this.repository);

  /// Execute the use case
  AsyncResult<Task> call(Task task) {
    return repository.createTask(task);
  }
}
