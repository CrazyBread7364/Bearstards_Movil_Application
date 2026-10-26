enum EntryId { needle, dartBlaster, helmet, threadSpool }

enum EntryCategory { weapons, objects }

class WikiStat {
  const WikiStat(this.label, this.value);
  final String label;
  final String value;
}

/// Read-only reference content. No Flutter, assets or navigation dependencies.
class WikiEntry {
  const WikiEntry({
    required this.id,
    required this.category,
    required this.title,
    required this.summary,
    required this.description,
    required this.stats,
    required this.rules,
    required this.tip,
  });

  final EntryId id;
  final EntryCategory category;
  final String title;
  final String summary;
  final String description;
  final List<WikiStat> stats;
  final List<String> rules;
  final String tip;
}
