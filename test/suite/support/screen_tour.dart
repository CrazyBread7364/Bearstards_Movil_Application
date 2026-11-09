import 'package:bearstards_movil_application/app/navigation/wiki_routes.dart';
import 'package:bearstards_movil_application/features/wiki/domain/models/wiki_entry.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Opens every chapter and every entry, scrolls each one to the end and fails
/// on the first layout exception (overflow, unbounded size, and so on).
Future<void> tourEveryScreen(WidgetTester tester) async {
  expect(tester.takeException(), isNull, reason: 'Portada');
  final navigator = tester.state<NavigatorState>(find.byType(Navigator));

  Future<void> checkAndScroll(String screen) async {
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull, reason: 'Diseño inicial: $screen');
    await tester.drag(find.byType(Scrollable).first, const Offset(0, -2000));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull, reason: 'Con scroll: $screen');
  }

  for (final route in [
    WikiRoutes.characters,
    WikiRoutes.stealth,
    WikiRoutes.objects,
    WikiRoutes.arsenal,
    WikiRoutes.map,
  ]) {
    navigator.pushNamed(route);
    await checkAndScroll(route);
    navigator.pop();
    await tester.pumpAndSettle();
  }
  for (final id in EntryId.values) {
    navigator.pushNamed(WikiRoutes.detail, arguments: id);
    await checkAndScroll('detalle ${id.name}');
    navigator.pop();
    await tester.pumpAndSettle();
  }
}
