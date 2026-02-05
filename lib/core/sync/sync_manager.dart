import 'dart:async';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:taskflow/core/network/network_info.dart';
import 'package:taskflow/core/sync/models/sync_operation.dart';
import 'package:taskflow/core/utils/logger.dart';
import 'package:taskflow/features/tasks/data/datasources/task_local_datasource.dart';
import 'package:taskflow/features/tasks/data/datasources/task_remote_datasource.dart';
import 'package:taskflow/features/tasks/data/models/task_model.dart';

/// Sync manager handles synchronization between local and remote data
class SyncManager {
  final TaskLocalDataSource localDataSource;
  final TaskRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  // Stream controller for sync status
  final _syncStatusController = StreamController<SyncStatus>.broadcast();
  Stream<SyncStatus> get syncStatusStream => _syncStatusController.stream;
  
  SyncStatus _currentStatus = SyncStatus.idle;
  SyncStatus get currentStatus => _currentStatus;

  // Sync lock to prevent concurrent syncs
  bool _isSyncing = false;
  
  // Timer for periodic sync
  Timer? _periodicSyncTimer;

  SyncManager({
    required this.localDataSource,
    required this.remoteDataSource,
    required this.networkInfo,
  });

  /// Initialize sync manager and start listening to connectivity changes
  void initialize() {
    Logger.info('Initializing SyncManager');
    
    // Listen to connectivity changes
    networkInfo.onConnectivityChanged.listen((isConnected) {
      if (isConnected) {
        Logger.info('Network connected - triggering sync');
        syncAll();
      } else {
        Logger.info('Network disconnected');
        _updateStatus(SyncStatus.offline);
      }
    });

    // Start periodic sync (every 5 minutes)
    _periodicSyncTimer = Timer.periodic(
      const Duration(minutes: 5),
      (_) => syncAll(),
    );
  }

  /// Sync all pending operations and pull latest data
  Future<SyncResult> syncAll() async {
    if (_isSyncing) {
      Logger.info('Sync already in progress, skipping');
      return SyncResult(status: SyncStatus.syncing);
    }

    // Check if we're online
    if (!await networkInfo.isConnected) {
      Logger.info('Cannot sync - offline');
      _updateStatus(SyncStatus.offline);
      return SyncResult(status: SyncStatus.offline);
    }

    _isSyncing = true;
    _updateStatus(SyncStatus.syncing);
    
    int successCount = 0;
    int failureCount = 0;
    final errors = <String>[];

    try {
      Logger.info('Starting full sync...');

      // 1. Push pending local operations to remote
      final pendingOps = await localDataSource.getPendingSyncOperations();
      Logger.info('Found ${pendingOps.length} pending operations');

      for (final opMap in pendingOps) {
        try {
          final op = SyncOperation.fromMap(opMap);
          await _processOperation(op);
          successCount++;
        } catch (e) {
          failureCount++;
          errors.add(e.toString());
          Logger.error('Failed to process operation', e);
        }
      }

      // 2. Pull latest data from remote
      await _pullFromRemote();

      _updateStatus(SyncStatus.completed);
      Logger.info('Sync completed: $successCount successful, $failureCount failed');
      
      return SyncResult(
        status: SyncStatus.completed,
        successCount: successCount,
        failureCount: failureCount,
        errors: errors,
      );
    } catch (e, stackTrace) {
      Logger.error('Sync failed', e, stackTrace);
      _updateStatus(SyncStatus.failed);
      errors.add(e.toString());
      
      return SyncResult(
        status: SyncStatus.failed,
        successCount: successCount,
        failureCount: failureCount,
        errors: errors,
      );
    } finally {
      _isSyncing = false;
    }
  }

  /// Sync a specific task
  Future<void> syncTask(String taskId) async {
    if (!await networkInfo.isConnected) {
      Logger.info('Cannot sync task - offline');
      return;
    }

    try {
      final task = await localDataSource.getTaskById(taskId);
      if (task == null) {
        Logger.warning('Task not found for sync: $taskId');
        return;
      }

      if (task.isSynced) {
        Logger.info('Task already synced: $taskId');
        return;
      }

      // Determine operation based on task state
      // For simplicity, we'll try to create/update
      try {
        await remoteDataSource.createTask(task);
        Logger.info('Created task on remote: $taskId');
      } on PostgrestException catch (e) {
        if (e.code == '23505') {
          // Unique constraint violation - task exists, update instead
          await remoteDataSource.updateTask(task);
          Logger.info('Updated task on remote: $taskId');
        } else {
          rethrow;
        }
      }

      await localDataSource.markAsSynced(taskId);
    } catch (e, stackTrace) {
      Logger.error('Failed to sync task: $taskId', e, stackTrace);
    }
  }

