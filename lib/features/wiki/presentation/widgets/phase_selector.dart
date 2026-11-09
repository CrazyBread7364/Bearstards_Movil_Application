import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/guide_components.dart';
import '../../../../core/widgets/stitched_card.dart';
import '../../../../core/widgets/wiki_artwork.dart';
import '../../domain/repositories/wiki_repository.dart';
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
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (var i = 0; i < model.phases.length; i++)
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(right: i < 2 ? 6 : 0),
                      child: Semantics(
                        label: 'Fase ${i + 1}: ${model.phases[i].title}',
                        button: true,
                        selected: model.phases[i].id == phase.id,
                        excludeSemantics: true,
                        child: Material(
                          color: model.phases[i].id == phase.id
                              ? accent.withValues(alpha: .3)
                              : Palette.cream,
                          borderRadius: BorderRadius.circular(12),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(12),
                            onTap: () => model.select(model.phases[i].id),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 10,
                                horizontal: 5,
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    '0${i + 1}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelSmall,
                                  ),
                                  const SizedBox(height: 5),
                                  WikiArtwork(
                                    WikiPresentation.phaseArtwork(
                                      model.phases[i].id,
                                    ),
                                    height: 64,
                                  ),
                                  const SizedBox(height: 7),
                                  Text(
                                    model.phases[i].title,
                                    textAlign: TextAlign.center,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall!
                                        .copyWith(
                                          color: Palette.ink,
                                          fontWeight: FontWeight.w700,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            StatPill(phase.period, color: accent),
            const SizedBox(height: 10),
            Text(phase.description),
            const SizedBox(height: 8),
            Text(phase.advice, style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
      );
    },
  );
}
