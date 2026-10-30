import 'package:flutter/material.dart';

import '../../../core/assets/wiki_assets.dart';
import '../../../core/theme/app_theme.dart';
import '../domain/models/match_phase.dart';
import '../domain/models/stealth_action.dart';
import '../domain/models/wiki_entry.dart';

/// Exhaustive mappings keep display details outside reference content.
abstract final class WikiPresentation {
  static String artwork(EntryId id) => switch (id) {
    EntryId.needle => WikiAssets.needle,
    EntryId.dartBlaster => WikiAssets.dartBlaster,
    EntryId.helmet => WikiAssets.helmet,
    EntryId.threadSpool => WikiAssets.thread,
  };
  static Color color(EntryId id) => switch (id) {
    EntryId.needle => Palette.pink,
    EntryId.dartBlaster => Palette.yellow,
    EntryId.helmet => Palette.blue,
    EntryId.threadSpool => Palette.mint,
  };
  static String actionArtwork(StealthActionId id) => switch (id) {
    StealthActionId.walk => WikiAssets.walk,
    StealthActionId.run => WikiAssets.run,
    StealthActionId.jump => WikiAssets.jump,
    StealthActionId.weapon => WikiAssets.weapon,
  };
  static String phaseArtwork(PhaseId id) => switch (id) {
    PhaseId.lightsOff => WikiAssets.lightsOff,
    PhaseId.newStock => WikiAssets.newStock,
    PhaseId.finalSale => WikiAssets.finalSale,
  };
  static Color phaseColor(PhaseId id) => switch (id) {
    PhaseId.lightsOff => Palette.blue,
    PhaseId.newStock => Palette.yellow,
    PhaseId.finalSale => Palette.pink,
  };
}
