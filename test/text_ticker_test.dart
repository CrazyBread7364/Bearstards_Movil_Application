import 'package:bearstards_movil_application/core/widgets/text_ticker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget host({bool disableAnimations = false}) => MediaQuery(
    data: MediaQueryData(
      size: const Size(390, 800),
      disableAnimations: disableAnimations,
    ),
    child: const Directionality(
      textDirection: TextDirection.ltr,
      child: Material(
        child: TextTicker(phrases: ['Sigilo', 'Engaño', 'Peluches en guerra']),
      ),
    ),
  );

  double shift(WidgetTester tester) => tester
      .widget<FractionalTranslation>(
        find.descendant(
          of: find.byType(TextTicker),
          matching: find.byType(FractionalTranslation),
        ),
      )
      .translation
      .dx;

  Finder button(String label) => find.bySemanticsLabel(label);

  testWidgets('the phrases slide sideways and loop', (tester) async {
    await tester.pumpWidget(host());
    expect(shift(tester), 0);

    await tester.pump(const Duration(seconds: 10));
    final first = shift(tester);
    expect(first, lessThan(0));
    expect(first, greaterThanOrEqualTo(-.5));

    await tester.pump(const Duration(seconds: 40));
    expect(shift(tester), greaterThanOrEqualTo(-.5), reason: 'loops around');
    expect(tester.takeException(), isNull);
  });

  testWidgets('the pause button stops and resumes the band', (tester) async {
    await tester.pumpWidget(host());
    await tester.pump(const Duration(seconds: 5));

    await tester.tap(button('Pausar la cinta de texto'));
    await tester.pump();
    final stopped = shift(tester);
    await tester.pump(const Duration(seconds: 10));
    expect(shift(tester), stopped);
    expect(button('Reanudar la cinta de texto'), findsOneWidget);

    await tester.tap(button('Reanudar la cinta de texto'));
    await tester.pump(); // the ticker starts on the first frame
    await tester.pump(const Duration(seconds: 5));
    expect(shift(tester), isNot(stopped));
    expect(button('Pausar la cinta de texto'), findsOneWidget);
  });

  testWidgets('with reduced motion it stays still and has no button', (
    tester,
  ) async {
    await tester.pumpWidget(host(disableAnimations: true));
    await tester.pump(const Duration(seconds: 10));
    expect(shift(tester), 0);
    expect(button('Pausar la cinta de texto'), findsNothing);
  });

  testWidgets('the decorative phrases are hidden from screen readers', (
    tester,
  ) async {
    await tester.pumpWidget(host());
    expect(find.bySemanticsLabel('SIGILO'), findsNothing);
    expect(find.text('SIGILO'), findsNWidgets(2));
  });
}
