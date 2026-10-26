import 'package:flutter/material.dart';

import '../../../../app/navigation/wiki_routes.dart';
import '../../../../core/assets/wiki_assets.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/guide_components.dart';
import '../../../../core/widgets/stitched_card.dart';
import '../../../../core/widgets/wiki_artwork.dart';
import '../../domain/repositories/wiki_repository.dart';
import '../widgets/guide_scaffold.dart';
import '../widgets/phase_selector.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({super.key, required this.repository});
  final WikiRepository repository;
  @override
  Widget build(BuildContext context) => GuideScaffold(
    title: 'La Juguetería',
    section: WikiSection.map,
    children: [
      StitchedCard(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: const WikiArtwork(
                WikiAssets.map,
                height: 210,
                label: 'Vista ilustrada de La Juguetería con tres pasillos',
              ),
            ),
            const SizedBox(height: 14),
            const GuideHeading(
              'Tres pasillos.\nNinguna mirada sobra.',
              eyebrow: 'El escenario',
            ),
            const SizedBox(height: 10),
            const Text(
              'Las estanterías bloquean la visión y crean rutas de encuentro y escape entre los osos.',
            ),
            const SizedBox(height: 12),
            const Wrap(
              spacing: 7,
              runSpacing: 7,
              children: [
                StatPill('3 PASILLOS', color: Palette.lavender),
                StatPill('COBERTURA', color: Palette.mint),
              ],
            ),
          ],
        ),
      ),
      PhaseSelector(repository: repository),
      const GuideCallout(
        title: 'Cuando se acaba el tiempo',
        body: 'Gana quien tiene más puntos. Si hay empate, se comparan las eliminaciones del rival; si continúa, la partida queda empatada.',
        color: Palette.yellow,
        icon: Icons.emoji_events_outlined,
      ),
    ],
  );
}
