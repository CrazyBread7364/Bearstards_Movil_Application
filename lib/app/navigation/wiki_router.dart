import 'package:flutter/material.dart';

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
  const WikiRouter(this.repository);
  final WikiRepository repository;

  Route<dynamic> onGenerateRoute(RouteSettings settings) {
    final screen = switch (settings.name) {
      WikiRoutes.home => const HomeScreen(),
      WikiRoutes.characters => const CharactersScreen(),
      WikiRoutes.stealth => StealthScreen(repository: repository),
      WikiRoutes.objects => ObjectsScreen(repository: repository),
      WikiRoutes.arsenal => ArsenalScreen(repository: repository),
      WikiRoutes.map => MapScreen(repository: repository),
      WikiRoutes.detail when settings.arguments is EntryId => EntryDetailScreen(
        entry: repository.entry(settings.arguments as EntryId),
      ),
      _ => const HomeScreen(),
    };
    return MaterialPageRoute(builder: (_) => screen, settings: settings);
  }
}
