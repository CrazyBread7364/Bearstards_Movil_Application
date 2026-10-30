import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bearstards_movil_application/app/app.dart';
import 'package:bearstards_movil_application/app/navigation/wiki_routes.dart';
import 'package:bearstards_movil_application/features/wiki/domain/models/wiki_entry.dart';
import 'package:bearstards_movil_application/features/wiki/presentation/screens/characters_screen.dart';
import 'package:bearstards_movil_application/features/wiki/presentation/screens/entry_detail_screen.dart';
import 'package:bearstards_movil_application/features/wiki/presentation/screens/stealth_screen.dart';

Future<void> launch(
  WidgetTester tester, {
  Size size = const Size(390, 844),
  double scale = 1,
}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  await tester.pumpWidget(
    MediaQuery(
      data: MediaQueryData(size: size, textScaler: TextScaler.linear(scale)),
      child: const BearstardsWikiApp(),
    ),
  );
  await tester.pumpAndSettle();
  expect(
    MediaQuery.textScalerOf(tester.element(find.byType(Navigator))).scale(1),
    scale,
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(() async {
    final fonts = FontLoader('Vera')
      ..addFont(rootBundle.load('assets/fonts/Vera.ttf'))
      ..addFont(rootBundle.load('assets/fonts/VeraBd.ttf'));
    await fonts.load();
  });
  testWidgets('Personajes has its own route and does not open Sigilo', (
    tester,
  ) async {
    await launch(tester);
    await tester.tap(find.bySemanticsLabel('Explorar Personajes'));
    await tester.pumpAndSettle();
    expect(find.byType(CharactersScreen), findsOneWidget);
    expect(find.byType(StealthScreen), findsNothing);
    await tester.tap(find.byTooltip('Volver'));
    await tester.pumpAndSettle();
    expect(find.bySemanticsLabel('Explorar Arsenal'), findsOneWidget);
  });

  testWidgets('arsenal opens typed detail and back preserves the guide', (
    tester,
  ) async {
    await launch(tester);
    await tester.tap(find.bySemanticsLabel('Explorar Arsenal'));
    await tester.pumpAndSettle();
    await tester.tap(find.bySemanticsLabel('Consultar Aguja de coser'));
    await tester.pumpAndSettle();
    expect(
      tester.widget<EntryDetailScreen>(find.byType(EntryDetailScreen)).entry.id,
      EntryId.needle,
    );
    expect(find.textContaining('25 puntos de vida'), findsOneWidget);
    await tester.tap(find.byTooltip('Volver'));
    await tester.pumpAndSettle();
    expect(find.text('Dos armas.\nDos formas de actuar.'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('stealth selection explains the action; active tab keeps it', (
    tester,
  ) async {
    await launch(tester);
    await tester.tap(find.bySemanticsLabel('Explorar Sigilo'));
    await tester.pumpAndSettle();
    await tester.tap(find.bySemanticsLabel('Correr te delata'));
    await tester.pumpAndSettle();
    await tester.tap(find.bySemanticsLabel('Ir a Sigilo'));
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.text('Acción delatora'),
      180,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.textContaining('movimiento apresurado'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'all phases expose their actual change, without fixed 15-minute intervals',
    (tester) async {
      await launch(tester);
      await tester.tap(find.bySemanticsLabel('Explorar La Juguetería'));
      await tester.pumpAndSettle();
      await tester.scrollUntilVisible(
        find.bySemanticsLabel('Fase 2: Mercancía nueva'),
        180,
      );
      await tester.tap(find.bySemanticsLabel('Fase 2: Mercancía nueva'));
      await tester.pumpAndSettle();
      expect(find.text('Segundo tercio'), findsOneWidget);
      expect(find.textContaining('Aparece una sola vez'), findsOneWidget);
      await tester.tap(find.bySemanticsLabel('Fase 3: Remate final'));
      await tester.pumpAndSettle();
      expect(find.textContaining('La mitad de los NPC'), findsOneWidget);
      expect(find.text('10–15 min'), findsNothing);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'objects accessible through bottom navigation and both details open',
    (tester) async {
      await launch(tester);
      await tester.tap(find.bySemanticsLabel('Explorar Sigilo'));
      await tester.pumpAndSettle();
      await tester.tap(find.bySemanticsLabel('Ir a Objetos'));
      await tester.pumpAndSettle();
      for (final title in ['Casco', 'Rollo de hilo']) {
        await tester.scrollUntilVisible(
          find.bySemanticsLabel('Consultar $title'),
          180,
        );
        await tester.tap(find.bySemanticsLabel('Consultar $title'));
        await tester.pumpAndSettle();
        expect(find.byType(EntryDetailScreen), findsOneWidget);
        expect(find.text(title), findsOneWidget);
        await tester.tap(find.byTooltip('Volver'));
        await tester.pumpAndSettle();
      }
      await tester.tap(find.bySemanticsLabel('Ir a Inicio'));
      await tester.pumpAndSettle();
      expect(find.bySemanticsLabel('Explorar Personajes'), findsOneWidget);
    },
  );

  for (final (width, height, scale) in [
    (320.0, 568.0, 1.0),
    (390.0, 844.0, 1.8),
    (844.0, 390.0, 1.0),
  ]) {
    testWidgets('mobile layouts fit ${width}x$height at text scale $scale', (
      tester,
    ) async {
      await launch(tester, size: Size(width, height), scale: scale);
      expect(tester.takeException(), isNull);
      final navigator = tester.state<NavigatorState>(find.byType(Navigator));
      for (final route in [
        WikiRoutes.characters,
        WikiRoutes.stealth,
        WikiRoutes.objects,
        WikiRoutes.arsenal,
        WikiRoutes.map,
      ]) {
        navigator.pushNamed(route);
        await tester.pumpAndSettle();
        expect(
          tester.takeException(),
          isNull,
          reason: 'Initial layout: $route',
        );
        final scrollable = find.byType(Scrollable).first;
        await tester.drag(scrollable, const Offset(0, -2000));
        await tester.pumpAndSettle();
        expect(
          tester.takeException(),
          isNull,
          reason: 'Scrolled layout: $route',
        );
        navigator.pop();
        await tester.pumpAndSettle();
      }
      for (final id in EntryId.values) {
        navigator.pushNamed(WikiRoutes.detail, arguments: id);
        await tester.pumpAndSettle();
        await tester.drag(
          find.byType(Scrollable).first,
          const Offset(0, -2000),
        );
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull, reason: 'Entry detail: $id');
        navigator.pop();
        await tester.pumpAndSettle();
      }
    });
  }
}
