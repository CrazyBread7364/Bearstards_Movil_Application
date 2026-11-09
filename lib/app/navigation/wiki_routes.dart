import 'package:flutter/material.dart';

enum WikiSection { home, characters, stealth, objects, arsenal, map }

abstract final class WikiRoutes {
  static const home = '/';
  static const characters = '/characters';
  static const stealth = '/stealth';
  static const objects = '/objects';
  static const arsenal = '/arsenal';
  static const map = '/map';
  static const detail = '/entry';

  static String forSection(WikiSection section) => switch (section) {
    WikiSection.home => home,
    WikiSection.characters => characters,
    WikiSection.stealth => stealth,
    WikiSection.objects => objects,
    WikiSection.arsenal => arsenal,
    WikiSection.map => map,
  };

  static void select(
    BuildContext context,
    WikiSection section,
    WikiSection current,
  ) {
    if (section == current) return;
    if (section == WikiSection.home) {
      Navigator.popUntil(context, (route) => route.isFirst);
    } else {
      Navigator.pushReplacementNamed(context, forSection(section));
    }
  }
}
