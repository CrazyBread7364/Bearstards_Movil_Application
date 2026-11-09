import 'package:flutter/material.dart';

import '../core/theme/app_theme.dart';
import '../features/wiki/data/local_wiki_repository.dart';
import '../features/wiki/domain/repositories/wiki_repository.dart';
import 'navigation/wiki_router.dart';
import 'navigation/wiki_routes.dart';

/// Composition root: dependencies are explicit and replaceable in tests.
class BearstardsWikiApp extends StatelessWidget {
  const BearstardsWikiApp({
    super.key,
    this.repository = const LocalWikiRepository(),
  });
  final WikiRepository repository;
  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Bearstards Wiki',
    theme: AppTheme.light,
    initialRoute: WikiRoutes.home,
    onGenerateRoute: WikiRouter(repository).onGenerateRoute,
  );
}
