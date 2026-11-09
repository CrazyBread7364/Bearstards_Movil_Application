import 'package:flutter/material.dart';

import '../../../../core/assets/wiki_assets.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/guide_components.dart';
import '../../../../core/widgets/stitched_card.dart';
import '../../../../core/widgets/wiki_artwork.dart';

class IdentityComparison extends StatelessWidget {
  const IdentityComparison({super.key});
  @override
  Widget build(BuildContext context) => StitchedCard(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const GuideHeading(
          'Misma apariencia.\nDistintas intenciones.',
          eyebrow: 'Jugador / NPC',
          subtitle: 'Tu rival también es un oso. Son sus acciones las que lo distinguen.',
        ),
        const SizedBox(height: 12),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                children: const [
                  WikiArtwork(WikiAssets.player, height: 140),
                  SizedBox(height: 9),
                  StatPill('JUGADOR', color: Palette.pink),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                children: const [
                  WikiArtwork(WikiAssets.npc, height: 140),
                  SizedBox(height: 9),
                  StatPill('NPC', color: Palette.cyan),
                ],
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
