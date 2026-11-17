import 'dart:async';

import 'package:bearstards_movil_application/features/results/domain/models/player_score.dart';
import 'package:bearstards_movil_application/features/results/domain/repositories/results_repository.dart';

/// A player with the numbers that matter for ordering and display.
PlayerScore testScore(
  String username, {
  int points = 0,
  int games = 0,
  int wins = 0,
  int id = 1,
}) => PlayerScore(
  id: id,
  username: username,
  games: games,
  wins: wins,
  losses: games - wins,
  draws: 0,
  kills: 0,
  totalPoints: points,
  bestScore: points,
);

/// Answers each call of `ranking()` with the next prepared response, so a
/// test decides when the repository succeeds, fails or stays pending.
class FakeResultsRepository implements ResultsRepository {
  FakeResultsRepository(Iterable<FutureOr<List<PlayerScore>> Function()> steps)
    : _steps = List.of(steps);

  /// Always answers with the same ranking.
  FakeResultsRepository.always(List<PlayerScore> ranking)
    : _steps = [() => ranking],
      _repeatLast = true;

  /// Always fails with [error].
  FakeResultsRepository.failing(ResultsException error)
    : _steps = [() => throw error],
      _repeatLast = true;

  final List<FutureOr<List<PlayerScore>> Function()> _steps;
  var _repeatLast = false;
  var calls = 0;

  @override
  Future<List<PlayerScore>> ranking() async {
    calls++;
    final index = calls - 1;
    final step = index < _steps.length
        ? _steps[index]
        : (_repeatLast
              ? _steps.last
              : throw StateError(
                  'Sin respuesta preparada para la llamada $calls',
                ));
    return step();
  }
}

/// A small, varied ranking for tests that only need some data on screen: a
/// leader, long names, a negative score and a player with no games.
final sampleRanking = [
  testScore('memo', points: 600, games: 2, wins: 2, id: 1),
  testScore('CarlOso', points: 500, games: 3, wins: 1, id: 2),
  testScore('AngelOso', points: 200, games: 3, wins: 2, id: 3),
  testScore('celaya', id: 4),
  testScore('memo2', points: -150, games: 2, id: 5),
];
