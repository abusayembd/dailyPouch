/// Base exception class for data-layer error throwing.
class DatabaseException implements Exception {
  final String message;
  final int? code;

  DatabaseException(this.message, {this.code});

  @override
  String toString() => 'DatabaseException: $message (code: $code)';
}

class CacheException implements Exception {
  final String message;

  CacheException(this.message);

  @override
  String toString() => 'CacheException: $message';
}

class ValidationException implements Exception {
  final String message;

  ValidationException(this.message);

  @override
  String toString() => 'ValidationException: $message';
}

class NotificationException implements Exception {
  final String message;

  NotificationException(this.message);

  @override
  String toString() => 'NotificationException: $message';
}
