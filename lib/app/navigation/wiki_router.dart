import 'package:flutter/material.dart';

import '../../features/results/presentation/screens/scores_screen.dart';
import '../../features/results/presentation/view_models/scores_view_model.dart';
import '../../features/wiki/domain/models/wiki_entry.dart';
import '../../features/wiki/domain/repositories/wiki_repository.dart';
import '../../features/wiki/presentation/screens/arsenal_screen.dart';
import '../../features/wiki/presentation/screens/characters_screen.dart';
import '../../features/wiki/presentation/screens/entry_detail_screen.dart';
import '../../features/wiki/presentation/screens/home_screen.dart';
import '../../features/wiki/presentation/screens/map_screen.dart';
import '../../features/wiki/presentation/screens/objects_screen.dart';
import '../../features/wiki/presentation/screens/stealth_screen.dart';
import 'wiki_routes.dart';

class WikiRouter {
  const WikiRouter(this.repository, {required this.scores});
  final WikiRepository repository;

  /// Shared by every visit to the results screen.
  final ScoresViewModel scores;

  Route<dynamic> onGenerateRoute(RouteSettings settings) {
    final screen = switch (settings.name) {
      WikiRoutes.home => const HomeScreen(),
      WikiRoutes.characters => const CharactersScreen(),
      WikiRoutes.stealth => StealthScreen(repository: repository),
      WikiRoutes.objects => ObjectsScreen(repository: repository),
      WikiRoutes.arsenal => ArsenalScreen(repository: repository),
      WikiRoutes.map => MapScreen(repository: repository),
      WikiRoutes.scores => ScoresScreen(model: scores),
      WikiRoutes.detail when settings.arguments is EntryId => EntryDetailScreen(
        entry: repository.entry(settings.arguments as EntryId),
      ),
      _ => const HomeScreen(),
    };
    return MaterialPageRoute(builder: (_) => screen, settings: settings);
  }
}
