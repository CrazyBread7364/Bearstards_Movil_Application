// Run explicitly to regenerate review images from real Flutter widgets:
// flutter test test/visual_preview_test.dart --dart-define=GENERATE_PREVIEWS=true
import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bearstards_movil_application/app/app.dart';
import 'package:bearstards_movil_application/app/navigation/wiki_routes.dart';
import 'package:bearstards_movil_application/core/assets/wiki_assets.dart';
import 'package:bearstards_movil_application/features/wiki/domain/models/wiki_entry.dart';

void main() {
  testWidgets('render mobile review images', (tester) async {
    tester.view.physicalSize = const Size(780, 1688);
    tester.view.devicePixelRatio = 2;
    tester.view.padding = const FakeViewPadding(top: 88, bottom: 68);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPadding);
    final regular = FontLoader('Vera')
      ..addFont(rootBundle.load('assets/fonts/Vera.ttf'));
    final bold = FontLoader('Vera')
      ..addFont(rootBundle.load('assets/fonts/VeraBd.ttf'));
    await regular.load();
    await bold.load();
    final icons = FontLoader('MaterialIcons')
      ..addFont(rootBundle.load('fonts/MaterialIcons-Regular.otf'));
    await icons.load();
    final boundaryKey = GlobalKey();
    await tester.pumpWidget(
      RepaintBoundary(key: boundaryKey, child: const BearstardsWikiApp()),
    );
    await tester.runAsync(() async {
      final context = tester.element(find.byType(BearstardsWikiApp));
      for (final asset in [
        WikiAssets.background,
        WikiAssets.heroBear,
        WikiAssets.crates,
        WikiAssets.sign,
        WikiAssets.homeCharacters,
        WikiAssets.homeStealth,
        WikiAssets.player,
        WikiAssets.npc,
        WikiAssets.needle,
        WikiAssets.dartBlaster,
        WikiAssets.helmet,
        WikiAssets.thread,
        WikiAssets.health,
        WikiAssets.map,
        WikiAssets.lightsOff,
        WikiAssets.newStock,
        WikiAssets.finalSale,
        WikiAssets.walk,
        WikiAssets.run,
        WikiAssets.jump,
        WikiAssets.weapon,
      ]) {
        await precacheImage(AssetImage(asset), context);
      }
    });
    await tester.pumpAndSettle();

    Future<void> capture(String name) async {
      await tester.pumpAndSettle();
      await tester.runAsync(() async {
        for (
          var attempt = 0;
          attempt < 150 && imageCache.pendingImageCount > 0;
          attempt++
        ) {
          await Future<void>.delayed(const Duration(milliseconds: 20));
        }
      });
      await tester.pumpAndSettle();
      expect(imageCache.pendingImageCount, 0, reason: 'Image decoding: $name');
      final boundary =
          boundaryKey.currentContext!.findRenderObject()!
              as RenderRepaintBoundary;
      await tester.runAsync(() async {
        final image = await boundary.toImage(pixelRatio: 2);
        final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
        final file = File('designs/previews/$name.png');
        await file.parent.create(recursive: true);
        await file.writeAsBytes(bytes!.buffer.asUint8List());
        image.dispose();
      });
      expect(tester.takeException(), isNull, reason: name);
    }

    await capture('01-home');
    final navigator = tester.state<NavigatorState>(find.byType(Navigator));
    for (final (route, name) in [
      (WikiRoutes.characters, '02-personajes'),
      (WikiRoutes.stealth, '03-sigilo'),
      (WikiRoutes.objects, '04-objetos'),
      (WikiRoutes.arsenal, '05-arsenal'),
      (WikiRoutes.map, '06-mapa'),
    ]) {
      navigator.pushNamed(route);
      await tester.pumpAndSettle();
      await capture(name);
      if (route == WikiRoutes.map) {
        await tester.drag(find.byType(Scrollable).first, const Offset(0, -330));
        await tester.pumpAndSettle();
        await capture('07-fases');
      }
      navigator.pop();
      await tester.pumpAndSettle();
    }
    for (final id in EntryId.values) {
      navigator.pushNamed(WikiRoutes.detail, arguments: id);
      await tester.pumpAndSettle();
      await capture('detail-${id.name}');
      navigator.pop();
      await tester.pumpAndSettle();
    }
  }, skip: !const bool.fromEnvironment('GENERATE_PREVIEWS'));
}
