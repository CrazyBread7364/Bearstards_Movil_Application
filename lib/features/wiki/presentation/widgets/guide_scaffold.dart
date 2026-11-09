import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../app/navigation/wiki_routes.dart';
import '../../../../core/assets/wiki_assets.dart';
import '../../../../core/theme/app_theme.dart';

class GuideScaffold extends StatelessWidget {
  const GuideScaffold({
    super.key,
    required this.title,
    required this.section,
    required this.children,
    this.showNavigation = true,
  });
  final String title;
  final WikiSection section;
  final List<Widget> children;
  final bool showNavigation;

  @override
  Widget build(BuildContext context) => WikiBackground(
    child: SafeArea(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 640),
          child: Column(
            children: [
              _GuideHeader(title: title),
              Expanded(
                child: ListView.separated(
                  key: PageStorageKey('guide-${section.name}-$title'),
                  padding: const EdgeInsets.fromLTRB(20, 8, 24, 24),
                  itemCount: children.length,
                  separatorBuilder: (_, index) => const SizedBox(height: 18),
                  itemBuilder: (_, index) => children[index],
                ),
              ),
              if (showNavigation) _GuideNavigation(current: section),
            ],
          ),
        ),
      ),
    ),
  );
}

class WikiBackground extends StatelessWidget {
  const WikiBackground({super.key, required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) => AnnotatedRegion<SystemUiOverlayStyle>(
    value: SystemUiOverlayStyle.light.copyWith(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Palette.night,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
    child: Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            WikiAssets.background,
            fit: BoxFit.cover,
            excludeFromSemantics: true,
          ),
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0x44171344),
                  Color(0x99171344),
                  Color(0xdd171344),
                ],
              ),
            ),
          ),
          child,
        ],
      ),
    ),
  );
}

class _GuideHeader extends StatelessWidget {
  const _GuideHeader({required this.title});
  final String title;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(12, 6, 12, 8),
    child: Row(
      children: [
        IconButton.filledTonal(
          tooltip: 'Volver',
          style: IconButton.styleFrom(
            backgroundColor: Palette.paper,
            foregroundColor: Palette.ink,
            minimumSize: const Size(48, 48),
          ),
          onPressed: () => Navigator.maybePop(context),
          icon: const Icon(Icons.arrow_back_rounded),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'BEARSTARDS / WIKI',
                style: Theme.of(context).textTheme.labelSmall!
                    .copyWith(color: Palette.yellow, letterSpacing: 1.3),
              ),
              const SizedBox(height: 4),
              Text(
                title,
                style: Theme.of(context).textTheme.titleLarge!
                    .copyWith(color: Palette.paper),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

const _destinations = [
  (WikiSection.home, 'Inicio', Icons.home_outlined),
  (WikiSection.stealth, 'Sigilo', Icons.visibility_off_outlined),
  (WikiSection.objects, 'Objetos', Icons.inventory_2_outlined),
  (WikiSection.arsenal, 'Arsenal', Icons.gps_fixed_rounded),
  (WikiSection.map, 'Mapa', Icons.map_outlined),
];

class _GuideNavigation extends StatelessWidget {
  const _GuideNavigation({required this.current});
  final WikiSection current;
  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.fromLTRB(12, 0, 12, 10),
    padding: const EdgeInsets.all(5),
    decoration: BoxDecoration(
      color: Palette.paper,
      border: Border.all(color: Palette.ink, width: 2.5),
      borderRadius: BorderRadius.circular(20),
      boxShadow: const [BoxShadow(color: Palette.ink, offset: Offset(3, 3))],
    ),
    child: Row(
      children: [
        for (final (section, label, icon) in _destinations)
          Expanded(
            child: Semantics(
              button: true,
              selected: current == section,
              label: 'Ir a $label',
              excludeSemantics: true,
              child: Material(
                color: current == section ? Palette.yellow : Colors.transparent,
                borderRadius: BorderRadius.circular(13),
                child: InkWell(
                  borderRadius: BorderRadius.circular(13),
                  onTap: () => WikiRoutes.select(context, section, current),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 9,
                      horizontal: 2,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(icon, size: 23),
                        const SizedBox(height: 4),
                        Text(
                          label,
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: current == section
                                ? FontWeight.w700
                                : FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    ),
  );
}
