// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:bearstards_movil_application/main.dart';

void main() {
  testWidgets('home shows the wiki sections and opens weapons', (tester) async {
    await tester.pumpWidget(const BastardososWikiApp());

    expect(find.text('bastardosos wiki'), findsOneWidget);
    expect(find.text('pistola de dardos'), findsOneWidget);

    await tester.tap(find.text('armas'));
    await tester.pumpAndSettle();

    expect(find.text('spray y mechero'), findsOneWidget);
  });
}
