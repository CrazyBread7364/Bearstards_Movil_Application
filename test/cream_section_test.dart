import 'package:bearstards_movil_application/core/widgets/cream_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget host(double width, Widget child) => Directionality(
    textDirection: TextDirection.ltr,
    child: Align(
      alignment: Alignment.topLeft,
      child: SizedBox(width: width, child: child),
    ),
  );

  for (final width in [320.0, 390.0, 600.0]) {
    testWidgets('cream section wraps its child at $width px wide', (
      tester,
    ) async {
      await tester.pumpWidget(
        host(width, const CreamSection(child: Text('contenido'))),
      );
      expect(tester.takeException(), isNull);
      expect(find.text('contenido'), findsOneWidget);
      expect(tester.getSize(find.byType(CreamSection)).width, width);
    });
  }

  testWidgets('padding reserves the wave band above the content', (
    tester,
  ) async {
    await tester.pumpWidget(
      host(
        390,
        const CreamSection(
          padding: EdgeInsets.fromLTRB(10, 50, 10, 20),
          child: SizedBox(height: 30, width: 30, key: Key('hijo')),
        ),
      ),
    );
    final section = tester.getTopLeft(find.byType(CreamSection));
    final child = tester.getTopLeft(find.byKey(const Key('hijo')));
    expect(child.dy - section.dy, 50);
    expect(tester.getSize(find.byType(CreamSection)).height, 100);
  });
}
