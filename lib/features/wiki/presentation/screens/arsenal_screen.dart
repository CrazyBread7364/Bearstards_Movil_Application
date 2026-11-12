import 'package:flutter/material.dart';

import '../../../../app/navigation/wiki_routes.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/guide_components.dart';
import '../../../../core/widgets/stitched_card.dart';
import '../../domain/models/wiki_entry.dart';
import '../../domain/repositories/wiki_repository.dart';
import '../widgets/entry_card.dart';
import '../widgets/guide_scaffold.dart';

class ArsenalScreen extends StatelessWidget {
  const ArsenalScreen({super.key, required this.repository});
  final WikiRepository repository;
  @override
  Widget build(BuildContext context) => GuideScaffold(
    title: 'Arsenal',
    section: WikiSection.arsenal,
    children: [
      const GuideHeading(
        'Dos armas.\nDos formas de actuar.',
        eyebrow: 'Conoce tu equipo',
        light: true,
      ),
      for (final entry in repository.entriesFor(EntryCategory.weapons))
        EntryCard(entry: entry),
      StitchedCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const GuideHeading('Cada objetivo cuenta', eyebrow: 'Puntuación'),
            const SizedBox(height: 10),
            for (final pair in const [
              (
                ScoreTile(
                  value: '+200',
                  label: 'Rival con aguja',
                  color: Palette.yellow,
                ),
                ScoreTile(
                  value: '+350',
                  label: 'Rival con aguja y sigilo',
                  color: Palette.mint,
                ),
              ),
              (
                ScoreTile(
                  value: '+400',
                  label: 'Rival con dardos',
                  color: Palette.cyan,
                ),
                ScoreTile(value: '−50', label: 'Oso NPC', color: Palette.pink),
              ),
            ])
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                // Two tiles per row, as tall as the taller one.
                child: IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(child: pair.$1),
                      const SizedBox(width: 12),
                      Expanded(child: pair.$2),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    ],
  );
}
