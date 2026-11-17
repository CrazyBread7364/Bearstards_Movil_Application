import 'package:flutter/material.dart';

import '../../../../app/navigation/wiki_routes.dart';
import '../../../../core/widgets/guide_components.dart';
import '../../../wiki/presentation/widgets/guide_scaffold.dart';
import '../view_models/scores_view_model.dart';
import '../widgets/podium.dart';
import '../widgets/ranking_row.dart';
import '../widgets/results_states.dart';

/// Global results: the best players of the web ranking.
class ScoresScreen extends StatefulWidget {
  const ScoresScreen({super.key, required this.model});

  /// Shared for the whole session, so the last ranking is kept between visits.
  final ScoresViewModel model;

  @override
  State<ScoresScreen> createState() => _ScoresScreenState();
}

class _ScoresScreenState extends State<ScoresScreen> {
  @override
  void initState() {
    super.initState();
    // Opening the screen always asks for fresh data; the old data, if any,
    // stays visible meanwhile.
    widget.model.load();
  }

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: widget.model,
    builder: (context, _) => GuideScaffold(
      title: 'Resultados',
      section: WikiSection.scores,
      children: _children(),
    ),
  );

  List<Widget> _children() {
    final model = widget.model;
    const heading = GuideHeading(
      'Los osos más temidos.',
      eyebrow: 'Resultados globales',
      light: true,
    );
    final error = model.error;

    switch (model.status) {
      case ScoresStatus.idle:
      case ScoresStatus.loading:
        return const [heading, ResultsLoading()];
      case ScoresStatus.failed:
        return [heading, ResultsError(error: error!, onRetry: model.load)];
      case ScoresStatus.empty:
        return [
          heading,
          if (model.isStale) StaleBanner(error: error!, onRetry: model.load),
          const ResultsEmpty(),
        ];
      case ScoresStatus.loaded:
        final ranking = model.ranking;
        return [
          heading,
          if (model.isStale) StaleBanner(error: error!, onRetry: model.load),
          Podium(players: ranking.take(3).toList()),
          for (var i = 3; i < ranking.length; i++)
            RankingRow(rank: i + 1, player: ranking[i]),
          RetryButton(
            onDark: true,
            label: model.isLoading ? 'Actualizando…' : 'Actualizar',
            onPressed: model.isLoading ? null : model.load,
          ),
        ];
    }
  }
}
