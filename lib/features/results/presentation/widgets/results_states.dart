import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/guide_components.dart';
import '../../../../core/widgets/stitched_card.dart';
import '../../domain/repositories/results_repository.dart';

/// Friendly wording for each reason the results could not load.
String errorMessage(ResultsException error) => switch (error) {
  ResultsUnavailable() =>
    'No pudimos conectar con el servidor. Revisa tu conexión e inténtalo de '
        'nuevo.',
  ResultsFormatError() =>
    'El servidor respondió con datos que la app no entiende. Inténtalo más '
        'tarde.',
};

/// Placeholder rows while the first load runs. It is still on purpose: an
/// endless spinner would keep the screen redrawing.
class ResultsLoading extends StatelessWidget {
  const ResultsLoading({super.key});

  @override
  Widget build(BuildContext context) => Semantics(
    container: true,
    liveRegion: true,
    label: 'Cargando resultados',
    excludeSemantics: true,
    child: StitchedCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Cargando resultados…',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 14),
          for (final width in const [1.0, .8, .9])
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: FractionallySizedBox(
                widthFactor: width,
                child: Container(
                  height: 16,
                  decoration: BoxDecoration(
                    color: Palette.cream,
                    border: Border.all(color: Palette.ink, width: 2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
        ],
      ),
    ),
  );
}

class ResultsEmpty extends StatelessWidget {
  const ResultsEmpty({super.key});

  @override
  Widget build(BuildContext context) => const GuideCallout(
    title: 'Aún no hay partidas registradas',
    body:
        'Cuando los jugadores terminen sus primeros duelos, aquí aparecerá '
        'el ranking global.',
    icon: Icons.emoji_events_outlined,
    color: Palette.yellow,
  );
}

class ResultsError extends StatelessWidget {
  const ResultsError({super.key, required this.error, required this.onRetry});
  final ResultsException error;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) => StitchedCard(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Semantics(
          liveRegion: true,
          child: GuideHeading(
            'No se pudieron cargar los resultados',
            eyebrow: 'Sin datos',
            subtitle: errorMessage(error),
          ),
        ),
        const SizedBox(height: 14),
        RetryButton(onPressed: onRetry),
      ],
    ),
  );
}

/// Shown over the old data when the newest refresh failed.
class StaleBanner extends StatelessWidget {
  const StaleBanner({super.key, required this.error, required this.onRetry});
  final ResultsException error;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) => StitchedCard(
    // Opaque: a translucent fill would turn dark over the night background.
    color: Color.alphaBlend(Palette.pink.withValues(alpha: .3), Palette.paper),
    padding: const EdgeInsets.all(16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Semantics(
          liveRegion: true,
          child: Text(
            'No se pudo actualizar',
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Mostramos los últimos resultados que se cargaron. '
          '${errorMessage(error)}',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 12),
        RetryButton(onPressed: onRetry),
      ],
    ),
  );
}

class RetryButton extends StatelessWidget {
  const RetryButton({
    super.key,
    required this.onPressed,
    this.label = 'Reintentar',
    this.onDark = false,
  });
  final VoidCallback? onPressed;
  final String label;

  /// On the night background the button is paper-colored to stay visible.
  final bool onDark;

  @override
  Widget build(BuildContext context) => FilledButton.icon(
    style: FilledButton.styleFrom(
      backgroundColor: onDark ? Palette.paper : Palette.ink,
      foregroundColor: onDark ? Palette.ink : Palette.paper,
      disabledBackgroundColor: Palette.paper.withValues(alpha: .6),
      minimumSize: const Size(48, 48),
    ),
    onPressed: onPressed,
    icon: const Icon(Icons.refresh_rounded),
    label: Text(label),
  );
}
