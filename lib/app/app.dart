import 'package:flutter/material.dart';

import '../core/theme/app_theme.dart';
import '../features/results/data/http_results_repository.dart';
import '../features/results/domain/repositories/results_repository.dart';
import '../features/results/presentation/view_models/scores_view_model.dart';
import '../features/wiki/data/local_wiki_repository.dart';
import '../features/wiki/domain/repositories/wiki_repository.dart';
import 'app_config.dart';
import 'navigation/wiki_router.dart';
import 'navigation/wiki_routes.dart';

/// Composition root: dependencies are explicit and replaceable in tests.
class BearstardsWikiApp extends StatefulWidget {
  const BearstardsWikiApp({
    super.key,
    this.repository = const LocalWikiRepository(),
    this.resultsRepository,
  });
  final WikiRepository repository;

  /// Source of the global results. Defaults to the web API of
  /// [AppConfig.apiBaseUrl]; tests inject a fake so they never reach the net.
  final ResultsRepository? resultsRepository;

  @override
  State<BearstardsWikiApp> createState() => _BearstardsWikiAppState();
}

class _BearstardsWikiAppState extends State<BearstardsWikiApp> {
  // One model for the whole session: it keeps the last ranking that loaded.
  late final ScoresViewModel _scores = ScoresViewModel(
    widget.resultsRepository ??
        HttpResultsRepository(baseUrl: AppConfig.apiBaseUrl),
  );

  @override
  void dispose() {
    _scores.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Bearstards Wiki',
    theme: AppTheme.light,
    initialRoute: WikiRoutes.home,
    onGenerateRoute: WikiRouter(
      widget.repository,
      scores: _scores,
    ).onGenerateRoute,
  );
}
