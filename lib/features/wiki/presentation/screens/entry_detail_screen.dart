import 'package:flutter/material.dart';

import '../../../../app/navigation/wiki_routes.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/guide_components.dart';
import '../../../../core/widgets/stitched_card.dart';
import '../../../../core/widgets/wiki_artwork.dart';
import '../../domain/models/wiki_entry.dart';
import '../wiki_presentation.dart';
import '../widgets/guide_scaffold.dart';

class EntryDetailScreen extends StatelessWidget {
  const EntryDetailScreen({super.key, required this.entry});
  final WikiEntry entry;
  @override
  Widget build(BuildContext context) {
    final weapon = entry.category == EntryCategory.weapons;
    final accent = WikiPresentation.color(entry.id);
    return GuideScaffold(
      title: weapon ? 'Arsenal' : 'Objetos',
      section: weapon ? WikiSection.arsenal : WikiSection.objects,
      showNavigation: false,
      children: [
        StitchedCard(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ArtworkStage(
                asset: WikiPresentation.artwork(entry.id),
                color: accent,
                height: 190,
                label: entry.title,
              ),
              const SizedBox(height: 18),
              StatPill(weapon ? 'ARMA' : 'OBJETO', color: accent),
              const SizedBox(height: 12),
              Text(
                entry.title,
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              const SizedBox(height: 8),
              Text(entry.summary, style: Theme.of(context).textTheme.bodySmall),
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final stat in entry.stats)
                    StatPill(
                      '${stat.label} ${stat.value}',
                      color: accent.withValues(alpha: .22),
                    ),
                ],
              ),
            ],
          ),
        ),
        StitchedCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const GuideHeading('Lo que necesitas saber'),
              const SizedBox(height: 12),
              Text(entry.description),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Divider(),
              ),
              for (final rule in entry.rules) GuideRule(rule, color: accent),
            ],
          ),
        ),
        GuideCallout(
          title: 'Antes de actuar',
          body: entry.tip,
          color: Palette.yellow,
          icon: Icons.lightbulb_outline_rounded,
        ),
      ],
    );
  }
}
