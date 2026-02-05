// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_repository_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$taskRemoteDataSourceHash() =>
    r'55c7918f76f418572fd69c9aeaa4bbac4f20c77d';

/// Provider for remote data source (Supabase)
///
/// Copied from [taskRemoteDataSource].
@ProviderFor(taskRemoteDataSource)
final taskRemoteDataSourceProvider =
    AutoDisposeProvider<TaskRemoteDataSource>.internal(
      taskRemoteDataSource,
      name: r'taskRemoteDataSourceProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$taskRemoteDataSourceHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef TaskRemoteDataSourceRef = AutoDisposeProviderRef<TaskRemoteDataSource>;
String _$taskLocalDataSourceHash() =>
    r'f450ab623c9575f9d5f8d6cf9e5cdf533d6fbcda';

/// Provider for local data source (SQLite)
/// TODO: Implement proper SQLite datasource in Step 4
///
/// Copied from [taskLocalDataSource].
@ProviderFor(taskLocalDataSource)
final taskLocalDataSourceProvider =
    AutoDisposeProvider<TaskLocalDataSource>.internal(
      taskLocalDataSource,
      name: r'taskLocalDataSourceProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$taskLocalDataSourceHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef TaskLocalDataSourceRef = AutoDisposeProviderRef<TaskLocalDataSource>;
String _$taskRepositoryHash() => r'f04c56a6c5546e6a7b86fdb8cbd20871a67bfbe0';

/// Provider for task repository
///
/// Copied from [taskRepository].
@ProviderFor(taskRepository)
final taskRepositoryProvider = AutoDisposeProvider<TaskRepository>.internal(
  taskRepository,
  name: r'taskRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$taskRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef TaskRepositoryRef = AutoDisposeProviderRef<TaskRepository>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
