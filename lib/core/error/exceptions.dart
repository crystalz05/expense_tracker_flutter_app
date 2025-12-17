abstract class AppException implements Exception {
  final String message;
  final StackTrace? stackTrace;

  const AppException(this.message, [this.stackTrace]);

  @override
  String toString() => '$runtimeType: $message';
}

class DatabaseException extends AppException {
  const DatabaseException(
  [super.message = 'Database operation failed', super.stackTrace]
  );
}

class ServerException extends AppException {
  const ServerException(
  [super.message = 'Server error occurred', super.stackTrace]);
}

class AuthException extends AppException {
  const AuthException(
  [super.message = 'Authentication failed', super.stackTrace]);
}

class CacheException extends AppException {
  const CacheException(
  [super.message = 'Cache error occurred', super.stackTrace]);
}