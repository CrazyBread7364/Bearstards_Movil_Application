import 'package:bearstards_movil_application/features/results/domain/models/player_score.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const valid = <String, Object?>{
    'id': 9,
    'username': 'memo',
    'partidas': 2,
    'victorias': 2,
    'derrotas': 0,
    'empates': 0,
    'kills': 3,
    'puntos_totales': 600,
    'mejor_puntuacion': 400,
  };

  test('reads a player exactly as the API sends it', () {
    final player = PlayerScore.fromJson(valid);
    expect(player.id, 9);
    expect(player.username, 'memo');
    expect(player.games, 2);
    expect(player.wins, 2);
    expect(player.losses, 0);
    expect(player.draws, 0);
    expect(player.kills, 3);
    expect(player.totalPoints, 600);
    expect(player.bestScore, 400);
  });

  test('negative points are valid: hitting NPCs subtracts points', () {
    final player = PlayerScore.fromJson({
      ...valid,
      'puntos_totales': -150,
      'mejor_puntuacion': -50,
    });
    expect(player.totalPoints, -150);
    expect(player.bestScore, -50);
  });

  test('the win rate is wins over games', () {
    expect(
      PlayerScore.fromJson({...valid, 'partidas': 4, 'victorias': 1}).winRate,
      .25,
    );
    expect(PlayerScore.fromJson(valid).winRate, 1);
  });

  test(
    'a player with no games has no win rate instead of a division by zero',
    () {
      final player = PlayerScore.fromJson({
        ...valid,
        'partidas': 0,
        'victorias': 0,
      });
      expect(player.winRate, isNull);
    },
  );

  for (final key in [
    'id',
    'partidas',
    'victorias',
    'derrotas',
    'empates',
    'kills',
    'puntos_totales',
    'mejor_puntuacion',
  ]) {
    test('a missing $key is rejected naming the field', () {
      final broken = {...valid}..remove(key);
      expect(
        () => PlayerScore.fromJson(broken),
        throwsA(
          isA<FormatException>().having(
            (e) => e.message,
            'message',
            contains(key),
          ),
        ),
      );
    });

    test('a $key that is not a whole number is rejected', () {
      expect(
        () => PlayerScore.fromJson({...valid, key: '5'}),
        throwsFormatException,
      );
      expect(
        () => PlayerScore.fromJson({...valid, key: 5.5}),
        throwsFormatException,
      );
    });
  }

  test('an empty or missing username is rejected', () {
    expect(
      () => PlayerScore.fromJson({...valid, 'username': ''}),
      throwsFormatException,
    );
    expect(
      () => PlayerScore.fromJson({...valid, 'username': '  '}),
      throwsFormatException,
    );
    expect(
      () => PlayerScore.fromJson({...valid, 'username': null}),
      throwsFormatException,
    );
  });
}
