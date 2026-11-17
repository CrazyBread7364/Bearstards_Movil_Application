/// One row of the global ranking, as the web API reports it.
class PlayerScore {
  const PlayerScore({
    required this.id,
    required this.username,
    required this.games,
    required this.wins,
    required this.losses,
    required this.draws,
    required this.kills,
    required this.totalPoints,
    required this.bestScore,
  });

  /// Reads one player of `GET /api/ranking/`.
  ///
  /// Throws a [FormatException] naming the field when the data is not what the
  /// API contract promises, so a changed backend fails loudly instead of
  /// showing wrong numbers.
  factory PlayerScore.fromJson(Map<String, Object?> json) {
    int number(String key) {
      final value = json[key];
      if (value is int) return value;
      throw FormatException('Campo inválido en el ranking: $key', json);
    }

    final username = json['username'];
    if (username is! String || username.trim().isEmpty) {
      throw FormatException('Campo inválido en el ranking: username', json);
    }
    return PlayerScore(
      id: number('id'),
      username: username,
      games: number('partidas'),
      wins: number('victorias'),
      losses: number('derrotas'),
      draws: number('empates'),
      kills: number('kills'),
      totalPoints: number('puntos_totales'),
      bestScore: number('mejor_puntuacion'),
    );
  }

  final int id;
  final String username;
  final int games, wins, losses, draws, kills;

  /// Points can be negative: hitting NPCs subtracts points.
  final int totalPoints, bestScore;

  /// Share of games won, from 0 to 1. Null for a player with no games yet,
  /// because dividing by zero would say nothing true.
  double? get winRate => games == 0 ? null : wins / games;
}
