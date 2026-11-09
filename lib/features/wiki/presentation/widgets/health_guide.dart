import 'package:flutter/material.dart';

import '../../../../core/assets/wiki_assets.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/guide_components.dart';
import '../../../../core/widgets/stitched_card.dart';
import '../../../../core/widgets/wiki_artwork.dart';

class HealthGuide extends StatelessWidget {
  const HealthGuide({super.key});
  @override
  Widget build(BuildContext context) => StitchedCard(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const GuideHeading(
          'La vida se lee en el hilo',
          eyebrow: 'El indicador de tu oso',
        ),
        const SizedBox(height: 8),
        const WikiArtwork(
          WikiAssets.health,
          height: 76,
          label: 'Ovillo rojo y hebra de estambre que representa la vida',
        ),
        const SizedBox(height: 8),
        const Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            StatPill('BASE 100'),
            StatPill('CON CASCO 125', color: Palette.cyan),
            StatPill('HILO +25', color: Palette.mint),
          ],
        ),
        const SizedBox(height: 12),
        const Text(
          'La hebra se acorta al recibir daño y se recupera con el hilo. Solo tú ves tu indicador de vida.',
        ),
      ],
    ),
  );
}
