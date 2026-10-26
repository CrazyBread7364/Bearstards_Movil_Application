import 'package:flutter/material.dart';

import '../../../../app/navigation/wiki_routes.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/guide_components.dart';
import '../../../../core/widgets/stitched_card.dart';
import '../widgets/guide_scaffold.dart';
import '../widgets/identity_comparison.dart';

class CharactersScreen extends StatelessWidget {
  const CharactersScreen({super.key});
  @override
  Widget build(BuildContext context) => GuideScaffold(
    title: 'Personajes',
    section: WikiSection.characters,
    children: [
      const IdentityComparison(),
      const GuideCallout(
        title: 'El jugador',
        body: 'Dos jugadores se enfrentan entre osos casi idénticos. Identifica al rival sin revelar tu propia identidad.',
        icon: Icons.person_outline_rounded,
        color: Palette.pink,
      ),
      const GuideCallout(
        title: 'Los osos NPC',
        body: 'Recorren La Juguetería sin armas. Su rutina te ayuda a camuflarte; atacar a uno resta 50 puntos.',
        icon: Icons.groups_outlined,
        color: Palette.cyan,
      ),
      StitchedCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const GuideHeading(
              'Volver al pasillo',
              eyebrow: 'Eliminación y reaparición',
            ),
            const SizedBox(height: 8),
            const GuideRule(
              'Al ser eliminado reapareces con 100 de vida. Pierdes el casco que llevabas.',
            ),
            const GuideRule(
              'La partida continúa hasta que termina el tiempo. Gana quien acumula más puntos.',
            ),
            const SizedBox(height: 10),
            FilledButton.icon(
              style: FilledButton.styleFrom(
                backgroundColor: Palette.ink,
                foregroundColor: Palette.paper,
              ),
              onPressed: () => Navigator.pushNamed(context, WikiRoutes.stealth),
              icon: const Icon(Icons.visibility_off_outlined),
              label: const Text('Aprender a pasar desapercibido'),
            ),
          ],
        ),
      ),
    ],
  );
}
