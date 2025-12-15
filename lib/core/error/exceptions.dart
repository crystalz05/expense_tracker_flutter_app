
class DatabaseException implements Exception {
  final String message;
  final StackTrace? stackTrace;
  DatabaseException(this.message, [this.stackTrace]);
}


