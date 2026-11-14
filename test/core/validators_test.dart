import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Input Validation Logic', () {
    test('username requires non-empty string', () {
      bool isValidUsername(String? val) => val != null && val.trim().isNotEmpty;

      expect(isValidUsername(''), isFalse);
      expect(isValidUsername('   '), isFalse);
      expect(isValidUsername(null), isFalse);
      expect(isValidUsername('emilys'), isTrue);
    });

    test('password requires at least 6 characters', () {
      bool isValidPassword(String? val) => val != null && val.length >= 6;

      expect(isValidPassword('12345'), isFalse);
      expect(isValidPassword(''), isFalse);
      expect(isValidPassword(null), isFalse);
      expect(isValidPassword('123456'), isTrue);
      expect(isValidPassword('emilyspass'), isTrue);
    });

    test('email format validation', () {
      bool isValidEmail(String? val) {
        if (val == null || val.trim().isEmpty) return false;
        return val.contains('@') && val.contains('.');
      }

      expect(isValidEmail('bademail'), isFalse);
      expect(isValidEmail('user@'), isFalse);
      expect(isValidEmail('emily@example.com'), isTrue);
    });
  });
}
