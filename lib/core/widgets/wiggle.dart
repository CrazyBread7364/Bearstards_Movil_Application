import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Rocks its child a few times when it first appears and then rests, like the
/// weapons of the web that sway.
///
/// The motion is finite on purpose: an endless animation would keep the
/// screen redrawing and would never let widget tests settle. Nothing moves
/// when the system asks to reduce motion.
class Wiggle extends StatefulWidget {
  const Wiggle({
    super.key,
    required this.child,
    this.cycles = 3,
    this.maxAngle = .05,
    this.duration = const Duration(milliseconds: 2400),
  });
  final Widget child;
  final int cycles;

  /// Largest tilt in radians, reached at the first swing.
  final double maxAngle;
  final Duration duration;

  /// Tilt at progress [t] (0 to 1): a sine that fades out to a full stop.
  static double angleAt(double t, {int cycles = 3, double maxAngle = .05}) =>
      math.sin(t * cycles * 2 * math.pi) * maxAngle * (1 - t);

  @override
  State<Wiggle> createState() => _WiggleState();
}

class _WiggleState extends State<Wiggle> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: widget.duration,
  );
  var _started = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_started) return;
    _started = true;
    if (!MediaQuery.disableAnimationsOf(context)) _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: _controller,
    child: widget.child,
    builder: (context, child) => Transform.rotate(
      angle: Wiggle.angleAt(
        _controller.value,
        cycles: widget.cycles,
        maxAngle: widget.maxAngle,
      ),
      child: child,
    ),
  );
}
