import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'cases.dart';
import 'support/app_harness.dart';
import 'support/screen_tour.dart';
import 'test_case.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(loadWikiFonts);

  suiteWidgetTest(tc07, (tester) async {
    await launchApp(tester, size: const Size(320, 568));
    await tourEveryScreen(tester);
  });

  suiteWidgetTest(tc08, (tester) async {
    await launchApp(tester, textScale: 1.8);
    await tourEveryScreen(tester);
  });

  suiteWidgetTest(tc09, (tester) async {
    await launchApp(tester, size: const Size(844, 390));
    await tourEveryScreen(tester);
  });

  suiteWidgetTest(tc17, (tester) async {
    await launchApp(tester, textScale: 1.8);
    await openChapter(tester, 'Explorar La Juguetería');

    for (final (label, period) in [
      ('Fase 2: Mercancía nueva', 'Segundo tercio'),
      ('Fase 3: Remate final', 'Último tercio'),
      ('Fase 1: Luces apagadas', 'Primer tercio'),
    ]) {
      final tile = find.bySemanticsLabel(label);
      await tester.scrollUntilVisible(
        tile,
        180,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.ensureVisible(tile);
      await tester.pumpAndSettle();
      await tester.tap(tile);
      await tester.pumpAndSettle();
      expect(find.text(period), findsOneWidget, reason: label);
      expect(tester.takeException(), isNull, reason: label);
    }
  });
}
