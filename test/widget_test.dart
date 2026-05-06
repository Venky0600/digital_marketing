import 'package:flutter_test/flutter_test.dart';
import 'package:betterdigital/main.dart';
import 'package:provider/provider.dart';
import 'package:betterdigital/providers/app_provider.dart';

void main() {
  testWidgets('BrandBridge app smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => AppProvider(),
        child: const BrandBridgeApp(),
      ),
    );
    expect(find.byType(BrandBridgeApp), findsOneWidget);
  });
}
