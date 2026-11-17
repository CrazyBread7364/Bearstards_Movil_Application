import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Tilted yellow band with phrases that scroll sideways, like the ribbon of
/// the web, with a button to pause it.
///
/// With reduced motion the band stays still and the button is not shown.
class TextTicker extends StatefulWidget {
  const TextTicker({
    super.key,
    required this.phrases,
    this.cycle = const Duration(seconds: 40),
  });
  final List<String> phrases;

  /// Time the phrases take to travel one full repetition.
  final Duration cycle;

  @override
  State<TextTicker> createState() => _TextTickerState();
}

class _TextTickerState extends State<TextTicker>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: widget.cycle,
  );
  var _started = false;
  var _paused = false;

  bool get _moves => !MediaQuery.disableAnimationsOf(context);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_started) return;
    _started = true;
    if (_moves) _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() => _paused = !_paused);
    _paused ? _controller.stop() : _controller.repeat();
  }

  @override
  Widget build(BuildContext context) {
    final moves = _moves;
    return Stack(
      alignment: Alignment.centerRight,
      children: [
        ExcludeSemantics(
          child: Transform.rotate(
            angle: -.02,
            // A wider band keeps the tilted ends past the screen edges.
            child: Transform.scale(
              scaleX: 1.08,
              child: _Band(
                controller: _controller,
                phrases: widget.phrases,
                moves: moves,
              ),
            ),
          ),
        ),
        if (moves)
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Semantics(
              button: true,
              toggled: _paused,
              label: _paused
                  ? 'Reanudar la cinta de texto'
                  : 'Pausar la cinta de texto',
              excludeSemantics: true,
              child: Material(
                color: Palette.paper,
                shape: const CircleBorder(
                  side: BorderSide(color: Palette.ink, width: 2.5),
                ),
                child: InkWell(
                  customBorder: const CircleBorder(),
                  onTap: _toggle,
                  child: SizedBox(
                    width: 40,
                    height: 40,
                    child: Icon(
                      _paused ? Icons.play_arrow_rounded : Icons.pause_rounded,
                      size: 22,
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _Band extends StatelessWidget {
  const _Band({
    required this.controller,
    required this.phrases,
    required this.moves,
  });
  final AnimationController controller;
  final List<String> phrases;
  final bool moves;

  @override
  Widget build(BuildContext context) => Container(
    height: 50,
    decoration: const BoxDecoration(
      color: Palette.yellow,
      border: Border.symmetric(
        horizontal: BorderSide(color: Palette.ink, width: 3.5),
      ),
    ),
    child: ClipRect(
      child: OverflowBox(
        alignment: Alignment.centerLeft,
        minWidth: 0,
        maxWidth: double.infinity,
        child: AnimatedBuilder(
          animation: controller,
          // The phrases are repeated twice: sliding by half the row repeats
          // the same picture, so the loop has no visible jump.
          builder: (context, child) => FractionalTranslation(
            translation: Offset(moves ? -.5 * controller.value : 0, 0),
            child: child,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (var copy = 0; copy < 2; copy++)
                for (final phrase in phrases) ...[
                  Text(
                    phrase.toUpperCase(),
                    maxLines: 1,
                    softWrap: false,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const _Diamond(),
                ],
            ],
          ),
        ),
      ),
    ),
  );
}

class _Diamond extends StatelessWidget {
  const _Diamond();

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20),
    child: Transform.rotate(
      angle: .785,
      child: Container(
        width: 12,
        height: 12,
        decoration: BoxDecoration(
          color: Palette.pink,
          border: Border.all(color: Palette.ink, width: 2.5),
        ),
      ),
    ),
  );
}
