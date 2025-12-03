import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:safehand_poultry_manager/main.dart';

void main() {
  testWidgets('App builds smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const ProviderScope(child: PoultryManagerApp()));

    // Allow router to settle
    await tester.pumpAndSettle();

    // Verify that the dashboard is shown.
    expect(find.text('Dashboard'), findsOneWidget);
  });
}
