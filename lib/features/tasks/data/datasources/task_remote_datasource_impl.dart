import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:taskflow/core/errors/exceptions.dart';
import 'package:taskflow/core/utils/logger.dart';
import 'package:taskflow/features/tasks/data/datasources/task_remote_datasource.dart';
import 'package:taskflow/features/tasks/data/models/task_model.dart';

/// Supabase implementation of TaskRemoteDataSource
class TaskRemoteDataSourceImpl implements TaskRemoteDataSource {
  final SupabaseClient supabaseClient;

  const TaskRemoteDataSourceImpl({required this.supabaseClient});

  @override
  Future<List<TaskModel>> getTasks(String boardId) async {
    try {
      Logger.data('Fetching tasks for board: $boardId from Supabase');

      final response = await supabaseClient
          .from('tasks')
          .select()
          .eq('board_id', boardId)
          .order('task_order', ascending: true);

      Logger.data('Received ${response.length} tasks from Supabase');

      return (response as List)
          .map((json) => TaskModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } on PostgrestException catch (e) {
      Logger.error('Supabase error while fetching tasks', e);
      throw ServerException(
        e.message,
        code: e.code,
        originalException: e,
      );
    } catch (e, stackTrace) {
      Logger.error('Unexpected error while fetching tasks', e, stackTrace);
      throw ServerException(
        'Failed to fetch tasks: ${e.toString()}',
        originalException: e,
      );
    }
  }

  @override
  Stream<List<TaskModel>> watchTasks(String boardId) {
    try {
      Logger.data('Setting up real-time stream for board: $boardId');

      return supabaseClient
          .from('tasks')
          .stream(primaryKey: ['id'])
          .eq('board_id', boardId)
          .order('task_order', ascending: true)
          .map((data) {
            Logger.data('Real-time update: ${data.length} tasks');
            return data
                .map((json) => TaskModel.fromJson(json as Map<String, dynamic>))
                .toList();
          })
          .handleError((error) {
            Logger.error('Stream error in watchTasks', error);
            throw ServerException(
              'Stream error: ${error.toString()}',
              originalException: error,
            );
          });
    } catch (e, stackTrace) {
      Logger.error('Error setting up task stream', e, stackTrace);
      throw ServerException(
        'Failed to setup stream: ${e.toString()}',
        originalException: e,
      );
    }
  }

  @override
  Future<TaskModel> getTaskById(String taskId) async {
    try {
      Logger.data('Fetching task by ID: $taskId');

      final response = await supabaseClient
          .from('tasks')
          .select()
          .eq('id', taskId)
          .single();

      Logger.data('Task found: $taskId');

      return TaskModel.fromJson(response as Map<String, dynamic>);
    } on PostgrestException catch (e) {
      if (e.code == 'PGRST116') {
        // No rows returned
        Logger.error('Task not found: $taskId', e);
        throw NotFoundException(
          'Task not found with ID: $taskId',
          code: e.code,
          originalException: e,
        );
      }

      Logger.error('Supabase error while fetching task', e);
      throw ServerException(
        e.message,
        code: e.code,
        originalException: e,
      );
    } catch (e, stackTrace) {
      Logger.error('Unexpected error while fetching task', e, stackTrace);
      throw ServerException(
        'Failed to fetch task: ${e.toString()}',
        originalException: e,
      );
    }
  }

  @override
  Future<TaskModel> createTask(TaskModel task) async {
    try {
      Logger.data('Creating task: ${task.title}');

      final response = await supabaseClient
          .from('tasks')
          .insert(task.toJson())
          .select()
          .single();

      Logger.data('Task created successfully: ${task.id}');

      return TaskModel.fromJson(response as Map<String, dynamic>);
    } on PostgrestException catch (e) {
      Logger.error('Supabase error while creating task', e);
      throw ServerException(
        e.message,
        code: e.code,
        originalException: e,
      );
    } catch (e, stackTrace) {
      Logger.error('Unexpected error while creating task', e, stackTrace);
      throw ServerException(
        'Failed to create task: ${e.toString()}',
        originalException: e,
      );
    }
  }

  @override
  Future<TaskModel> updateTask(TaskModel task) async {
    try {
      Logger.data('Updating task: ${task.id}');

      final response = await supabaseClient
          .from('tasks')
          .update(task.toJson())
          .eq('id', task.id)
          .select()
          .single();

      Logger.data('Task updated successfully: ${task.id}');

      return TaskModel.fromJson(response as Map<String, dynamic>);
    } on PostgrestException catch (e) {
      Logger.error('Supabase error while updating task', e);
      throw ServerException(
        e.message,
        code: e.code,
        originalException: e,
      );
    } catch (e, stackTrace) {
      Logger.error('Unexpected error while updating task', e, stackTrace);
      throw ServerException(
        'Failed to update task: ${e.toString()}',
        originalException: e,
      );
    }
  }

  @override
  Future<void> deleteTask(String taskId) async {
    try {
      Logger.data('Deleting task: $taskId');

      await supabaseClient.from('tasks').delete().eq('id', taskId);

      Logger.data('Task deleted successfully: $taskId');
    } on PostgrestException catch (e) {
      Logger.error('Supabase error while deleting task', e);
      throw ServerException(
        e.message,
        code: e.code,
        originalException: e,
      );
    } catch (e, stackTrace) {
      Logger.error('Unexpected error while deleting task', e, stackTrace);
      throw ServerException(
        'Failed to delete task: ${e.toString()}',
        originalException: e,
      );
    }
  }

  @override
  Future<TaskModel> moveTask({
    required String taskId,
    required String newStatus,
    required int newOrder,
  }) async {
    try {
      Logger.data('Moving task $taskId to $newStatus at order $newOrder');

      final response = await supabaseClient
          .from('tasks')
          .update({
            'status': newStatus,
            'task_order': newOrder,
          })
          .eq('id', taskId)
          .select()
          .single();

      Logger.data('Task moved successfully: $taskId');

      return TaskModel.fromJson(response as Map<String, dynamic>);
    } on PostgrestException catch (e) {
      Logger.error('Supabase error while moving task', e);
      throw ServerException(
        e.message,
        code: e.code,
        originalException: e,
      );
    } catch (e, stackTrace) {
      Logger.error('Unexpected error while moving task', e, stackTrace);
      throw ServerException(
        'Failed to move task: ${e.toString()}',
        originalException: e,
      );
    }
  }
}
