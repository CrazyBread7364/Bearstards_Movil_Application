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

    expect(find.bySemanticsLabel('Portada de Bearstards Wiki'), findsOneWidget);
    expect(find.bySemanticsLabel('Explorar Arsenal'), findsOneWidget);

    await tester.tap(find.bySemanticsLabel('Explorar Arsenal'));
    await tester.pumpAndSettle();

    expect(find.text('pistola de dardos'), findsOneWidget);
  });

  testWidgets('map phases reveal the selected MVP information', (tester) async {
    await tester.pumpWidget(const BastardososWikiApp());

    await tester.tap(find.bySemanticsLabel('Explorar La Juguetería'));
    await tester.pumpAndSettle();

    expect(find.text('0–5 min'), findsOneWidget);
    await tester.tap(find.bySemanticsLabel('mercancía nueva, 5–10 min'));
    await tester.pumpAndSettle();
    expect(find.text('5–10 min'), findsOneWidget);
    expect(find.textContaining('Aparece la pistola de dardos'), findsOneWidget);
  });

  testWidgets('stealth actions explain when a bear is revealed', (tester) async {
    await tester.pumpWidget(const BastardososWikiApp());

    await tester.tap(find.bySemanticsLabel('Explorar Sigilo'));
    await tester.pumpAndSettle();
    await tester.tap(find.bySemanticsLabel('correr te delata'));
    await tester.pumpAndSettle();

    expect(find.text('acción delatora'), findsOneWidget);
    expect(find.textContaining('movimiento apresurado'), findsOneWidget);
  });
}
