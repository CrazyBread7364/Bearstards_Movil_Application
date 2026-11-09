import 'package:bearstards_movil_application/features/wiki/data/local_wiki_repository.dart';
import 'package:bearstards_movil_application/features/wiki/domain/models/wiki_entry.dart';
import 'package:flutter_test/flutter_test.dart';

import 'cases.dart';
import 'test_case.dart';

void main() {
  const repository = LocalWikiRepository();

  suiteTest(tc10, () {
    final weapons = repository.entriesFor(EntryCategory.weapons);
    final objects = repository.entriesFor(EntryCategory.objects);

    expect(weapons.map((e) => e.id), [EntryId.needle, EntryId.dartBlaster]);
    expect(objects.map((e) => e.id), [EntryId.helmet, EntryId.threadSpool]);
    expect(() => weapons.clear(), throwsUnsupportedError);
    for (final id in EntryId.values) {
      expect(repository.entry(id).rules, isNotEmpty, reason: '$id');
    }
  });
}
