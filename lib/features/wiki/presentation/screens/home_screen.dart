import 'package:flutter/material.dart';

import '../../../../app/navigation/wiki_routes.dart';
import '../../../../core/assets/wiki_assets.dart';
import '../../../../core/theme/app_theme.dart';
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
              final tileHeight =
                  (constraints.maxWidth - 52) / 2 * 1.06 + (scale - 1) * 42;
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
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(18, 4, 18, 12),
                    sliver: SliverToBoxAdapter(
                      child: Row(
                        children: [
                          Container(
                            width: 5,
                            height: 14,
                            decoration: BoxDecoration(
                              color: Palette.yellow,
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'EXPLORA LA GUÍA',
                            style: Theme.of(context).textTheme.labelSmall!
                                .copyWith(
                                  color: Palette.paper,
                                  letterSpacing: 1.6,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(18, 0, 22, 22),
                    sliver: SliverGrid(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisExtent: tileHeight,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 14,
                      ),
                      delegate: SliverChildListDelegate.fixed(const [
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
                        _HomeCategory(
                          'Arsenal',
                          WikiAssets.dartBlaster,
                          Palette.cyan,
                          WikiSection.arsenal,
                        ),
                        _HomeCategory(
                          'La Juguetería',
                          WikiAssets.map,
                          Palette.lavender,
                          WikiSection.map,
                        ),
                      ]),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                      child: Text(
                        'Observa. Confúndete. Conoce La Juguetería.',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodySmall!
                            .copyWith(color: Palette.cream),
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
