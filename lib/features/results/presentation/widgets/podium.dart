import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/stitched_card.dart';
import '../../domain/models/player_score.dart';
import '../score_format.dart';

/// The top three players: the leader on a wide card, then second and third.
class Podium extends StatelessWidget {
  const Podium({super.key, required this.players});

  /// Up to three players, best first.
  final List<PlayerScore> players;

  static const _colors = [Palette.yellow, Palette.lavender, Palette.orange];

  @override
  Widget build(BuildContext context) {
    if (players.isEmpty) return const SizedBox.shrink();
    Widget card(int index, {bool leader = false}) => _PodiumCard(
      rank: index + 1,
      player: players[index],
      color: _colors[index],
      leader: leader,
    );
    return Column(
      children: [
        card(0, leader: true),
        if (players.length > 1) ...[
          const SizedBox(height: 14),
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(child: card(1)),
                const SizedBox(width: 12),
                Expanded(
                  child: players.length > 2 ? card(2) : const SizedBox.shrink(),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}

class _PodiumCard extends StatelessWidget {
  const _PodiumCard({
    required this.rank,
    required this.player,
    required this.color,
    required this.leader,
  });
  final int rank;
  final PlayerScore player;
  final Color color;
  final bool leader;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    return Semantics(
      container: true,
      label: describePlayer(rank, player),
      excludeSemantics: true,
      child: StitchedCard(
        color: color,
        padding: EdgeInsets.all(leader ? 18 : 14),
        child: SizedBox(
          width: double.infinity,
          child: Column(
            children: [
              Container(
                width: leader ? 46 : 38,
                height: leader ? 46 : 38,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Palette.paper,
                  shape: BoxShape.circle,
                  border: Border.all(color: Palette.ink, width: 2.5),
                ),
                child: Text('$rank', style: theme.titleLarge),
              ),
              const SizedBox(height: 8),
              Text(
                player.username,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: leader ? theme.headlineSmall : theme.titleLarge,
              ),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  formatPoints(player.totalPoints),
                  maxLines: 1,
                  style: theme.headlineLarge,
                ),
              ),
              Text('puntos', style: theme.titleMedium!.copyWith(fontSize: 13)),
              const SizedBox(height: 8),
              Text(
                '${gamesLabel(player.games)} · '
                '${formatWinRate(player.winRate)} victorias',
                textAlign: TextAlign.center,
                style: theme.bodySmall!.copyWith(color: Palette.ink),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