  /// Process a single sync operation
  Future<void> _processOperation(SyncOperation op) async {
    Logger.info('Processing sync operation: $op');

    try {
      switch (op.operation) {
        case 'create':
          final task = TaskModel.fromJson(op.data!);
          await remoteDataSource.createTask(task);
          await localDataSource.markAsSynced(op.entityId);
          Logger.info('Created task on remote: ${op.entityId}');
          break;

        case 'update':
          final task = TaskModel.fromJson(op.data!);
          await remoteDataSource.updateTask(task);
          await localDataSource.markAsSynced(op.entityId);
          Logger.info('Updated task on remote: ${op.entityId}');
          break;

        case 'delete':
          await remoteDataSource.deleteTask(op.entityId);
          Logger.info('Deleted task on remote: ${op.entityId}');
          break;
      }

      // Remove from queue on success
      if (op.id != null) {
        await localDataSource.removeFromSyncQueue(op.id!);
      }
    } on PostgrestException catch (e) {
      Logger.error('Supabase error processing operation', e);
      
      // Handle specific error cases
      if (e.code == '23505') {
        // Unique constraint violation - item already exists
        Logger.info('Item already exists on remote, marking as synced');
        await localDataSource.markAsSynced(op.entityId);
        if (op.id != null) {
          await localDataSource.removeFromSyncQueue(op.id!);
        }
      } else if (e.code == 'PGRST116') {
        // Not found - item was deleted remotely
        Logger.info('Item not found on remote, removing locally');
        await localDataSource.deleteTask(op.entityId);
        if (op.id != null) {
          await localDataSource.removeFromSyncQueue(op.id!);
        }
      } else {
        // Other errors - will retry later
        rethrow;
      }
    }
  }

  /// Pull latest data from remote
  Future<void> _pullFromRemote() async {
    try {
      Logger.info('Pulling latest tasks from remote...');
      
      // For now, pull tasks for default board
      // In production, you'd iterate through all boards the user has access to
      const defaultBoardId = '00000000-0000-0000-0000-000000000000';
      
      final remoteTasks = await remoteDataSource.getTasks(defaultBoardId);
      Logger.info('Pulled ${remoteTasks.length} tasks from remote');

      // Merge with local data
      for (final remoteTask in remoteTasks) {
        final localTask = await localDataSource.getTaskById(remoteTask.id);
        
        if (localTask == null) {
          // New remote task, save locally
          await localDataSource.saveTask(
            remoteTask.copyWith(isSynced: true),
          );
          Logger.info('Saved new remote task locally: ${remoteTask.id}');
        } else if (!localTask.isSynced) {
          // Local has unsynced changes, resolve conflict
          final resolved = _resolveConflict(localTask, remoteTask);
          await localDataSource.saveTask(resolved);
          Logger.info('Resolved conflict for task: ${remoteTask.id}');
        } else {
          // Update local with remote data
          await localDataSource.saveTask(
            remoteTask.copyWith(isSynced: true),
          );
          Logger.info('Updated local task from remote: ${remoteTask.id}');
        }
      }
    } catch (e, stackTrace) {
      Logger.error('Failed to pull from remote', e, stackTrace);
      rethrow;
    }
  }

  /// Resolve conflict between local and remote task
  /// Strategy: Last write wins (timestamp-based)
  TaskModel _resolveConflict(TaskModel local, TaskModel remote) {
    final localUpdated = DateTime.parse(local.updatedAt);
    final remoteUpdated = DateTime.parse(remote.updatedAt);
    
    if (remoteUpdated.isAfter(localUpdated)) {
      Logger.info('Remote task is newer, using remote version');
      return remote.copyWith(isSynced: true);
    } else {
      Logger.info('Local task is newer, keeping local version for sync');
      return local.copyWith(isSynced: false);
    }
  }

  /// Update sync status and notify listeners
  void _updateStatus(SyncStatus status) {
    _currentStatus = status;
    if (!_syncStatusController.isClosed) {
      _syncStatusController.add(status);
    }
  }

  /// Dispose resources
  void dispose() {
    _periodicSyncTimer?.cancel();
    _syncStatusController.close();
    Logger.info('SyncManager disposed');
  }
}
