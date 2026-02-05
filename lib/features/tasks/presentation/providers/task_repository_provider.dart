import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:taskflow/core/database/database_helper.dart';
import 'package:taskflow/core/network/network_info.dart';
import 'package:taskflow/core/sync/sync_manager.dart';
import 'package:taskflow/core/sync/sync_status.dart';
import 'package:taskflow/features/tasks/data/datasources/task_local_datasource.dart';
import 'package:taskflow/features/tasks/data/datasources/task_local_datasource_impl.dart';
import 'package:taskflow/features/tasks/data/datasources/task_remote_datasource.dart';
import 'package:taskflow/features/tasks/data/datasources/task_remote_datasource_impl.dart';
import 'package:taskflow/features/tasks/data/repositories/task_repository_impl.dart';
import 'package:taskflow/features/tasks/domain/repositories/task_repository.dart';
import 'package:taskflow/shared/providers/supabase_provider.dart';

part 'task_repository_provider.g.dart';

/// Provider for database helper (SQLite)
@riverpod
DatabaseHelper databaseHelper(DatabaseHelperRef ref) {
  return DatabaseHelper.instance;
}

/// Provider for network information
@riverpod
NetworkInfo networkInfo(NetworkInfoRef ref) {
  return NetworkInfoImpl(Connectivity());
}

/// Provider for connectivity stream
@riverpod
Stream<bool> connectivityStream(ConnectivityStreamRef ref) {
  final networkInfo = ref.watch(networkInfoProvider);
  return networkInfo.onConnectivityChanged;
}

/// Provider for remote data source (Supabase)
@riverpod
TaskRemoteDataSource taskRemoteDataSource(TaskRemoteDataSourceRef ref) {
  final supabaseClient = ref.watch(supabaseClientProvider);
  return TaskRemoteDataSourceImpl(supabaseClient: supabaseClient);
}

/// Provider for local data source (SQLite)
@riverpod
TaskLocalDataSource taskLocalDataSource(TaskLocalDataSourceRef ref) {
  final dbHelper = ref.watch(databaseHelperProvider);
  return TaskLocalDataSourceImpl(dbHelper);
}

/// Provider for sync manager
@riverpod
SyncManager syncManager(SyncManagerRef ref) {
  final localDataSource = ref.watch(taskLocalDataSourceProvider);
  final remoteDataSource = ref.watch(taskRemoteDataSourceProvider);
  final networkInfo = ref.watch(networkInfoProvider);

  final manager = SyncManager(
    localDataSource: localDataSource,
    remoteDataSource: remoteDataSource,
    networkInfo: networkInfo,
  );

  // Initialize sync manager
  manager.initialize();

  return manager;
}

/// Provider for sync status stream
@riverpod
Stream<SyncStatus> syncStatusStream(SyncStatusStreamRef ref) {
  final syncManager = ref.watch(syncManagerProvider);
  return syncManager.syncStatusStream;
}

/// Provider for task repository
@riverpod
TaskRepository taskRepository(TaskRepositoryRef ref) {
  final remoteDataSource = ref.watch(taskRemoteDataSourceProvider);
  final localDataSource = ref.watch(taskLocalDataSourceProvider);

  return TaskRepositoryImpl(
    remoteDataSource: remoteDataSource,
    localDataSource: localDataSource,
  );
}
