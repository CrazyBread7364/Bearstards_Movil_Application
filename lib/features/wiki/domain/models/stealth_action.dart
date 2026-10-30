enum StealthActionId { walk, run, jump, weapon }

class StealthAction {
  const StealthAction({
    required this.id,
    required this.label,
    required this.description,
    required this.discreet,
  });
  final StealthActionId id;
  final String label;
  final String description;
  final bool discreet;
}
