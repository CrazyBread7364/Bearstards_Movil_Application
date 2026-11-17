import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/stitched_card.dart';
import '../../domain/models/player_score.dart';
import '../score_format.dart';

/// One player below the podium.
class RankingRow extends StatelessWidget {
  const RankingRow({super.key, required this.rank, required this.player});
  final int rank;
  final PlayerScore player;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    return Semantics(
      container: true,
      label: describePlayer(rank, player),
      excludeSemantics: true,
      child: StitchedCard(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Palette.cream,
                shape: BoxShape.circle,
                border: Border.all(color: Palette.ink, width: 2),
              ),
              child: Text('$rank', style: theme.titleMedium),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    player.username,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.titleLarge,
                  ),
                  Text(
                    '${gamesLabel(player.games)} · '
                    '${formatWinRate(player.winRate)} victorias',
                    style: theme.bodySmall,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(formatPoints(player.totalPoints), style: theme.titleLarge),
                Text('puntos', style: theme.bodySmall),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
