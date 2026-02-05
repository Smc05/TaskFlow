// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tasks_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$tasksStreamHash() => r'7b6eef59bd4fd2dfa62c5da1e0f46742a70b47dc';

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

/// Stream provider for real-time tasks from Supabase
///
/// Copied from [tasksStream].
@ProviderFor(tasksStream)
const tasksStreamProvider = TasksStreamFamily();

/// Stream provider for real-time tasks from Supabase
///
/// Copied from [tasksStream].
class TasksStreamFamily extends Family<AsyncValue<List<Task>>> {
  /// Stream provider for real-time tasks from Supabase
  ///
  /// Copied from [tasksStream].
  const TasksStreamFamily();

  /// Stream provider for real-time tasks from Supabase
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

/// Stream provider for real-time tasks from Supabase
///
/// Copied from [tasksStream].
class TasksStreamProvider extends AutoDisposeStreamProvider<List<Task>> {
  /// Stream provider for real-time tasks from Supabase
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

String _$tasksByStatusHash() => r'db4ab433728164a89f2a6ff59a9f7bdb572d9d14';

/// Provider for tasks grouped by status (synchronous version for compatibility)
///
/// Copied from [tasksByStatus].
@ProviderFor(tasksByStatus)
const tasksByStatusProvider = TasksByStatusFamily();

/// Provider for tasks grouped by status (synchronous version for compatibility)
///
/// Copied from [tasksByStatus].
class TasksByStatusFamily extends Family<Map<TaskStatus, List<Task>>> {
  /// Provider for tasks grouped by status (synchronous version for compatibility)
  ///
  /// Copied from [tasksByStatus].
  const TasksByStatusFamily();

  /// Provider for tasks grouped by status (synchronous version for compatibility)
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

/// Provider for tasks grouped by status (synchronous version for compatibility)
///
/// Copied from [tasksByStatus].
class TasksByStatusProvider
    extends AutoDisposeProvider<Map<TaskStatus, List<Task>>> {
  /// Provider for tasks grouped by status (synchronous version for compatibility)
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
    Map<TaskStatus, List<Task>> Function(TasksByStatusRef provider) create,
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
  AutoDisposeProviderElement<Map<TaskStatus, List<Task>>> createElement() {
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
mixin TasksByStatusRef on AutoDisposeProviderRef<Map<TaskStatus, List<Task>>> {
  /// The parameter `boardId` of this provider.
  String get boardId;
}

class _TasksByStatusProviderElement
    extends AutoDisposeProviderElement<Map<TaskStatus, List<Task>>>
    with TasksByStatusRef {
  _TasksByStatusProviderElement(super.provider);

  @override
  String get boardId => (origin as TasksByStatusProvider).boardId;
}

String _$tasksNotifierHash() => r'271ddc6f536f67e54497e4f5cc9c20177935f3a0';

abstract class _$TasksNotifier
    extends BuildlessAutoDisposeAsyncNotifier<List<Task>> {
  late final String boardId;

  FutureOr<List<Task>> build(String boardId);
}

/// State notifier managing task operations for a board
///
/// Copied from [TasksNotifier].
@ProviderFor(TasksNotifier)
const tasksNotifierProvider = TasksNotifierFamily();

/// State notifier managing task operations for a board
///
/// Copied from [TasksNotifier].
class TasksNotifierFamily extends Family<AsyncValue<List<Task>>> {
  /// State notifier managing task operations for a board
  ///
  /// Copied from [TasksNotifier].
  const TasksNotifierFamily();

  /// State notifier managing task operations for a board
  ///
  /// Copied from [TasksNotifier].
  TasksNotifierProvider call(String boardId) {
    return TasksNotifierProvider(boardId);
  }

  @override
  TasksNotifierProvider getProviderOverride(
    covariant TasksNotifierProvider provider,
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
  String? get name => r'tasksNotifierProvider';
}

/// State notifier managing task operations for a board
///
/// Copied from [TasksNotifier].
class TasksNotifierProvider
    extends AutoDisposeAsyncNotifierProviderImpl<TasksNotifier, List<Task>> {
  /// State notifier managing task operations for a board
  ///
  /// Copied from [TasksNotifier].
  TasksNotifierProvider(String boardId)
    : this._internal(
        () => TasksNotifier()..boardId = boardId,
        from: tasksNotifierProvider,
        name: r'tasksNotifierProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$tasksNotifierHash,
        dependencies: TasksNotifierFamily._dependencies,
        allTransitiveDependencies:
            TasksNotifierFamily._allTransitiveDependencies,
        boardId: boardId,
      );

  TasksNotifierProvider._internal(
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
  FutureOr<List<Task>> runNotifierBuild(covariant TasksNotifier notifier) {
    return notifier.build(boardId);
  }

  @override
  Override overrideWith(TasksNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: TasksNotifierProvider._internal(
        () => create()..boardId = boardId,
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
  AutoDisposeAsyncNotifierProviderElement<TasksNotifier, List<Task>>
  createElement() {
    return _TasksNotifierProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is TasksNotifierProvider && other.boardId == boardId;
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
mixin TasksNotifierRef on AutoDisposeAsyncNotifierProviderRef<List<Task>> {
  /// The parameter `boardId` of this provider.
  String get boardId;
}

class _TasksNotifierProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<TasksNotifier, List<Task>>
    with TasksNotifierRef {
  _TasksNotifierProviderElement(super.provider);

  @override
  String get boardId => (origin as TasksNotifierProvider).boardId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
