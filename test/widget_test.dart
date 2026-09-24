import 'package:flutter_test/flutter_test.dart';
import 'package:reelsapp/main.dart';

void main() {
  testWidgets('ReelsApp smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const ReelsApp());
    expect(find.byType(ReelsApp), findsOneWidget);
  });
}
