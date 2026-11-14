/// Sealed failure hierarchy for predictable error representation across the app.
sealed class AppFailure {
  final String message;
  final int? statusCode;

  const AppFailure(this.message, [this.statusCode]);

  @override
  String toString() => '$runtimeType(message: $message, statusCode: $statusCode)';
}

class NetworkFailure extends AppFailure {
  const NetworkFailure([super.message = 'No internet connection. Please check your network.']);
}

class TimeoutFailure extends AppFailure {
  const TimeoutFailure([super.message = 'Connection timed out. Please try again.']);
}

class UnauthorizedFailure extends AppFailure {
  const UnauthorizedFailure([super.message = 'Session expired or invalid credentials.', super.statusCode = 401]);
}

class ServerFailure extends AppFailure {
  const ServerFailure([super.message = 'Server encountered an error. Please try again later.', super.statusCode]);
}

class CacheFailure extends AppFailure {
  const CacheFailure([super.message = 'Failed to load cached data.']);
}

class UnknownFailure extends AppFailure {
  const UnknownFailure([super.message = 'An unexpected error occurred.', super.statusCode]);
}
