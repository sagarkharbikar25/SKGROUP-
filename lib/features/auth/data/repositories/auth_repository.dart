import 'package:dio/dio.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/errors/app_failure.dart';
import '../../../../core/storage/secure_store.dart';
import '../models/user_model.dart';

abstract class AuthRepository {
  Future<AppUser> login(String username, String password);
  Future<AppUser> getCurrentUser();
  Future<void> logout();
}

class RemoteAuthRepository implements AuthRepository {
  final Dio _dio;
  final SecureStore _secureStore;

  RemoteAuthRepository(this._dio, this._secureStore);

  @override
  Future<AppUser> login(String username, String password) async {
    try {
      final response = await _dio.post(
        ApiConstants.loginEndpoint,
        data: {
          'username': username,
          'password': password,
          'expiresInMins': 60,
        },
      );

      final user = AppUser.fromJson(response.data as Map<String, dynamic>);
      if (user.token != null) {
        await _secureStore.saveTokens(
          token: user.token!,
          refreshToken: user.refreshToken,
          userId: user.id,
        );
      }
      return user;
    } on DioException catch (e) {
      if (e.error is AppFailure) {
        throw e.error!;
      }
      throw UnknownFailure(e.message ?? 'Login failed');
    }
  }

  @override
  Future<AppUser> getCurrentUser() async {
    try {
      final response = await _dio.get(ApiConstants.meEndpoint);
      return AppUser.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      if (e.error is AppFailure) {
        throw e.error!;
      }
      throw UnknownFailure(e.message ?? 'Failed to fetch user');
    }
  }

  @override
  Future<void> logout() async {
    await _secureStore.clearAuth();
  }
}
