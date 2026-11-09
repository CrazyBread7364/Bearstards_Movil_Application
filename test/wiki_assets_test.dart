import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bearstards_movil_application/core/assets/wiki_assets.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  test('all active illustrations are bundled and non-empty', () async {
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
      expect(
        (await rootBundle.load(asset)).lengthInBytes,
        greaterThan(0),
        reason: asset,
      );
    }
    final manifest = await AssetManifest.loadFromAssetBundle(rootBundle);
    expect(
      manifest.listAssets().where(
        (path) => path.startsWith('assets/images/mvp/'),
      ),
      isEmpty,
    );
  });
}
