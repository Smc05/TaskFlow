import 'package:taskflow/core/errors/exceptions.dart';
import 'package:taskflow/core/errors/failures.dart';
import 'package:taskflow/core/types/result.dart';
import 'package:taskflow/core/utils/logger.dart';
import 'package:taskflow/features/tasks/data/datasources/task_local_datasource.dart';
import 'package:taskflow/features/tasks/data/datasources/task_remote_datasource.dart';
import 'package:taskflow/features/tasks/data/models/task_model.dart';
import 'package:taskflow/features/tasks/domain/entities/task_entity.dart';
import 'package:taskflow/features/tasks/domain/repositories/task_repository.dart';

/// Implementation of TaskRepository
/// Coordinates between local and remote data sources
class TaskRepositoryImpl implements TaskRepository {
  final TaskRemoteDataSource remoteDataSource;
  final TaskLocalDataSource localDataSource;

  const TaskRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  AsyncResult<List<Task>> getTasks(String boardId) async {
    try {
      Logger.data('Getting tasks for board: $boardId');

      // Always return local data first for fast response
      final localTasks = await localDataSource.getTasks(boardId);
      final tasks = localTasks.map((model) => model.toEntity()).toList();

      Logger.data('Retrieved ${tasks.length} tasks from local storage');
      return Results.success(tasks);
    } on CacheException catch (e) {
      Logger.error('Cache error while getting tasks', e);
      return Results.failure(CacheFailure(e.message));
    } catch (e, stackTrace) {
      Logger.error('Unexpected error while getting tasks', e, stackTrace);
      return Results.failure(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Stream<Result<List<Task>>> watchTasks(String boardId) {
    try {
      Logger.data('Watching tasks for board: $boardId');

      return localDataSource
          .watchTasks(boardId)
          .map((models) {
            final tasks = models.map((model) => model.toEntity()).toList();
            return Results.success<List<Task>>(tasks);
          })
          .handleError((error) {
            Logger.error('Stream error while watching tasks', error);
            return Results.failure<List<Task>>(StreamFailure(error.toString()));
          });
    } catch (e, stackTrace) {
      Logger.error('Error setting up task watch stream', e, stackTrace);
      return Stream.value(Results.failure(StreamFailure(e.toString())));
    }
  }

  @override
  AsyncResult<Task> getTaskById(String taskId) async {
    try {
      Logger.data('Getting task by ID: $taskId');

      final taskModel = await localDataSource.getTaskById(taskId);
      if (taskModel == null) {
        return Results.failure(const NotFoundFailure('Task not found'));
      }

      return Results.success(taskModel.toEntity());
    } on CacheException catch (e) {
      Logger.error('Cache error while getting task', e);
      return Results.failure(CacheFailure(e.message));
    } catch (e, stackTrace) {
      Logger.error('Unexpected error while getting task', e, stackTrace);
      return Results.failure(UnexpectedFailure(e.toString()));
    }
  }

  @override
  AsyncResult<Task> createTask(Task task) async {
    try {
      Logger.data('Creating task: ${task.title}');

      final model = TaskModel.fromEntity(task);

      // Save to local storage immediately
      await localDataSource.saveTask(model.copyWith(isSynced: false));

      // Add to sync queue
      await localDataSource.addToSyncQueue(
        entityType: 'task',
        entityId: task.id,
        operation: 'create',
        data: model.toJson(),
      );

      Logger.data('Task created locally: ${task.id}');
      return Results.success(task);
    } on CacheException catch (e) {
      Logger.error('Cache error while creating task', e);
      return Results.failure(CacheFailure(e.message));
    } catch (e, stackTrace) {
      Logger.error('Unexpected error while creating task', e, stackTrace);
      return Results.failure(UnexpectedFailure(e.toString()));
    }
  }

  @override
  AsyncResult<Task> updateTask(Task task) async {
    try {
      Logger.data('Updating task: ${task.id}');

      final model = TaskModel.fromEntity(task);

      // Update in local storage immediately
      await localDataSource.saveTask(model.copyWith(isSynced: false));

      // Add to sync queue
      await localDataSource.addToSyncQueue(
        entityType: 'task',
        entityId: task.id,
        operation: 'update',
        data: model.toJson(),
      );

      Logger.data('Task updated locally: ${task.id}');
      return Results.success(task);
    } on CacheException catch (e) {
      Logger.error('Cache error while updating task', e);
      return Results.failure(CacheFailure(e.message));
    } catch (e, stackTrace) {
      Logger.error('Unexpected error while updating task', e, stackTrace);
      return Results.failure(UnexpectedFailure(e.toString()));
    }
  }

  @override
  AsyncResult<void> deleteTask(String taskId) async {
    try {
      Logger.data('Deleting task: $taskId');

      // Delete from local storage immediately
      await localDataSource.deleteTask(taskId);

      // Add to sync queue
      await localDataSource.addToSyncQueue(
        entityType: 'task',
        entityId: taskId,
        operation: 'delete',
        data: {'id': taskId},
      );

      Logger.data('Task deleted locally: $taskId');
      return Results.success(null);
    } on CacheException catch (e) {
      Logger.error('Cache error while deleting task', e);
      return Results.failure(CacheFailure(e.message));
    } catch (e, stackTrace) {
      Logger.error('Unexpected error while deleting task', e, stackTrace);
      return Results.failure(UnexpectedFailure(e.toString()));
    }
  }

  @override
  AsyncResult<Task> moveTask({
    required String taskId,
    required TaskStatus newStatus,
    required int newOrder,
  }) async {
    try {
      Logger.data(
        'Moving task $taskId to ${newStatus.value} at order $newOrder',
      );

      final taskResult = await getTaskById(taskId);

      if (taskResult.isLeft()) {
        return taskResult;
      }

      final task = taskResult.getOrThrow();
      final updatedTask = task.copyWith(
        status: newStatus,
        order: newOrder,
        updatedAt: DateTime.now(),
      );

      return updateTask(updatedTask);
    } catch (e, stackTrace) {
      Logger.error('Error while moving task', e, stackTrace);
      return Results.failure(UnexpectedFailure(e.toString()));
    }
  }

  @override
  AsyncResult<Task> reorderTask({
    required String taskId,
    required int newOrder,
  }) async {
    try {
      Logger.data('Reordering task $taskId to order $newOrder');

      final taskResult = await getTaskById(taskId);

      if (taskResult.isLeft()) {
        return taskResult;
      }

      final task = taskResult.getOrThrow();
      final updatedTask = task.copyWith(
        order: newOrder,
        updatedAt: DateTime.now(),
      );

      return updateTask(updatedTask);
    } catch (e, stackTrace) {
      Logger.error('Error while reordering task', e, stackTrace);
      return Results.failure(UnexpectedFailure(e.toString()));
    }
  }

  @override
  AsyncResult<List<Task>> getTasksByStatus(
    String boardId,
    TaskStatus status,
  ) async {
    try {
      Logger.data(
        'Getting tasks for board $boardId with status ${status.value}',
      );

      final tasksResult = await getTasks(boardId);
      return tasksResult.map((tasks) {
        return tasks.where((task) => task.status == status).toList();
      });
    } catch (e, stackTrace) {
      Logger.error('Error while getting tasks by status', e, stackTrace);
      return Results.failure(UnexpectedFailure(e.toString()));
    }
  }
}
