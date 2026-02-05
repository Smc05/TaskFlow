import 'package:fpdart/fpdart.dart';
import 'package:taskflow/core/errors/failures.dart';

/// Type alias for Either with Failure on the left
/// This is the standard return type for repository methods
typedef Result<T> = Either<Failure, T>;

/// Type alias for async Either with Failure on the left
typedef AsyncResult<T> = Future<Either<Failure, T>>;

/// Extension methods for Result type
extension ResultExtension<T> on Result<T> {
  /// Returns true if the result is a success (Right)
  bool get isSuccess => isRight();

  /// Returns true if the result is a failure (Left)
  bool get isFailure => isLeft();

  /// Gets the value if it's a success, otherwise returns null
  T? get valueOrNull => fold((_) => null, (value) => value);

  /// Gets the failure if it exists, otherwise returns null
  Failure? get failureOrNull => fold((failure) => failure, (_) => null);

  /// Unwraps the value or throws the failure
  T getOrThrow() =>
      fold((failure) => throw Exception(failure.message), (value) => value);

  /// Alias for flatMap to chain operations that return Result
  Result<R> flatMap<R>(Result<R> Function(T value) transform) {
    return fold((failure) => Left(failure), transform);
  }

  /// Maps the success value to another type
  Result<R> mapValue<R>(R Function(T value) transform) {
    return map(transform);
  }

  /// Handles both success and failure cases with callbacks
  R when<R>({
    required R Function(T value) success,
    required R Function(Failure failure) failure,
  }) {
    return fold(failure, success);
  }
}

/// Extension methods for AsyncResult type
extension AsyncResultExtension<T> on AsyncResult<T> {
  /// Maps the success value to another type asynchronously
  AsyncResult<R> mapValue<R>(R Function(T value) transform) {
    return then((either) => either.map(transform));
  }

  /// Chain another async operation on success
  AsyncResult<R> flatMapValue<R>(AsyncResult<R> Function(T value) transform) {
    return then(
      (either) =>
          either.fold((failure) => Future.value(Left(failure)), transform),
    );
  }

  /// Gets the value or returns a default value
  Future<T> getOrElse(T defaultValue) {
    return then((either) => either.fold((_) => defaultValue, (value) => value));
  }
}

/// Utility functions for creating Results
class Results {
  Results._();

  /// Create a successful result
  static Result<T> success<T>(T value) => Right(value);

  /// Create a failed result
  static Result<T> failure<T>(Failure failure) => Left(failure);

  /// Create a result from a nullable value
  static Result<T> fromNullable<T>(T? value, Failure Function() onNull) {
    return value != null ? Right(value) : Left(onNull());
  }

  /// Wrap a synchronous operation in a Result
  static Result<T> tryCatch<T>(
    T Function() operation,
    Failure Function(Object error, StackTrace stackTrace) onError,
  ) {
    try {
      return Right(operation());
    } catch (error, stackTrace) {
      return Left(onError(error, stackTrace));
    }
  }

  /// Wrap an asynchronous operation in an AsyncResult
  static AsyncResult<T> tryCatchAsync<T>(
    Future<T> Function() operation,
    Failure Function(Object error, StackTrace stackTrace) onError,
  ) async {
    try {
      final value = await operation();
      return Right(value);
    } catch (error, stackTrace) {
      return Left(onError(error, stackTrace));
    }
  }
}
