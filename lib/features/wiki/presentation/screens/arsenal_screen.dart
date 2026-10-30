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
            for (final (label, points) in const [
              ('Rival con aguja', '+200'),
              ('Rival con aguja y sigilo', '+350'),
              ('Rival con dardos', '+400'),
              ('Oso NPC', '−50'),
            ])
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 7),
                child: Row(
                  children: [
                    Expanded(child: Text(label)),
                    StatPill(
                      points,
                      color: points.startsWith('−')
                          ? Palette.pink
                          : Palette.mint,
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    ],
  );
}
