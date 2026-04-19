import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flowmarket_app/app.dart';

void main() {
  testWidgets('App renders smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(child: FlowMarketApp()),
    );
    // Just verify it builds without error
    expect(find.byType(FlowMarketApp), findsOneWidget);
  });
}
