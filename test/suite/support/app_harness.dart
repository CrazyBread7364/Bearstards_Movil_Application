import 'package:bearstards_movil_application/app/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

/// Loads the bundled fonts so text metrics match the device.
Future<void> loadWikiFonts() async {
  for (final (family, assets) in [
    ('Vera', ['assets/fonts/Vera.ttf', 'assets/fonts/VeraBd.ttf']),
    ('LilitaOne', ['assets/fonts/LilitaOne-Regular.ttf']),
    ('Fredoka', ['assets/fonts/Fredoka.ttf']),
  ]) {
    final loader = FontLoader(family);
    for (final asset in assets) {
      loader.addFont(rootBundle.load(asset));
    }
    await loader.load();
  }
}

/// Starts the real app on the home screen with the given screen and text scale.
Future<void> launchApp(
  WidgetTester tester, {
  Size size = const Size(390, 844),
  double textScale = 1,
}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  await tester.pumpWidget(
    MediaQuery(
      data: MediaQueryData(
        size: size,
        textScaler: TextScaler.linear(textScale),
      ),
      child: const BearstardsWikiApp(),
    ),
  );
  await tester.pumpAndSettle();
}
