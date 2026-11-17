import 'dart:async';

import 'package:bearstards_movil_application/features/results/domain/models/player_score.dart';
import 'package:bearstards_movil_application/features/results/domain/repositories/results_repository.dart';
import 'package:bearstards_movil_application/features/results/presentation/screens/scores_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'suite/support/app_harness.dart';
import 'support/results_fakes.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(loadWikiFonts);

  final ranking = [
    testScore('memo', points: 600, games: 2, wins: 2, id: 1),
    testScore('CarlOso', points: 500, games: 3, wins: 1, id: 2),
    testScore('AngelOso', points: 200, games: 3, wins: 2, id: 3),
    testScore('celaya', id: 4),
    testScore('memo2', points: -150, games: 2, id: 5),
  ];

  Future<void> openScores(
    WidgetTester tester,
    ResultsRepository repository, {
    Size size = const Size(390, 844),
    double textScale = 1,
  }) async {
    await launchApp(
      tester,
      results: repository,
      size: size,
      textScale: textScale,
    );
    await openChapter(tester, 'Explorar Resultados globales');
  }

  testWidgets('the home screen opens the results screen', (tester) async {
    await openScores(tester, FakeResultsRepository.always(ranking));
    expect(find.byType(ScoresScreen), findsOneWidget);
    expect(find.text('RESULTADOS GLOBALES'), findsOneWidget);
  });

  testWidgets('shows the loading state while the first load runs', (
    tester,
  ) async {
    final pending = Completer<List<PlayerScore>>();
    await launchApp(
      tester,
      results: FakeResultsRepository([() => pending.future]),
    );
    final tile = find.bySemanticsLabel('Explorar Resultados globales');
    await tester.ensureVisible(tile);
    await tester.pumpAndSettle();
    await tester.tap(tile);
    await tester.pumpAndSettle();

    expect(find.text('Cargando resultados…'), findsOneWidget);
    expect(find.bySemanticsLabel('Cargando resultados'), findsOneWidget);
    expect(find.text('Actualizar'), findsNothing);

    pending.complete(ranking);
    await tester.pumpAndSettle();
    expect(find.text('Cargando resultados…'), findsNothing);
  });

  testWidgets(
    'shows the podium, the rest of the players and a refresh button',
    (tester) async {
      await openScores(tester, FakeResultsRepository.always(ranking));
      await tester.scrollUntilVisible(
        find.bySemanticsLabel(RegExp('Puesto 5')),
        200,
        scrollable: find.byType(Scrollable).first,
      );

      for (final (rank, text) in [
        (1, 'Puesto 1: memo, 600 puntos, 2 partidas, 100 % de victorias'),
        (2, 'Puesto 2: CarlOso, 500 puntos, 3 partidas, 33 % de victorias'),
        (3, 'Puesto 3: AngelOso, 200 puntos, 3 partidas, 67 % de victorias'),
        (4, 'Puesto 4: celaya, 0 puntos, sin partidas'),
        (5, 'Puesto 5: memo2, −150 puntos, 2 partidas, 0 % de victorias'),
      ]) {
        expect(
          find.bySemanticsLabel(text),
          findsOneWidget,
          reason: 'Puesto $rank',
        );
      }
      expect(find.text('Actualizar'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('a player without games shows a dash instead of a rate', (
    tester,
  ) async {
    await openScores(tester, FakeResultsRepository.always(ranking));
    await tester.scrollUntilVisible(
      find.bySemanticsLabel(RegExp('Puesto 4')),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('Sin partidas · — victorias'), findsOneWidget);
  });

  testWidgets('an empty ranking explains that there are no games yet', (
    tester,
  ) async {
    await openScores(tester, FakeResultsRepository.always(const []));
    expect(find.text('Aún no hay partidas registradas'), findsOneWidget);
    expect(find.text('No se pudieron cargar los resultados'), findsNothing);
  });

  testWidgets('a first failure shows the error and Reintentar recovers it', (
    tester,
  ) async {
    await openScores(
      tester,
      FakeResultsRepository([
        () => throw const ResultsUnavailable('sin red'),
        () => ranking,
      ]),
    );
    expect(find.text('No se pudieron cargar los resultados'), findsOneWidget);
    expect(find.textContaining('Revisa tu conexión'), findsOneWidget);
    expect(find.text('Cargando resultados…'), findsNothing);

    await tester.tap(find.text('Reintentar'));
    await tester.pumpAndSettle();
    expect(find.text('No se pudieron cargar los resultados'), findsNothing);
    expect(find.bySemanticsLabel(RegExp('Puesto 1: memo')), findsOneWidget);
  });

  testWidgets('a malformed answer gets its own message', (tester) async {
    await openScores(
      tester,
      FakeResultsRepository.failing(const ResultsFormatError('mal')),
    );
    expect(find.textContaining('datos que la app no entiende'), findsOneWidget);
    expect(find.textContaining('Revisa tu conexión'), findsNothing);
  });

  testWidgets('a failed refresh keeps the data and warns that it is old', (
    tester,
  ) async {
    await openScores(
      tester,
      FakeResultsRepository([
        () => ranking,
        () => throw const ResultsUnavailable('sin red'),
      ]),
    );
    await tester.scrollUntilVisible(
      find.text('Actualizar'),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.ensureVisible(find.text('Actualizar'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Actualizar'));
    await tester.pumpAndSettle();
    await tester.drag(find.byType(Scrollable).first, const Offset(0, 2000));
    await tester.pumpAndSettle();

    expect(find.text('No se pudo actualizar'), findsOneWidget);
    expect(find.bySemanticsLabel(RegExp('Puesto 1: memo')), findsOneWidget);
    expect(find.text('No se pudieron cargar los resultados'), findsNothing);
  });

  testWidgets('coming back shows the last ranking at once and refreshes', (
    tester,
  ) async {
    final repository = FakeResultsRepository([
      () => ranking,
      () => ranking.take(2).toList(),
    ]);
    await openScores(tester, repository);
    expect(find.bySemanticsLabel(RegExp('Puesto 1: memo')), findsOneWidget);

    await tester.tap(find.byTooltip('Volver'));
    await tester.pumpAndSettle();
    await openChapter(tester, 'Explorar Resultados globales');

    expect(repository.calls, 2, reason: 'vuelve a pedir datos al abrir');
    expect(find.bySemanticsLabel(RegExp('Puesto 1: memo')), findsOneWidget);
    expect(find.text('Cargando resultados…'), findsNothing);
  });

  for (final (name, size, scale) in [
    ('a small screen', const Size(320, 568), 1.0),
    ('text at 180 %', const Size(390, 844), 1.8),
    ('landscape', const Size(844, 390), 1.0),
  ]) {
    testWidgets('fits on $name with long names and large numbers', (
      tester,
    ) async {
      final crowded = [
        testScore(
          'UnNombreDeJugadorMuyLargoQueNoCabe',
          points: 123456,
          games: 50,
          wins: 30,
        ),
        testScore(
          'OtroNombreIgualDeLargoParaProbar',
          points: 99999,
          games: 9,
          wins: 1,
        ),
        testScore('Tercero', points: -1234, games: 1),
        for (var i = 4; i <= 8; i++) testScore('jugador$i', points: 10 * i),
      ];
      await openScores(
        tester,
        FakeResultsRepository.always(crowded),
        size: size,
        textScale: scale,
      );
      expect(tester.takeException(), isNull);
      await tester.drag(find.byType(Scrollable).first, const Offset(0, -3000));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });
  }
}
