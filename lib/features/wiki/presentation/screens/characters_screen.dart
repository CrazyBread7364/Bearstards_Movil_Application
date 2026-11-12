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
      const GuideHeading('Tres reglas.', eyebrow: 'Cómo se juega', light: true),
      const NumberedRule(
        number: 1,
        title: 'Encuentra a tu rival',
        body:
            'Entre los NPC hay un oso controlado por otra persona. Observa '
            'quién camina distinto.',
        color: Palette.cyan,
      ),
      const NumberedRule(
        number: 2,
        title: 'Equípate sin llamar la atención',
        body:
            'Recoge tu arma por los pasillos. Portarla te delata, porque los '
            'NPC nunca llevan armas.',
        color: Palette.mint,
      ),
      const NumberedRule(
        number: 3,
        title: 'Elimina al correcto',
        body:
            'Un golpe a la cabeza elimina al instante. Golpear a un NPC resta '
            '50 puntos.',
        color: Palette.pink,
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
