class UserExistsExceptions implements Exception {
  String? message;
  Exception? exception;

  UserExistsExceptions({
    this.message,
    this.exception,
  });

  @override
  String toString() =>
      'UserExistsExceptions(message: $message, exception: $exception)';
}
