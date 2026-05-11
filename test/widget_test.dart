import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:betterdigital/providers/app_provider.dart';
import 'package:betterdigital/screens/login_screen.dart';
import 'package:betterdigital/screens/splash_screen.dart';
import 'package:betterdigital/screens/analytics_screen.dart';

// Helper: wraps a widget with the required Provider
Widget withProvider(Widget child) {
  return ChangeNotifierProvider<AppProvider>(
    create: (_) => AppProvider(),
    child: MaterialApp(home: child),
  );
}

void main() {
  // ── AppProvider Unit Tests ────────────────────────────────────────────────
  group('AppProvider', () {
    test('initial isDark is false', () {
      final provider = AppProvider();
      expect(provider.isDark, false);
    });

    test('toggleTheme flips isDark', () {
      final provider = AppProvider();
      provider.toggleTheme();
      expect(provider.isDark, true);
      provider.toggleTheme();
      expect(provider.isDark, false);
    });

    test('initial campaigns list is empty', () {
      final provider = AppProvider();
      expect(provider.campaigns, isEmpty);
    });

    test('initial influencers list is empty', () {
      final provider = AppProvider();
      expect(provider.influencers, isEmpty);
    });
  });

  // ── Login Screen Tests ────────────────────────────────────────────────────
  group('LoginScreen', () {
    testWidgets('shows role picker on initial load', (tester) async {
      await tester.pumpWidget(withProvider(const LoginScreen()));
      await tester.pump();

      // Should show the welcome text
      expect(find.textContaining('Welcome'), findsOneWidget);
    });

    testWidgets('shows Business Owner role card', (tester) async {
      await tester.pumpWidget(withProvider(const LoginScreen()));
      await tester.pump();

      expect(find.text('Business Owner'), findsOneWidget);
    });

    testWidgets('shows Influencer role card', (tester) async {
      await tester.pumpWidget(withProvider(const LoginScreen()));
      await tester.pump();

      expect(find.text('Influencer'), findsOneWidget);
    });

    testWidgets('tapping Business Owner card advances to login form',
        (tester) async {
      await tester.pumpWidget(withProvider(const LoginScreen()));
      await tester.pump();

      // Tap the Business Owner role card
      await tester.tap(find.text('Business Owner'));
      await tester.pumpAndSettle(const Duration(milliseconds: 500));

      // Email and password fields should now appear
      expect(find.text('Email Address'), findsOneWidget);
    });
  });

  // ── Analytics Screen Tests ────────────────────────────────────────────────
  group('AnalyticsDashboardScreen', () {
    testWidgets('shows loading indicator initially', (tester) async {
      await tester.pumpWidget(withProvider(const AnalyticsDashboardScreen()));
      await tester.pump(); // frame after initState

      // Should show a loading indicator while fetching
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('shows AppBar with correct title', (tester) async {
      await tester.pumpWidget(withProvider(const AnalyticsDashboardScreen()));
      await tester.pump();

      expect(find.text('Analytics Dashboard'), findsOneWidget);
    });
  });
}
