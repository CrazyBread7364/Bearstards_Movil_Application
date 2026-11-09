import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Full-width cream block with a wavy top edge, like the web sections.
///
/// The top padding leaves room for the wave, so content never touches it.
class CreamSection extends StatelessWidget {
  const CreamSection({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.fromLTRB(20, 44, 20, 28),
  });
  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) => CustomPaint(
    painter: const _WavePainter(),
    child: Padding(padding: padding, child: child),
  );
}

class _WavePainter extends CustomPainter {
  const _WavePainter();

  static const _amplitude = 12.0;
  static const _wavelength = 64.0;

  @override
  void paint(Canvas canvas, Size size) {
    final edge = Path()..moveTo(0, _amplitude);
    for (var x = 0.0; x < size.width; x += _wavelength) {
      edge
        ..quadraticBezierTo(
          x + _wavelength / 4,
          0,
          x + _wavelength / 2,
          _amplitude,
        )
        ..quadraticBezierTo(
          x + _wavelength * 3 / 4,
          _amplitude * 2,
          x + _wavelength,
          _amplitude,
        );
    }
    final fill = Path.from(edge)
      ..lineTo(size.width + _wavelength, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas
      ..save()
      ..clipRect(Offset.zero & size)
      ..drawPath(fill, Paint()..color = Palette.cream)
      ..drawPath(
        edge,
        Paint()
          ..color = Palette.ink
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3.5
          ..strokeJoin = StrokeJoin.round,
      )
      ..restore();
  }

  @override
  bool shouldRepaint(_WavePainter oldDelegate) => false;
}
