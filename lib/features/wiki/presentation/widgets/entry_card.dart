import 'package:flutter/material.dart';

import '../../../../app/navigation/wiki_routes.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/guide_components.dart';
import '../../../../core/widgets/stitched_card.dart';
import '../../../../core/widgets/wiki_artwork.dart';
import '../../domain/models/wiki_entry.dart';
import '../wiki_presentation.dart';

class EntryCard extends StatelessWidget {
  const EntryCard({super.key, required this.entry, this.compact = false});
  final WikiEntry entry;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final accent = WikiPresentation.color(entry.id);
    final details = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                entry.title,
                style: compact
                    ? Theme.of(context).textTheme.titleLarge
                    : Theme.of(context).textTheme.headlineSmall,
              ),
            ),
            const SizedBox(width: 5),
            Icon(Icons.arrow_outward_rounded, size: 20, color: Palette.ink),
          ],
        ),
        const SizedBox(height: 7),
        Text(entry.summary, style: Theme.of(context).textTheme.bodySmall),
        const SizedBox(height: 12),
        Wrap(
          spacing: 7,
          runSpacing: 7,
          children: [
            for (final stat in entry.stats)
              StatPill(
                '${stat.label} ${stat.value.toUpperCase()}',
                color: accent.withValues(alpha: .25),
              ),
          ],
        ),
      ],
    );
    return StitchedCard(
      semanticLabel: 'Consultar ${entry.title}',
      onTap: () =>
          Navigator.pushNamed(context, WikiRoutes.detail, arguments: entry.id),
      padding: const EdgeInsets.all(14),
      child: LayoutBuilder(
        builder: (context, constraints) {
          if (compact &&
              constraints.maxWidth >= 290 &&
              MediaQuery.textScalerOf(context).scale(1) <= 1.2) {
            return Row(
              children: [
                SizedBox(
                  width: 108,
                  child: WikiArtwork(
                    WikiPresentation.artwork(entry.id),
                    height: 128,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(child: details),
              ],
            );
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ArtworkStage(
                asset: WikiPresentation.artwork(entry.id),
                color: accent,
                height: compact ? 120 : 165,
              ),
              const SizedBox(height: 14),
              details,
            ],
          );
        },
      ),
    );
  }
}
