import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import 'stitched_card.dart';

class GuideHeading extends StatelessWidget {
  const GuideHeading(
    this.title, {
    super.key,
    this.eyebrow,
    this.subtitle,
    this.light = false,
  });
  final String title;
  final String? eyebrow, subtitle;
  final bool light;
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      if (eyebrow != null) ...[
        EyebrowChip(eyebrow!, color: light ? Palette.pink : Palette.yellow),
        const SizedBox(height: 10),
      ],
      Text(
        title,
        style: Theme.of(context).textTheme.headlineSmall!
            .copyWith(color: light ? Palette.paper : Palette.ink),
      ),
      if (subtitle != null) ...[
        const SizedBox(height: 7),
        Text(
          subtitle!,
          style: Theme.of(context).textTheme.bodyMedium!
              .copyWith(color: light ? Palette.cream : Palette.muted),
        ),
      ],
    ],
  );
}

/// Tilted label above a heading, like the sticker chips of the web ranking.
class EyebrowChip extends StatelessWidget {
  const EyebrowChip(this.label, {super.key, this.color = Palette.yellow});
  final String label;
  final Color color;
  @override
  Widget build(BuildContext context) => Transform.rotate(
    angle: -.035,
    alignment: Alignment.centerLeft,
    child: _ToonPill(
      label.toUpperCase(),
      color: color,
      style: Theme.of(context).textTheme.labelSmall!
          .copyWith(letterSpacing: 1.4),
    ),
  );
}

class StatPill extends StatelessWidget {
  const StatPill(this.label, {super.key, this.color = Palette.cream});
  final String label;
  final Color color;
  @override
  Widget build(BuildContext context) => _ToonPill(
    label,
    color: color,
    style: Theme.of(context).textTheme.labelSmall!.copyWith(letterSpacing: .2),
  );
}

/// Pill with a solid ink outline and a hard offset shadow.
class _ToonPill extends StatelessWidget {
  const _ToonPill(this.label, {required this.color, required this.style});
  final String label;
  final Color color;
  final TextStyle style;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    decoration: BoxDecoration(
      // Translucent fills would let the hard shadow show through the pill.
      color: Color.alphaBlend(color, Palette.paper),
      border: Border.all(color: Palette.ink, width: 2.5),
      borderRadius: BorderRadius.circular(999),
      boxShadow: const [BoxShadow(color: Palette.ink, offset: Offset(2, 3))],
    ),
    child: Text(label, style: style),
  );
}

class GuideCallout extends StatelessWidget {
  const GuideCallout({
    super.key,
    required this.title,
    required this.body,
    this.icon = Icons.info_outline_rounded,
    this.color = Palette.cyan,
  });
  final String title, body;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) => StitchedCard(
    padding: const EdgeInsets.all(16),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(9),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(11),
          ),
          child: Icon(icon, size: 22),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 5),
              Text(body, style: Theme.of(context).textTheme.bodyMedium),
            ],
          ),
        ),
      ],
    ),
  );
}

class GuideRule extends StatelessWidget {
  const GuideRule(this.text, {super.key, this.color = Palette.yellow});
  final String text;
  final Color color;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 7),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Container(
            width: 7,
            height: 7,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(child: Text(text)),
      ],
    ),
  );
}

/// Rule card with a numbered badge, like the numbered rules of the web.
class NumberedRule extends StatelessWidget {
  const NumberedRule({
    super.key,
    required this.number,
    required this.title,
    required this.body,
    this.color = Palette.cyan,
  });
  final int number;
  final String title, body;
  final Color color;

  @override
  Widget build(BuildContext context) => StitchedCard(
    padding: const EdgeInsets.all(16),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 46,
          height: 46,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            border: Border.all(color: Palette.ink, width: 2.5),
            boxShadow: const [
              BoxShadow(color: Palette.ink, offset: Offset(2, 3)),
            ],
          ),
          child: Text('$number', style: Theme.of(context).textTheme.titleLarge),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 4),
              Text(body, style: Theme.of(context).textTheme.bodyMedium),
            ],
          ),
        ),
      ],
    ),
  );
}
