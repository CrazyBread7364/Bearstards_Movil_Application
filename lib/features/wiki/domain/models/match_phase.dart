enum PhaseId { lightsOff, newStock, finalSale }

class MatchPhase {
  const MatchPhase({
    required this.id,
    required this.title,
    required this.period,
    required this.description,
    required this.advice,
  });
  final PhaseId id;
  final String title;
  final String period;
  final String description;
  final String advice;
}
