import 'package:flutter/material.dart';

import '../../../../app/navigation/wiki_routes.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/guide_components.dart';
import '../../../../core/widgets/stitched_card.dart';
import '../../../../core/widgets/wiki_artwork.dart';
import '../../domain/repositories/wiki_repository.dart';
import '../view_models/stealth_view_model.dart';
import '../wiki_presentation.dart';
import '../widgets/guide_scaffold.dart';

class StealthScreen extends StatefulWidget {
  const StealthScreen({super.key, required this.repository});
  final WikiRepository repository;
  @override
  State<StealthScreen> createState() => _StealthScreenState();
}

class _StealthScreenState extends State<StealthScreen> {
  late final model = StealthViewModel(widget.repository);
  @override
  void dispose() {
    model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: model,
    builder: (context, _) {
      final selected = model.selected;
      return GuideScaffold(
        title: 'Sigilo',
        section: WikiSection.stealth,
        children: [
          const StitchedCard(
            child: GuideHeading(
              'Mezclarse es sobrevivir.',
              eyebrow: 'Lee las señales',
              subtitle: 'Camina como los NPC. El rival observa tus acciones, no una etiqueta sobre tu oso.',
            ),
          ),
          Text(
            '¿Qué te delata?',
            style: Theme.of(context).textTheme.titleLarge!
                .copyWith(color: Palette.paper),
          ),
          LayoutBuilder(
            builder: (context, constraints) {
              final scale = MediaQuery.textScalerOf(context).scale(1);
              return GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                mainAxisSpacing: 14,
                crossAxisSpacing: 12,
                childAspectRatio: scale > 1.3 ? .7 : .86,
                children: [
                  for (final action in model.actions)
                    StitchedCard(
                      padding: const EdgeInsets.all(12),
                      color: action.discreet ? Palette.mint : Palette.pink,
                      selected: action.id == selected.id,
                      semanticLabel: action.label,
                      onTap: () => model.select(action.id),
                      child: Column(
                        children: [
                          Align(
                            alignment: Alignment.centerRight,
                            child: Icon(
                              action.discreet
                                  ? Icons.check_circle_rounded
                                  : Icons.error_rounded,
                              size: 19,
                            ),
                          ),
                          Expanded(
                            child: WikiArtwork(
                              WikiPresentation.actionArtwork(action.id),
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            action.label,
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.titleMedium!
                                .copyWith(fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                ],
              );
            },
          ),
          GuideCallout(
            title: selected.discreet ? 'Acción discreta' : 'Acción delatora',
            body: selected.description,
            color: selected.discreet ? Palette.mint : Palette.pink,
            icon: selected.discreet
                ? Icons.visibility_off_outlined
                : Icons.priority_high_rounded,
          ),
          const GuideCallout(
            title: 'La regla del sigilo',
            body: 'Correr, saltar o mostrar un arma revela pistas. Las estanterías bloquean la vista: observa antes de salir al pasillo.',
            color: Palette.cyan,
            icon: Icons.remove_red_eye_outlined,
          ),
        ],
      );
    },
  );
}
