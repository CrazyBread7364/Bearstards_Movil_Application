import 'package:flutter/material.dart';
import 'package:bearstards_movil_application/features/wiki/domain/models/wiki_entry.dart';
import 'package:bearstards_movil_application/features/wiki/presentation/screens/characters_screen.dart';
import 'package:bearstards_movil_application/features/wiki/presentation/screens/entry_detail_screen.dart';
import 'package:bearstards_movil_application/features/wiki/presentation/screens/stealth_screen.dart';
import 'package:flutter_test/flutter_test.dart';

import 'cases.dart';
import 'support/app_harness.dart';
import 'test_case.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(loadWikiFonts);

  suiteWidgetTest(tc01, (tester) async {
    await launchApp(tester);

    await tester.tap(find.bySemanticsLabel('Explorar Personajes'));
    await tester.pumpAndSettle();
    expect(find.byType(CharactersScreen), findsOneWidget);
    expect(find.byType(StealthScreen), findsNothing);

    await tester.tap(find.byTooltip('Volver'));
    await tester.pumpAndSettle();
    expect(find.bySemanticsLabel('Explorar Arsenal'), findsOneWidget);
  });

  suiteWidgetTest(tc02, (tester) async {
    await launchApp(tester);

    await tester.tap(find.bySemanticsLabel('Explorar Arsenal'));
    await tester.pumpAndSettle();
    await tester.tap(find.bySemanticsLabel('Consultar Aguja de coser'));
    await tester.pumpAndSettle();
    final detail = tester.widget<EntryDetailScreen>(
      find.byType(EntryDetailScreen),
    );
    expect(detail.entry.id, EntryId.needle);
    expect(find.textContaining('25 puntos de vida'), findsOneWidget);

    await tester.tap(find.byTooltip('Volver'));
    await tester.pumpAndSettle();
    expect(find.text('Dos armas.\nDos formas de actuar.'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  suiteWidgetTest(tc03, (tester) async {
    await launchApp(tester);

    await tester.tap(find.bySemanticsLabel('Explorar Sigilo'));
    await tester.pumpAndSettle();
    await tester.tap(find.bySemanticsLabel('Correr te delata'));
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.text('Acción delatora'),
      180,
      scrollable: find.byType(Scrollable).first,
    );

    expect(find.text('Acción delatora'), findsOneWidget);
    expect(find.textContaining('movimiento apresurado'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  suiteWidgetTest(tc04, (tester) async {
    await launchApp(tester);

    await tester.tap(find.bySemanticsLabel('Explorar Sigilo'));
    await tester.pumpAndSettle();
    await tester.tap(find.bySemanticsLabel('Correr te delata'));
    await tester.pumpAndSettle();
    final before = tester.state(find.byType(StealthScreen));

    await tester.tap(find.bySemanticsLabel('Ir a Sigilo'));
    await tester.pumpAndSettle();

    expect(tester.state(find.byType(StealthScreen)), same(before));
    await tester.scrollUntilVisible(
      find.text('Acción delatora'),
      180,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.textContaining('movimiento apresurado'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  suiteWidgetTest(tc05, (tester) async {
    await launchApp(tester);

    await tester.tap(find.bySemanticsLabel('Explorar La Juguetería'));
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.bySemanticsLabel('Fase 2: Mercancía nueva'),
      180,
    );
    expect(find.text('Primer tercio'), findsOneWidget);

    await tester.tap(find.bySemanticsLabel('Fase 2: Mercancía nueva'));
    await tester.pumpAndSettle();
    expect(find.text('Segundo tercio'), findsOneWidget);
    expect(find.textContaining('Aparece una sola vez'), findsOneWidget);

    await tester.tap(find.bySemanticsLabel('Fase 3: Remate final'));
    await tester.pumpAndSettle();
    expect(find.text('Último tercio'), findsOneWidget);
    expect(find.textContaining('La mitad de los NPC'), findsOneWidget);

    await tester.tap(find.bySemanticsLabel('Fase 1: Luces apagadas'));
    await tester.pumpAndSettle();
    expect(find.text('Primer tercio'), findsOneWidget);
    expect(find.textContaining('iluminación reducida'), findsOneWidget);

    expect(find.text('10–15 min'), findsNothing);
    expect(tester.takeException(), isNull);
  });
}
