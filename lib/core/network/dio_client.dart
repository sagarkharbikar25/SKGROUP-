import 'package:dio/dio.dart';
import '../constants/api_constants.dart';
import '../storage/secure_store.dart';
import 'auth_interceptor.dart';
import 'error_interceptor.dart';

Dio createDioClient(SecureStore secureStore) {
  final dio = Dio(
    BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      connectTimeout: ApiConstants.connectTimeout,
      receiveTimeout: ApiConstants.receiveTimeout,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ),
  );

  dio.interceptors.addAll([
    AuthInterceptor(secureStore),
    ErrorInterceptor(),
  ]);

  return dio;
}
