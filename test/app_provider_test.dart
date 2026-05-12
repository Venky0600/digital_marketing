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

    test('login correctly updates current user', () {
      final provider = AppProvider();
      const user = AppUser(
        name: 'John Doe',
        email: 'john@example.com',
        avatarUrl: 'https://i.pravatar.cc/300',
        role: UserRole.businessOwner,
        company: 'John Co',
      );
      
      provider.login(user);
      expect(provider.currentUser, isNotNull);
      expect(provider.currentUser?.name, 'John Doe');
      expect(provider.isBusinessOwner, isTrue);
    });

    test('logout clears user state', () {
      final provider = AppProvider();
      const user = AppUser(
        name: 'Jane Smith',
        email: 'jane@smith.com',
        avatarUrl: 'https://i.pravatar.cc/300',
        role: UserRole.influencer,
        niche: 'Fashion',
      );
      
      provider.login(user);
      expect(provider.currentUser, isNotNull);
      
      provider.logout();
      expect(provider.currentUser, isNull);
    });
  });
}
