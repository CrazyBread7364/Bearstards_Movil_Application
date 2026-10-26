import '../models/match_phase.dart';
import '../models/stealth_action.dart';
import '../models/wiki_entry.dart';

abstract interface class WikiRepository {
  List<WikiEntry> entriesFor(EntryCategory category);
  WikiEntry entry(EntryId id);
  List<StealthAction> get stealthActions;
  List<MatchPhase> get phases;
}
