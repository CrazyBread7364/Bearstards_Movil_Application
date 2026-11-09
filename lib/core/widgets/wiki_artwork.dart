import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class WikiArtwork extends StatelessWidget {
  const WikiArtwork(
    this.asset, {
    super.key,
    this.height,
    this.fit = BoxFit.contain,
    this.label,
    this.alignment = Alignment.center,
  });
  final String asset;
  final double? height;
  final BoxFit fit;
  final String? label;
  final Alignment alignment;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final density = MediaQuery.devicePixelRatioOf(context);
      final decodeWidth = constraints.hasBoundedWidth
          ? (constraints.maxWidth * density).ceil().clamp(1, 2048)
          : null;
      return Image.asset(
        asset,
        height: height,
        width: double.infinity,
        fit: fit,
        alignment: alignment,
        cacheWidth: decodeWidth,
        semanticLabel: label,
        excludeFromSemantics: label == null,
        filterQuality: FilterQuality.medium,
        errorBuilder: (context, error, stack) => SizedBox(
          height: height ?? 100,
          child: const Center(
            child: Icon(
              Icons.image_not_supported_outlined,
              color: Palette.muted,
              semanticLabel: 'Ilustración no disponible',
            ),
          ),
        ),
      );
    },
  );
}

/// Code-drawn facets frame the original illustration without baking UI into it.
class ArtworkStage extends StatelessWidget {
  const ArtworkStage({
    super.key,
    required this.asset,
    required this.color,
    this.height = 175,
    this.label,
  });
  final String asset;
  final Color color;
  final double height;
  final String? label;

  @override
  Widget build(BuildContext context) => ClipRRect(
    borderRadius: BorderRadius.circular(13),
    child: ColoredBox(
      color: color.withValues(alpha: .18),
      child: CustomPaint(
        painter: _FacetPainter(color),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: WikiArtwork(asset, height: height, label: label),
        ),
      ),
    ),
  );
}

class _FacetPainter extends CustomPainter {
  const _FacetPainter(this.color);
  final Color color;
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color.withValues(alpha: .23);
    canvas.drawPath(
      Path()
        ..moveTo(size.width * .62, 0)
        ..lineTo(size.width, 0)
        ..lineTo(size.width, size.height)
        ..lineTo(size.width * .18, size.height)
        ..close(),
      paint,
    );
    paint.color = Palette.paper.withValues(alpha: .35);
    canvas.drawPath(
      Path()
        ..moveTo(0, 0)
        ..lineTo(size.width * .42, 0)
        ..lineTo(0, size.height * .75)
        ..close(),
      paint,
    );
  }

  @override
  bool shouldRepaint(_FacetPainter oldDelegate) => oldDelegate.color != color;
}
