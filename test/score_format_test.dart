import 'package:bearstards_movil_application/features/results/presentation/score_format.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/results_fakes.dart';

void main() {
  test('points use the wiki minus sign for negative values', () {
    expect(formatPoints(600), '600');
    expect(formatPoints(0), '0');
    expect(formatPoints(-50), '−50');
  });

  test('the win rate is a rounded percentage, or a dash without games', () {
    expect(formatWinRate(1), '100 %');
    expect(formatWinRate(2 / 3), '67 %');
    expect(formatWinRate(1 / 3), '33 %');
    expect(formatWinRate(0), '0 %');
    expect(formatWinRate(null), '—');
  });

  test('the games label handles none, one and many', () {
    expect(gamesLabel(0), 'Sin partidas');
    expect(gamesLabel(1), '1 partida');
    expect(gamesLabel(3), '3 partidas');
  });

  test('a row reads as one sentence', () {
    expect(
      describePlayer(1, testScore('memo', points: 600, games: 2, wins: 2)),
      'Puesto 1: memo, 600 puntos, 2 partidas, 100 % de victorias',
    );
  });

  test('a player with no games has no win rate in the sentence', () {
    expect(
      describePlayer(4, testScore('celaya')),
      'Puesto 4: celaya, 0 puntos, sin partidas',
    );
  });
}
