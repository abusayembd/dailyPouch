import 'package:equatable/equatable.dart';

/// Base class for all functional failures in the application.
abstract class Failure extends Equatable {
  final String message;
  final int? code;

  const Failure(this.message, {this.code});

  @override
  List<Object?> get props => [message, code];
}

/// Failure representing database errors (read, write, schema violation).
class DatabaseFailure extends Failure {
  const DatabaseFailure(super.message, {super.code});
}

/// Failure representing local cache errors.
class CacheFailure extends Failure {
  const CacheFailure(super.message, {super.code});
}

/// Failure representing user input or domain validation errors.
class ValidationFailure extends Failure {
  const ValidationFailure(super.message, {super.code});
}

/// Failure representing notification scheduling or channel errors.
class NotificationFailure extends Failure {
  const NotificationFailure(super.message, {super.code});
}

/// Generic fallback failure for unexpected errors.
class UnexpectedFailure extends Failure {
  const UnexpectedFailure(super.message, {super.code});
}
