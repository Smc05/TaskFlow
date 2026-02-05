// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tasks_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$tasksHash() => r'53fc9253dc77d05adb4f0f928077b21afa0cf90d';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// Provider for tasks list by board ID
/// This will be implemented with actual repository in later steps
///
/// Copied from [tasks].
@ProviderFor(tasks)
const tasksProvider = TasksFamily();

/// Provider for tasks list by board ID
/// This will be implemented with actual repository in later steps
///
/// Copied from [tasks].
class TasksFamily extends Family<AsyncValue<List<Task>>> {
  /// Provider for tasks list by board ID
  /// This will be implemented with actual repository in later steps
  ///
  /// Copied from [tasks].
  const TasksFamily();

  /// Provider for tasks list by board ID
  /// This will be implemented with actual repository in later steps
  ///
  /// Copied from [tasks].
  TasksProvider call(String boardId) {
    return TasksProvider(boardId);
  }

  @override
  TasksProvider getProviderOverride(covariant TasksProvider provider) {
    return call(provider.boardId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'tasksProvider';
}

/// Provider for tasks list by board ID
/// This will be implemented with actual repository in later steps
///
/// Copied from [tasks].
class TasksProvider extends AutoDisposeFutureProvider<List<Task>> {
  /// Provider for tasks list by board ID
  /// This will be implemented with actual repository in later steps
  ///
  /// Copied from [tasks].
  TasksProvider(String boardId)
    : this._internal(
        (ref) => tasks(ref as TasksRef, boardId),
        from: tasksProvider,
        name: r'tasksProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$tasksHash,
        dependencies: TasksFamily._dependencies,
        allTransitiveDependencies: TasksFamily._allTransitiveDependencies,
        boardId: boardId,
      );

  TasksProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.boardId,
  }) : super.internal();

  final String boardId;

