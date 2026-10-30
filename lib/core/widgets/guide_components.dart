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
        Text(
          eyebrow!.toUpperCase(),
          style: Theme.of(context).textTheme.labelSmall!
              .copyWith(color: light ? Palette.yellow : Palette.muted),
        ),
        const SizedBox(height: 7),
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

class StatPill extends StatelessWidget {
  const StatPill(this.label, {super.key, this.color = Palette.cream});
  final String label;
  final Color color;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
    decoration: BoxDecoration(
      color: color,
      border: Border.all(color: Palette.ink.withValues(alpha: .4)),
      borderRadius: BorderRadius.circular(8),
    ),
    child: Text(
      label,
      style: Theme.of(context).textTheme.labelSmall!
          .copyWith(letterSpacing: .2),
    ),
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
