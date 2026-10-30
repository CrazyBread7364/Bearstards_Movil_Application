import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class StitchedCard extends StatelessWidget {
  const StitchedCard({
    super.key,
    required this.child,
    this.color = Palette.paper,
    this.padding = const EdgeInsets.all(18),
    this.onTap,
    this.semanticLabel,
    this.selected = false,
  });
  final Widget child;
  final Color color;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;
  final String? semanticLabel;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final card = Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          const BoxShadow(color: Palette.ink, offset: Offset(4, 5)),
          if (selected) const BoxShadow(color: Palette.paper, spreadRadius: 2),
        ],
      ),
      child: Material(
        color: color,
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: Palette.ink, width: 2.5),
          borderRadius: BorderRadius.circular(20),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: CustomPaint(
            foregroundPainter: const _StitchPainter(),
            child: Padding(padding: padding, child: child),
          ),
        ),
      ),
    );
    if (onTap == null && semanticLabel == null) return card;
    return Semantics(
      container: true,
      button: onTap != null,
      selected: onTap != null ? selected : null,
      label: semanticLabel,
      excludeSemantics: semanticLabel != null,
      onTap: onTap,
      child: card,
    );
  }
}

class _StitchPainter extends CustomPainter {
  const _StitchPainter();
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Palette.ink.withValues(alpha: .14)
      ..strokeWidth = 1.2
      ..strokeCap = StrokeCap.round;
    final path = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          (Offset.zero & size).deflate(7),
          const Radius.circular(13),
        ),
      );
    for (final metric in path.computeMetrics()) {
      for (double distance = 0; distance < metric.length; distance += 13) {
        canvas.drawPath(metric.extractPath(distance, distance + 5), paint);
      }
    }
  }

  @override
  bool shouldRepaint(_StitchPainter oldDelegate) => false;
}
