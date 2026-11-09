import 'package:bearstards_movil_application/core/assets/wiki_assets.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import 'cases.dart';
import 'test_case.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  suiteTest(tc12, () async {
    const illustrations = [
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
    ];
    expect(illustrations, hasLength(21));

    for (final asset in illustrations) {
      final data = await rootBundle.load(asset);
      expect(data.lengthInBytes, greaterThan(0), reason: asset);
    }

    final manifest = await AssetManifest.loadFromAssetBundle(rootBundle);
    final unused = manifest.listAssets().where(
      (path) => path.startsWith('assets/images/mvp/'),
    );
    expect(unused, isEmpty);
  });
}
