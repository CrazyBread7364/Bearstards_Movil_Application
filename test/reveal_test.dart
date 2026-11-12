import 'package:bearstards_movil_application/core/widgets/reveal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget host(Widget child, {bool disableAnimations = false}) => MediaQuery(
    data: MediaQueryData(disableAnimations: disableAnimations),
    child: Directionality(textDirection: TextDirection.ltr, child: child),
  );

  double opacity(WidgetTester tester) => tester
      .widget<FadeTransition>(
        find.descendant(
          of: find.byType(Reveal),
          matching: find.byType(FadeTransition),
        ),
      )
      .opacity
      .value;

  double lift(WidgetTester tester) => tester
      .widget<Transform>(
        find.descendant(
          of: find.byType(Reveal),
          matching: find.byType(Transform),
        ),
      )
      .transform
      .getTranslation()
      .y;

  testWidgets('starts hidden and lifted, then settles in place', (
    tester,
  ) async {
    await tester.pumpWidget(host(const Reveal(child: Text('hola'))));
    expect(opacity(tester), 0);
    expect(lift(tester), greaterThan(0));

    await tester.pumpAndSettle();
    expect(opacity(tester), 1);
    expect(lift(tester), 0);
  });

  testWidgets('never becomes more than fully opaque while it bounces', (
    tester,
  ) async {
    await tester.pumpWidget(host(const Reveal(child: Text('hola'))));
    for (var i = 0; i < 12; i++) {
      await tester.pump(const Duration(milliseconds: 50));
      expect(opacity(tester), inInclusiveRange(0, 1));
    }
  });

  testWidgets('the delay keeps it hidden until its turn', (tester) async {
    await tester.pumpWidget(
      host(
        const Reveal(delay: Duration(milliseconds: 300), child: Text('hola')),
      ),
    );
    await tester.pump(const Duration(milliseconds: 200));
    expect(opacity(tester), 0);

    await tester.pumpAndSettle();
    expect(opacity(tester), 1);
  });

  testWidgets('shows immediately when the system reduces motion', (
    tester,
  ) async {
    await tester.pumpWidget(
      host(const Reveal(child: Text('hola')), disableAnimations: true),
    );
    expect(opacity(tester), 1);
    expect(lift(tester), 0);
  });

  testWidgets('shows immediately when it already revealed once', (
    tester,
  ) async {
    await tester.pumpWidget(
      host(const Reveal(animate: false, child: Text('hola'))),
    );
    expect(opacity(tester), 1);
    expect(lift(tester), 0);
  });
}
