import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:taskflow/features/tasks/data/datasources/task_local_datasource.dart';
import 'package:taskflow/features/tasks/data/datasources/task_local_datasource_stub.dart';
import 'package:taskflow/features/tasks/data/datasources/task_remote_datasource.dart';
import 'package:taskflow/features/tasks/data/datasources/task_remote_datasource_impl.dart';
import 'package:taskflow/features/tasks/data/repositories/task_repository_impl.dart';
import 'package:taskflow/features/tasks/domain/repositories/task_repository.dart';
import 'package:taskflow/shared/providers/supabase_provider.dart';

part 'task_repository_provider.g.dart';

/// Provider for remote data source (Supabase)
@riverpod
TaskRemoteDataSource taskRemoteDataSource(TaskRemoteDataSourceRef ref) {
  final supabaseClient = ref.watch(supabaseClientProvider);
  return TaskRemoteDataSourceImpl(supabaseClient: supabaseClient);
}

/// Provider for local data source (SQLite)
/// TODO: Implement proper SQLite datasource in Step 4
@riverpod
TaskLocalDataSource taskLocalDataSource(TaskLocalDataSourceRef ref) {
  // Return stub implementation for now
  return TaskLocalDataSourceStub();
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