  @override
  Override overrideWith(
    FutureOr<List<Task>> Function(TasksRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: TasksProvider._internal(
        (ref) => create(ref as TasksRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        boardId: boardId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<Task>> createElement() {
    return _TasksProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is TasksProvider && other.boardId == boardId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, boardId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin TasksRef on AutoDisposeFutureProviderRef<List<Task>> {
  /// The parameter `boardId` of this provider.
  String get boardId;
}

class _TasksProviderElement extends AutoDisposeFutureProviderElement<List<Task>>
    with TasksRef {
  _TasksProviderElement(super.provider);

  @override
  String get boardId => (origin as TasksProvider).boardId;
}

String _$tasksStreamHash() => r'd8d9fbeffd8257d2b13f010b216e0f7fd2e6f07e';

/// Provider for tasks stream by board ID
/// Real-time updates will be implemented in later steps
///
/// Copied from [tasksStream].
@ProviderFor(tasksStream)
const tasksStreamProvider = TasksStreamFamily();

/// Provider for tasks stream by board ID
/// Real-time updates will be implemented in later steps
///
/// Copied from [tasksStream].
class TasksStreamFamily extends Family<AsyncValue<List<Task>>> {
  /// Provider for tasks stream by board ID
  /// Real-time updates will be implemented in later steps
  ///
  /// Copied from [tasksStream].
  const TasksStreamFamily();

  /// Provider for tasks stream by board ID
  /// Real-time updates will be implemented in later steps
  ///
  /// Copied from [tasksStream].
  TasksStreamProvider call(String boardId) {
    return TasksStreamProvider(boardId);
  }

  @override
  TasksStreamProvider getProviderOverride(
    covariant TasksStreamProvider provider,
  ) {
    return call(provider.boardId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'tasksStreamProvider';
}

/// Provider for tasks stream by board ID
/// Real-time updates will be implemented in later steps
///
/// Copied from [tasksStream].
class TasksStreamProvider extends AutoDisposeStreamProvider<List<Task>> {
  /// Provider for tasks stream by board ID
  /// Real-time updates will be implemented in later steps
  ///
  /// Copied from [tasksStream].
  TasksStreamProvider(String boardId)
    : this._internal(
        (ref) => tasksStream(ref as TasksStreamRef, boardId),
        from: tasksStreamProvider,
        name: r'tasksStreamProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$tasksStreamHash,
        dependencies: TasksStreamFamily._dependencies,
        allTransitiveDependencies: TasksStreamFamily._allTransitiveDependencies,
        boardId: boardId,
      );

  TasksStreamProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.boardId,
  }) : super.internal();

  final String boardId;

  @override
  Override overrideWith(
    Stream<List<Task>> Function(TasksStreamRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: TasksStreamProvider._internal(
        (ref) => create(ref as TasksStreamRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        boardId: boardId,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<List<Task>> createElement() {
    return _TasksStreamProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is TasksStreamProvider && other.boardId == boardId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, boardId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin TasksStreamRef on AutoDisposeStreamProviderRef<List<Task>> {
  /// The parameter `boardId` of this provider.
  String get boardId;
}

class _TasksStreamProviderElement
    extends AutoDisposeStreamProviderElement<List<Task>>
    with TasksStreamRef {
  _TasksStreamProviderElement(super.provider);

  @override
  String get boardId => (origin as TasksStreamProvider).boardId;
}

String _$tasksByStatusHash() => r'6f0ebb4aae25a5a2bd6f01e9adaad19b242270f6';

/// Provider for tasks grouped by status
///
/// Copied from [tasksByStatus].
@ProviderFor(tasksByStatus)
const tasksByStatusProvider = TasksByStatusFamily();

/// Provider for tasks grouped by status
///
/// Copied from [tasksByStatus].
class TasksByStatusFamily
    extends Family<AsyncValue<Map<TaskStatus, List<Task>>>> {
  /// Provider for tasks grouped by status
  ///
  /// Copied from [tasksByStatus].
  const TasksByStatusFamily();

  /// Provider for tasks grouped by status
  ///
  /// Copied from [tasksByStatus].
  TasksByStatusProvider call(String boardId) {
    return TasksByStatusProvider(boardId);
  }

  @override
  TasksByStatusProvider getProviderOverride(
    covariant TasksByStatusProvider provider,
  ) {
    return call(provider.boardId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'tasksByStatusProvider';
}

/// Provider for tasks grouped by status
///
/// Copied from [tasksByStatus].
class TasksByStatusProvider
    extends AutoDisposeFutureProvider<Map<TaskStatus, List<Task>>> {
  /// Provider for tasks grouped by status
  ///
  /// Copied from [tasksByStatus].
  TasksByStatusProvider(String boardId)
    : this._internal(
        (ref) => tasksByStatus(ref as TasksByStatusRef, boardId),
        from: tasksByStatusProvider,
        name: r'tasksByStatusProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$tasksByStatusHash,
        dependencies: TasksByStatusFamily._dependencies,
        allTransitiveDependencies:
            TasksByStatusFamily._allTransitiveDependencies,
        boardId: boardId,
      );

  TasksByStatusProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.boardId,
  }) : super.internal();

  final String boardId;

  @override
  Override overrideWith(
    FutureOr<Map<TaskStatus, List<Task>>> Function(TasksByStatusRef provider)
    create,
  ) {
    return ProviderOverride(
      origin: this,
      override: TasksByStatusProvider._internal(
        (ref) => create(ref as TasksByStatusRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        boardId: boardId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<Map<TaskStatus, List<Task>>>
  createElement() {
    return _TasksByStatusProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is TasksByStatusProvider && other.boardId == boardId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, boardId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin TasksByStatusRef
    on AutoDisposeFutureProviderRef<Map<TaskStatus, List<Task>>> {
  /// The parameter `boardId` of this provider.
  String get boardId;
}

class _TasksByStatusProviderElement
    extends AutoDisposeFutureProviderElement<Map<TaskStatus, List<Task>>>
    with TasksByStatusRef {
  _TasksByStatusProviderElement(super.provider);

  @override
  String get boardId => (origin as TasksByStatusProvider).boardId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
