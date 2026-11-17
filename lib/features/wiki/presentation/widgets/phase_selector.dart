import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/guide_components.dart';
import '../../../../core/widgets/stitched_card.dart';
import '../../../../core/widgets/wiki_artwork.dart';
import '../../domain/repositories/wiki_repository.dart';
import '../../domain/models/match_phase.dart';
import '../view_models/phases_view_model.dart';
import '../wiki_presentation.dart';

class PhaseSelector extends StatefulWidget {
  const PhaseSelector({super.key, required this.repository});
  final WikiRepository repository;
  @override
  State<PhaseSelector> createState() => _PhaseSelectorState();
}

class _PhaseSelectorState extends State<PhaseSelector> {
  late final model = PhasesViewModel(widget.repository);
  @override
  void dispose() {
    model.dispose();
    super.dispose();
  }

  Widget _semanticTile(int i, PhaseId selected, {bool horizontal = false}) {
    final phase = model.phases[i];
    return Semantics(
      label: 'Fase ${i + 1}: ${phase.title}',
      button: true,
      selected: phase.id == selected,
      excludeSemantics: true,
      child: _PhaseTile(
        number: i + 1,
        title: phase.title,
        artwork: WikiPresentation.phaseArtwork(phase.id),
        color: WikiPresentation.phaseColor(phase.id),
        selected: phase.id == selected,
        horizontal: horizontal,
        onTap: () => model.select(phase.id),
      ),
    );
  }

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: model,
    builder: (context, _) {
      final phase = model.selected;
      final accent = WikiPresentation.phaseColor(phase.id);
      return StitchedCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const GuideHeading(
              'El ritmo de la tienda',
              eyebrow: 'Tres fases de igual duración',
            ),
            const SizedBox(height: 16),
            // Large text does not fit three columns: stack the tiles instead.
            if (MediaQuery.textScalerOf(context).scale(1) > 1.3)
              Column(
                children: [
                  for (var i = 0; i < model.phases.length; i++)
                    Padding(
                      padding: EdgeInsets.only(bottom: i < 2 ? 10 : 0),
                      child: _semanticTile(i, phase.id, horizontal: true),
                    ),
                ],
              )
            else
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (var i = 0; i < model.phases.length; i++)
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(right: i < 2 ? 6 : 0),
                        child: _semanticTile(i, phase.id),
                      ),
                    ),
                ],
              ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Color.alphaBlend(
                  accent.withValues(alpha: .28),
                  Palette.paper,
                ),
                border: Border.all(color: Palette.ink, width: 2.5),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  StatPill(phase.period, color: accent),
                  const SizedBox(height: 10),
                  Text(phase.description),
                  const SizedBox(height: 8),
                  Text(
                    phase.advice,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    },
  );
}

/// One phase button: a toon tile that turns solid when selected.
class _PhaseTile extends StatelessWidget {
  const _PhaseTile({
    required this.number,
    required this.title,
    required this.artwork,
    required this.color,
    required this.selected,
    required this.onTap,
    this.horizontal = false,
  });
  final bool horizontal;
  final int number;
  final String title, artwork;
  final Color color;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(14),
      boxShadow: [
        BoxShadow(
          color: Palette.ink,
          offset: selected ? const Offset(3, 4) : const Offset(2, 2),
        ),
      ],
    ),
    child: Material(
      color: selected ? color : Palette.cream,
      shape: RoundedRectangleBorder(
        side: const BorderSide(color: Palette.ink, width: 2.5),
        borderRadius: BorderRadius.circular(14),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
          child: horizontal
              ? Row(
                  children: [
                    _badge(context),
                    const SizedBox(width: 10),
                    SizedBox(
                      width: 64,
                      child: WikiArtwork(artwork, height: 44),
                    ),
                    const SizedBox(width: 12),
                    Expanded(child: _title(context, TextAlign.start)),
                  ],
                )
              : Column(
                  children: [
                    _badge(context),
                    const SizedBox(height: 6),
                    WikiArtwork(artwork, height: 60),
                    const SizedBox(height: 7),
                    _title(context, TextAlign.center),
                  ],
                ),
        ),
      ),
    ),
  );

  Widget _badge(BuildContext context) => Container(
    width: 28,
    height: 28,
    alignment: Alignment.center,
    decoration: BoxDecoration(
      color: Palette.paper,
      shape: BoxShape.circle,
      border: Border.all(color: Palette.ink, width: 2),
    ),
    child: Text(
      '$number',
      style: Theme.of(context).textTheme.titleLarge!
          .copyWith(fontSize: 15, height: 1),
    ),
  );

  Widget _title(BuildContext context, TextAlign align) => Text(
    title,
    textAlign: align,
    style: Theme.of(context).textTheme.titleMedium!
        .copyWith(fontSize: 12, height: 1.15),
  );
}
