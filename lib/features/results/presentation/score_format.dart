import '../domain/models/player_score.dart';

/// Points with the same minus sign the wiki uses ("−50").
String formatPoints(int points) => points < 0 ? '−${-points}' : '$points';

/// "67 %", or a dash for a player with no games.
String formatWinRate(double? rate) =>
    rate == null ? '—' : '${(rate * 100).round()} %';

String gamesLabel(int games) => switch (games) {
  0 => 'Sin partidas',
  1 => '1 partida',
  _ => '$games partidas',
};

/// One sentence for screen readers, so a row is read as a whole.
String describePlayer(int rank, PlayerScore player) {
  final rate = player.winRate;
  return 'Puesto $rank: ${player.username}, '
      '${formatPoints(player.totalPoints)} puntos, '
      '${gamesLabel(player.games).toLowerCase()}'
      '${rate == null ? '' : ', ${formatWinRate(rate)} de victorias'}';
}
