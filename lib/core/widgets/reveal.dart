import 'package:flutter/material.dart';

/// Fades and slides its child up with a small bounce the first time it
/// appears, like the sections of the web that reveal while scrolling.
///
/// Nothing animates when the system asks to reduce motion or when
/// [animate] is false (an item that already revealed once).
class Reveal extends StatefulWidget {
  const Reveal({
    super.key,
    required this.child,
    this.delay = Duration.zero,
    this.animate = true,
  });
  final Widget child;
  final Duration delay;
  final bool animate;

  static const duration = Duration(milliseconds: 600);
  static const _distance = 28.0;

  @override
  State<Reveal> createState() => _RevealState();
}

class _RevealState extends State<Reveal> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: widget.delay + Reveal.duration,
  );
  late final Animation<double> _fade;
  late final Animation<double> _lift;
  var _started = false;

  @override
  void initState() {
    super.initState();
    // The delay is part of the timeline, so no timer is left pending.
    final start =
        widget.delay.inMilliseconds / _controller.duration!.inMilliseconds;
    _fade = CurvedAnimation(
      parent: _controller,
      curve: Interval(start, 1, curve: Curves.easeOut),
    );
    _lift = CurvedAnimation(
      parent: _controller,
      curve: Interval(start, 1, curve: Curves.easeOutBack),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_started) return;
    _started = true;
    if (!widget.animate || MediaQuery.disableAnimationsOf(context)) {
      _controller.value = 1;
    } else {
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => FadeTransition(
    opacity: _fade,
    child: AnimatedBuilder(
      animation: _lift,
      child: widget.child,
      builder: (context, child) => Transform.translate(
        offset: Offset(0, Reveal._distance * (1 - _lift.value)),
        child: child,
      ),
    ),
  );
}
