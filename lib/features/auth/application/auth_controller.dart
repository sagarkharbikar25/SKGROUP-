import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/storage/secure_store.dart';
import '../data/models/user_model.dart';
import '../data/repositories/auth_repository.dart';

final secureStoreProvider = Provider<SecureStore>((ref) => SecureStore());

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final secureStore = ref.watch(secureStoreProvider);
  final dio = createDioClient(secureStore);
  return RemoteAuthRepository(dio, secureStore);
});

enum AuthStatus { initial, authenticated, unauthenticated }

class AuthState {
  final AuthStatus status;
  final AppUser? user;
  final String? errorMessage;

  const AuthState({
    required this.status,
    this.user,
    this.errorMessage,
  });

  bool get isAuthenticated => status == AuthStatus.authenticated;

  AuthState copyWith({
    AuthStatus? status,
    AppUser? user,
    String? errorMessage,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: user ?? this.user,
      errorMessage: errorMessage,
    );
  }
}

class AuthController extends StateNotifier<AuthState> {
  final AuthRepository _authRepository;
  final SecureStore _secureStore;

  AuthController(this._authRepository, this._secureStore)
      : super(const AuthState(status: AuthStatus.initial)) {
    checkAuthSession();
  }

  Future<void> checkAuthSession() async {
    final token = await _secureStore.getToken();
    if (token == null || token.isEmpty) {
      state = state.copyWith(status: AuthStatus.unauthenticated);
      return;
    }
    try {
      final user = await _authRepository.getCurrentUser();
      state = state.copyWith(status: AuthStatus.authenticated, user: user);
    } catch (_) {
      // If token expired or network unreachable, restore from local or logout
      state = state.copyWith(status: AuthStatus.unauthenticated);
    }
  }

  Future<bool> login(String username, String password) async {
    try {
      final user = await _authRepository.login(username, password);
      state = state.copyWith(status: AuthStatus.authenticated, user: user, errorMessage: null);
      return true;
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
      return false;
    }
  }

  Future<void> logout() async {
    await _authRepository.logout();
    state = const AuthState(status: AuthStatus.unauthenticated);
  }
}

final authControllerProvider = StateNotifierProvider<AuthController, AuthState>((ref) {
  final repo = ref.watch(authRepositoryProvider);
  final store = ref.watch(secureStoreProvider);
  return AuthController(repo, store);
});
