import 'package:bearstards_movil_application/features/results/domain/repositories/results_repository.dart';
import 'package:bearstards_movil_application/features/results/presentation/screens/scores_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/results_fakes.dart';
import 'cases.dart';
import 'support/app_harness.dart';
import 'test_case.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(loadWikiFonts);

  Future<void> openScores(
    WidgetTester tester,
    ResultsRepository repository,
  ) async {
    await launchApp(tester, results: repository);
    await openChapter(tester, 'Explorar Resultados globales');
  }

  Future<void> scrollTo(WidgetTester tester, Finder finder) async {
    await tester.scrollUntilVisible(
      finder,
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.ensureVisible(finder);
    await tester.pumpAndSettle();
  }

  suiteWidgetTest(tc21, (tester) async {
    await openScores(tester, FakeResultsRepository.always(sampleRanking));
    expect(find.byType(ScoresScreen), findsOneWidget);
    expect(find.text('RESULTADOS GLOBALES'), findsOneWidget);

    await tester.tap(find.byTooltip('Volver'));
    await tester.pumpAndSettle();
    expect(find.byType(ScoresScreen), findsNothing);
    expect(
      find.bySemanticsLabel('Explorar Resultados globales'),
      findsOneWidget,
    );
    expect(tester.takeException(), isNull);
  });

  suiteWidgetTest(tc22, (tester) async {
    await openScores(tester, FakeResultsRepository.always(sampleRanking));
    await scrollTo(tester, find.bySemanticsLabel(RegExp('Puesto 5')));

    const expected = [
      'Puesto 1: memo, 600 puntos, 2 partidas, 100 % de victorias',
      'Puesto 2: CarlOso, 500 puntos, 3 partidas, 33 % de victorias',
      'Puesto 3: AngelOso, 200 puntos, 3 partidas, 67 % de victorias',
      'Puesto 4: celaya, 0 puntos, sin partidas',
      'Puesto 5: memo2, −150 puntos, 2 partidas, 0 % de victorias',
    ];
    for (final label in expected) {
      expect(find.bySemanticsLabel(label), findsOneWidget, reason: label);
    }

    final order = [
      for (final name in ['memo', 'CarlOso', 'AngelOso', 'celaya', 'memo2'])
        tester.getTopLeft(find.text(name)).dy,
    ];
    expect(order, orderedEquals([...order]..sort()), reason: 'mismo orden');
    expect(find.text('−150'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  suiteWidgetTest(tc23, (tester) async {
    await openScores(tester, FakeResultsRepository.always(sampleRanking));
    await scrollTo(tester, find.text('Sin partidas · — victorias'));

    expect(find.text('Sin partidas · — victorias'), findsOneWidget);
    expect(find.textContaining('NaN'), findsNothing);
    expect(find.textContaining('Infinity'), findsNothing);
  });

  suiteWidgetTest(tc24, (tester) async {
    await openScores(tester, FakeResultsRepository.always(const []));
    expect(find.text('Aún no hay partidas registradas'), findsOneWidget);
    expect(find.text('No se pudieron cargar los resultados'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  suiteWidgetTest(tc25, (tester) async {
    await openScores(
      tester,
      FakeResultsRepository([
        () => throw const ResultsUnavailable('sin conexión'),
        () => sampleRanking,
      ]),
    );
    expect(find.text('No se pudieron cargar los resultados'), findsOneWidget);
    expect(find.textContaining('Revisa tu conexión'), findsOneWidget);

    await tester.tap(find.text('Reintentar'));
    await tester.pumpAndSettle();
    expect(find.text('No se pudieron cargar los resultados'), findsNothing);
    expect(find.bySemanticsLabel(RegExp('Puesto 1: memo')), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  suiteWidgetTest(tc26, (tester) async {
    await openScores(
      tester,
      FakeResultsRepository([
        () => sampleRanking,
        () => throw const ResultsUnavailable('sin conexión'),
      ]),
    );
    await scrollTo(tester, find.text('Actualizar'));
    await tester.tap(find.text('Actualizar'));
    await tester.pumpAndSettle();
    await tester.drag(find.byType(Scrollable).first, const Offset(0, 3000));
    await tester.pumpAndSettle();

    expect(find.text('No se pudo actualizar'), findsOneWidget);
    expect(find.text('Reintentar'), findsOneWidget);
    expect(find.bySemanticsLabel(RegExp('Puesto 1: memo')), findsOneWidget);
    expect(find.text('No se pudieron cargar los resultados'), findsNothing);
  });
}
