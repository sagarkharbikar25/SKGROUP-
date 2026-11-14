import 'dart:io';
import 'package:dio/dio.dart';
import '../errors/app_failure.dart';

class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final failure = _mapDioExceptionToFailure(err);
    final customException = DioException(
      requestOptions: err.requestOptions,
      response: err.response,
      type: err.type,
      error: failure,
      message: failure.message,
    );
    return handler.next(customException);
  }

  static AppFailure _mapDioExceptionToFailure(DioException err) {
    switch (err.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const TimeoutFailure('Request connection timed out.');

      case DioExceptionType.badResponse:
        final statusCode = err.response?.statusCode;
        if (statusCode == 401 || statusCode == 403) {
          final msg = err.response?.data is Map
              ? (err.response?.data['message'] ?? 'Unauthorized')
              : 'Invalid credentials or session expired.';
          return UnauthorizedFailure(msg.toString(), statusCode);
        }
        if (statusCode != null && statusCode >= 500) {
          return ServerFailure('Server error occurred ($statusCode).', statusCode);
        }
        final msg = err.response?.data is Map
            ? (err.response?.data['message'] ?? 'Bad Request')
            : 'Request failed ($statusCode).';
        return UnknownFailure(msg.toString(), statusCode);

      case DioExceptionType.connectionError:
        return const NetworkFailure('No internet connection or server unreachable.');

      case DioExceptionType.cancel:
        return const UnknownFailure('Request was cancelled.');

      case DioExceptionType.unknown:
      default:
        if (err.error is SocketException) {
          return const NetworkFailure('No internet connection.');
        }
        return UnknownFailure(err.message ?? 'Unexpected error occurred.');
    }
  }
}
