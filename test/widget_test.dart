import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_application_1/main.dart';

void main() {
  testWidgets('App can be built without crashing', (WidgetTester tester) async {
    // Build app
    await tester.pumpWidget(const MyApp());

    // Jika sampai sini tidak error, test lulus
    expect(find.byType(MyApp), findsOneWidget);
  });
}
