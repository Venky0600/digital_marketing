import 'package:flutter_test/flutter_test.dart';
import 'package:betterdigital/providers/app_provider.dart';
import 'package:betterdigital/models/user_model.dart';

void main() {
  group('AppProvider State Management Tests', () {
    test('Initial state is correct', () {
      final provider = AppProvider();
      expect(provider.isDark, isFalse);
      expect(provider.currentUser, isNull);
    });

    test('toggleTheme updates state', () {
      final provider = AppProvider();
      provider.toggleTheme();
      expect(provider.isDark, isTrue);
      provider.toggleTheme();
      expect(provider.isDark, isFalse);
    });

    test('setUser correctly updates current user', () {
      final provider = AppProvider();
      final user = User(
        id: '123',
        name: 'John Doe',
        email: 'john@example.com',
        role: 'businessOwner',
        token: 'fake_jwt_token'
      );
      
      provider.setUser(user);
      expect(provider.currentUser, isNotNull);
      expect(provider.currentUser?.name, 'John Doe');
      expect(provider.isBusinessOwner, isTrue);
    });

    test('logout clears user state', () {
      final provider = AppProvider();
      provider.setUser(User(id: '1', name: 'A', email: 'a@b.com', role: 'admin', token: 't'));
      expect(provider.currentUser, isNotNull);
      
      provider.logout();
      expect(provider.currentUser, isNull);
    });
  });
}
