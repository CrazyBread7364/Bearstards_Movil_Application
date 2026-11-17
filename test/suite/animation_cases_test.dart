import 'package:bearstards_movil_application/app/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'cases.dart';
import 'support/app_harness.dart';
import 'test_case.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(loadWikiFonts);

  /// Starts the app on a phone-sized screen without settling: the text ribbon
  /// moves forever, so these cases advance time by hand.
  Future<void> startHome(WidgetTester tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(const BearstardsWikiApp());
    await tester.pump(const Duration(milliseconds: 500));
  }

  suiteWidgetTest(tc19, (tester) async {
    await startHome(tester);

    final pause = find.bySemanticsLabel('Pausar la cinta de texto');
    expect(pause, findsOneWidget);
    await tester.tap(pause);
    await tester.pump(const Duration(milliseconds: 500));
    expect(find.bySemanticsLabel('Pausar la cinta de texto'), findsNothing);

    final resume = find.bySemanticsLabel('Reanudar la cinta de texto');
    expect(resume, findsOneWidget);
    await tester.tap(resume);
    await tester.pump(const Duration(milliseconds: 500));
    expect(find.bySemanticsLabel('Pausar la cinta de texto'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  suiteWidgetTest(tc20, (tester) async {
    tester.platformDispatcher.accessibilityFeaturesTestValue =
        const FakeAccessibilityFeatures(disableAnimations: true);
    addTearDown(tester.platformDispatcher.clearAccessibilityFeaturesTestValue);
    await startHome(tester);
    await tester.pump(const Duration(seconds: 5));

    expect(find.bySemanticsLabel('Pausar la cinta de texto'), findsNothing);
    expect(find.bySemanticsLabel('Reanudar la cinta de texto'), findsNothing);
    expect(tester.takeException(), isNull);
  });
}
