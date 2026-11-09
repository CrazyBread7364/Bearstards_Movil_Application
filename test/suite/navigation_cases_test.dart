import 'package:bearstards_movil_application/features/wiki/presentation/screens/characters_screen.dart';
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
}
