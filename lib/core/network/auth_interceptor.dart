import 'package:dio/dio.dart';
import '../storage/secure_store.dart';

class AuthInterceptor extends Interceptor {
  final SecureStore _secureStore;

  AuthInterceptor(this._secureStore);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final token = await _secureStore.getToken();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    return handler.next(options);
  }
}
