import 'package:flutter/foundation.dart';

import '../../domain/models/match_phase.dart';
import '../../domain/repositories/wiki_repository.dart';

class PhasesViewModel extends ChangeNotifier {
  PhasesViewModel(WikiRepository repository) : phases = repository.phases;
  final List<MatchPhase> phases;
  PhaseId _selected = PhaseId.lightsOff;
  MatchPhase get selected =>
      phases.firstWhere((phase) => phase.id == _selected);

  void select(PhaseId id) {
    if (_selected == id || !phases.any((phase) => phase.id == id)) return;
    _selected = id;
    notifyListeners();
  }
}
