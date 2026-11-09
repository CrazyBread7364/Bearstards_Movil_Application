import 'package:flutter/material.dart';

import '../../../../app/navigation/wiki_routes.dart';
import '../../../../core/widgets/guide_components.dart';
import '../../domain/models/wiki_entry.dart';
import '../../domain/repositories/wiki_repository.dart';
import '../widgets/entry_card.dart';
import '../widgets/guide_scaffold.dart';
import '../widgets/health_guide.dart';

class ObjectsScreen extends StatelessWidget {
  const ObjectsScreen({super.key, required this.repository});
  final WikiRepository repository;
  @override
  Widget build(BuildContext context) => GuideScaffold(
    title: 'Objetos',
    section: WikiSection.objects,
    children: [
      const GuideHeading(
        'Resistir. Remendar. Seguir.',
        eyebrow: 'Recursos de La Juguetería',
        light: true,
      ),
      for (final entry in repository.entriesFor(EntryCategory.objects))
        EntryCard(entry: entry, compact: true),
      const HealthGuide(),
    ],
  );
}
