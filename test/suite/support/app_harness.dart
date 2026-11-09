import 'package:bearstards_movil_application/app/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

/// Loads the bundled font so text metrics match the device.
Future<void> loadWikiFonts() async {
  final fonts = FontLoader('Vera')
    ..addFont(rootBundle.load('assets/fonts/Vera.ttf'))
    ..addFont(rootBundle.load('assets/fonts/VeraBd.ttf'));
  await fonts.load();
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
