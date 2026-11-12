import 'dart:math';

import 'package:flutter/material.dart';

import '../../../../app/navigation/wiki_routes.dart';
import '../../../../core/assets/wiki_assets.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/cream_section.dart';
import '../../../../core/widgets/guide_components.dart';
import '../../../../core/widgets/stitched_card.dart';
import '../../../../core/widgets/wiki_artwork.dart';
import '../widgets/guide_scaffold.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) => WikiBackground(
    child: SafeArea(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 640),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final heroHeight = (constraints.maxHeight * .45).clamp(
                250.0,
                360.0,
              );
              final scale = MediaQuery.textScalerOf(context).scale(1);
              // Android can lay out a first frame with zero width; a negative
              // height would assert, so the tile height never goes below zero.
              final tileHeight = max(
                0.0,
                (constraints.maxWidth - 52) / 2 * 1.06 + (scale - 1) * 42,
              );
              return CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Semantics(
                      label: 'Portada de Bearstards Wiki',
                      image: true,
                      child: SizedBox(
                        height: heroHeight,
                        child: const _HeroScene(),
                      ),
                    ),
                  ),
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: CreamSection(
                      padding: const EdgeInsets.fromLTRB(20, 44, 20, 28),
                      child: _Chapters(
                        tileHeight: tileHeight,
                        mapHeight: tileHeight * .8,
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    ),
  );
}

/// "Explora la guía": the chapter tiles over the cream section.
class _Chapters extends StatelessWidget {
  const _Chapters({required this.tileHeight, required this.mapHeight});
  final double tileHeight, mapHeight;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const GuideHeading('Elige tu capítulo.', eyebrow: 'Explora la guía'),
      const SizedBox(height: 18),
      // Rows instead of a shrink-wrapped grid: SliverFillRemaining measures
      // its child, and shrink-wrapped viewports cannot be measured.
      for (final pair in const [
        (
          _HomeCategory(
            'Personajes',
            WikiAssets.homeCharacters,
            Palette.pink,
            WikiSection.characters,
          ),
          _HomeCategory(
            'Sigilo',
            WikiAssets.homeStealth,
            Palette.yellow,
            WikiSection.stealth,
          ),
        ),
        (
          _HomeCategory(
            'Objetos',
            WikiAssets.helmet,
            Palette.mint,
            WikiSection.objects,
          ),
          _HomeCategory(
            'Arsenal',
            WikiAssets.dartBlaster,
            Palette.cyan,
            WikiSection.arsenal,
          ),
        ),
      ]) ...[
        SizedBox(
          height: tileHeight,
          child: Row(
            children: [
              Expanded(child: pair.$1),
              const SizedBox(width: 12),
              Expanded(child: pair.$2),
            ],
          ),
        ),
        const SizedBox(height: 14),
      ],
      SizedBox(
        height: mapHeight,
        child: const _HomeCategory(
          'La Juguetería',
          WikiAssets.map,
          Palette.lavender,
          WikiSection.map,
        ),
      ),
      const SizedBox(height: 22),
      Center(
        child: Text(
          'Observa. Confúndete. Conoce La Juguetería.',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ),
    ],
  );
}

class _HeroScene extends StatelessWidget {
  const _HeroScene();
  @override
  Widget build(BuildContext context) => Stack(
    children: [
      const Positioned(
        top: 0,
        left: 25,
        right: 25,
        height: 132,
        child: WikiArtwork(WikiAssets.sign),
      ),
      const Positioned(
        top: 112,
        bottom: 8,
        left: 14,
        right: 14,
        child: WikiArtwork(
          WikiAssets.heroBear,
          alignment: Alignment.bottomCenter,
        ),
      ),
      const Positioned(
        left: -6,
        right: -6,
        bottom: 0,
        height: 78,
        child: WikiArtwork(WikiAssets.crates, fit: BoxFit.fill),
      ),
    ],
  );
}

class _HomeCategory extends StatelessWidget {
  const _HomeCategory(this.title, this.asset, this.color, this.section);
  final String title, asset;
  final Color color;
  final WikiSection section;
  @override
  Widget build(BuildContext context) => StitchedCard(
    color: color,
    padding: const EdgeInsets.all(7),
    semanticLabel: 'Explorar $title',
    onTap: () => Navigator.pushNamed(context, WikiRoutes.forSection(section)),
    child: Column(
      children: [
        Expanded(
          child: WikiArtwork(
            asset,
            fit: section == WikiSection.map ? BoxFit.cover : BoxFit.contain,
          ),
        ),
        const SizedBox(height: 5),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 9),
          decoration: BoxDecoration(
            color: Palette.paper,
            borderRadius: BorderRadius.circular(9),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium!
                      .copyWith(fontSize: 13, letterSpacing: -.4),
                ),
              ),
              const Icon(Icons.chevron_right_rounded, size: 20),
            ],
          ),
        ),
      ],
    ),
  );
}
