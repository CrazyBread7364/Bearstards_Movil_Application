import 'package:bearstards_movil_application/features/wiki/data/local_wiki_repository.dart';
import 'package:bearstards_movil_application/features/wiki/domain/models/match_phase.dart';
import 'package:bearstards_movil_application/features/wiki/domain/models/stealth_action.dart';
import 'package:bearstards_movil_application/features/wiki/domain/models/wiki_entry.dart';
import 'package:bearstards_movil_application/features/wiki/presentation/view_models/phases_view_model.dart';
import 'package:bearstards_movil_application/features/wiki/presentation/view_models/stealth_view_model.dart';
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

  suiteTest(tc11, () {
    final stealth = StealthViewModel(repository);
    final phases = PhasesViewModel(repository);
    addTearDown(stealth.dispose);
    addTearDown(phases.dispose);
    var stealthUpdates = 0;
    var phaseUpdates = 0;
    stealth.addListener(() => stealthUpdates++);
    phases.addListener(() => phaseUpdates++);

    stealth.select(StealthActionId.run);
    stealth.select(StealthActionId.run);
    expect(stealthUpdates, 1);
    expect(stealth.selected.id, StealthActionId.run);
    expect(stealth.selected.discreet, isFalse);

    expect(phases.selected.id, PhaseId.lightsOff);
    phases.select(PhaseId.finalSale);
    expect(phaseUpdates, 1);
    expect(phases.selected.description, contains('mitad'));

    expect(stealthUpdates, 1, reason: 'Las fases no notifican a Sigilo');
    expect(stealth.selected.id, StealthActionId.run);
  });
}
