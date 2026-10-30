import 'package:flutter/foundation.dart';

import '../../domain/models/stealth_action.dart';
import '../../domain/repositories/wiki_repository.dart';

class StealthViewModel extends ChangeNotifier {
  StealthViewModel(WikiRepository repository)
    : actions = repository.stealthActions;
  final List<StealthAction> actions;
  StealthActionId _selected = StealthActionId.walk;
  StealthAction get selected =>
      actions.firstWhere((action) => action.id == _selected);

  void select(StealthActionId id) {
    if (_selected == id || !actions.any((action) => action.id == id)) return;
    _selected = id;
    notifyListeners();
  }
}
