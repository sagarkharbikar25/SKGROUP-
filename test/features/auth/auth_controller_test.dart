import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shopsphere/features/auth/data/models/user_model.dart';
import 'package:shopsphere/features/auth/data/repositories/auth_repository.dart';
import 'package:shopsphere/core/storage/secure_store.dart';
import 'package:shopsphere/features/auth/application/auth_controller.dart';

class MockAuthRepository extends Mock implements AuthRepository {}
class MockSecureStore extends Mock implements SecureStore {}

void main() {
  late MockAuthRepository mockAuthRepository;
  late MockSecureStore mockSecureStore;
  late AuthController authController;

  const testUser = AppUser(
    id: 1,
    username: 'emilys',
    email: 'emily@dummyjson.com',
    firstName: 'Emily',
    lastName: 'Johnson',
    gender: 'female',
    image: 'https://example.com/emily.png',
    token: 'jwt-token',
  );

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    mockSecureStore = MockSecureStore();

    when(() => mockSecureStore.getToken()).thenAnswer((_) async => null);
    authController = AuthController(mockAuthRepository, mockSecureStore);
  });

  group('AuthController', () {
    test('initial state restores to unauthenticated when no token found', () async {
      await authController.checkAuthSession();
      expect(authController.state.status, AuthStatus.unauthenticated);
      expect(authController.state.isAuthenticated, isFalse);
    });

    test('login succeeds and sets authenticated state with user profile', () async {
      when(() => mockAuthRepository.login('emilys', 'emilyspass'))
          .thenAnswer((_) async => testUser);

      final success = await authController.login('emilys', 'emilyspass');

      expect(success, isTrue);
      expect(authController.state.status, AuthStatus.authenticated);
      expect(authController.state.user?.username, 'emilys');
      expect(authController.state.isAuthenticated, isTrue);
    });

    test('logout clears secure store and resets to unauthenticated', () async {
      when(() => mockAuthRepository.logout()).thenAnswer((_) async {});

      await authController.logout();

      expect(authController.state.status, AuthStatus.unauthenticated);
      expect(authController.state.user, isNull);
    });
  });
}
