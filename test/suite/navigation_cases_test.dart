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
}
