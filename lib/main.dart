import 'package:flutter/material.dart';

void main() => runApp(const BastardososWikiApp());

class BastardososWikiApp extends StatelessWidget {
  const BastardososWikiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Bastardosos Wiki',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.white,
        colorScheme: ColorScheme.fromSeed(seedColor: _orange),
        fontFamily: 'Arial',
      ),
      home: const HomeScreen(),
    );
  }
}

const _ink = Color(0xFF3C201B);
const _muted = Color(0xFF737373);
const _orange = Color(0xFFF05A28);

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(22, 20, 22, 8),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                const CircleAvatar(radius: 15, backgroundColor: Color(0xFFFFB09C), child: Text('B', style: TextStyle(color: _ink, fontWeight: FontWeight.w800))),
                const SizedBox(width: 9),
                Text('bastardosos wiki', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800, color: _ink)),
              ]),
              const SizedBox(height: 17),
              const _SearchField(),
              const SizedBox(height: 12),
              Expanded(child: SingleChildScrollView(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                GridView.count(
                  crossAxisCount: 2, shrinkWrap: true, physics: const NeverScrollableScrollPhysics(), childAspectRatio: 1.42, crossAxisSpacing: 10, mainAxisSpacing: 10,
                  children: [
                    const _CategoryCard(label: 'personajes', icon: Icons.groups_outlined, color: Color(0xFFFFEEE9)),
                    _CategoryCard(label: 'armas', icon: Icons.shield_outlined, color: const Color(0xFFFFF0D7), onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const WeaponsScreen()))),
                    const _CategoryCard(label: 'mapas', icon: Icons.map_outlined, color: Color(0xFFE0F5EF)),
                    const _CategoryCard(label: 'mecánicas', icon: Icons.settings_outlined, color: Color(0xFFEBEAFF)),
                  ],
                ),
                const SizedBox(height: 16),
                const Text('destacado', style: TextStyle(fontSize: 12, color: _muted)),
                const SizedBox(height: 8),
                InkWell(
                  borderRadius: BorderRadius.circular(12), onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const DetailScreen())),
                  child: Container(width: double.infinity, padding: const EdgeInsets.all(15), decoration: BoxDecoration(color: const Color(0xFFFFFCFB), borderRadius: BorderRadius.circular(12)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    const Align(alignment: Alignment.topRight, child: _Pill(text: 'x2 pts', color: Color(0xFFFFD475))),
                    const SizedBox(height: 16), const Text('pistola de dardos', style: TextStyle(fontWeight: FontWeight.w600, color: _ink)), const SizedBox(height: 4), const Text('Lorem ipsum dolor sit amet.', style: TextStyle(color: _muted, fontSize: 12)),
                  ])),
                ),
              ]))),
              const _BottomNavigation(active: 0),
            ]),
          ),
        ),
      );
}

class WeaponsScreen extends StatelessWidget {
  const WeaponsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final weapons = [
      ('spray y mechero', 'lanzallamas improvisado', Icons.local_fire_department_outlined, const Color(0xFFFFECD4)),
      ('aguja para coser', 'arma blanca básica', Icons.push_pin_outlined, const Color(0xFFFFEDE9)),
      ('pistola de dardos', 'ronda final, x2 puntos', Icons.gps_fixed, const Color(0xFFFFF0D7)),
      ('caja de galletas', 'curación mayor', Icons.link, const Color(0xFFE0F5EF)),
    ];
    return Scaffold(
      appBar: AppBar(leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => Navigator.pop(context)), title: const Text('armas', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16))),
      body: SafeArea(top: false, child: Padding(padding: const EdgeInsets.fromLTRB(22, 8, 22, 8), child: Column(children: [
        Expanded(child: ListView.separated(
          itemCount: weapons.length, separatorBuilder: (_, _) => const Divider(height: 1, color: Color(0xFFE8E2DE)),
          itemBuilder: (context, index) { final item = weapons[index]; return InkWell(onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const DetailScreen())), child: Padding(padding: const EdgeInsets.symmetric(vertical: 11), child: Row(children: [
            Container(width: 34, height: 34, decoration: BoxDecoration(color: item.$4, borderRadius: BorderRadius.circular(9)), child: Icon(item.$3, size: 18, color: _orange)), const SizedBox(width: 10),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(item.$1, style: const TextStyle(fontWeight: FontWeight.w600, color: _ink)), Text(item.$2, style: const TextStyle(fontSize: 12, color: _muted))])), const Icon(Icons.chevron_right, color: _muted),
          ]))); },
        )),
        const _BottomNavigation(active: 2),
      ]))),
    );
  }
}

class DetailScreen extends StatelessWidget {
  const DetailScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => Navigator.pop(context)), title: const Text('armas', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16))),
        body: SafeArea(top: false, child: Padding(padding: const EdgeInsets.fromLTRB(22, 12, 22, 22), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(height: 122, width: double.infinity, decoration: BoxDecoration(color: const Color(0xFFFFEEE9), borderRadius: BorderRadius.circular(12)), child: const Center(child: Icon(Icons.gps_fixed, size: 46, color: _orange))),
          const SizedBox(height: 15), const Text('pistola de dardos', style: TextStyle(fontSize: 19, fontWeight: FontWeight.w800, color: _ink)), const SizedBox(height: 8),
          const Row(children: [_Pill(text: 'x2 puntos', color: Color(0xFFFFD475)), SizedBox(width: 8), _Pill(text: '6 disparos', color: Color(0xFFF5F1EF))]),
          const SizedBox(height: 18), const Row(children: [_Stat(title: 'alto', caption: 'daño'), _Stat(title: 'medio', caption: 'alcance'), _Stat(title: 'limitada', caption: 'munición')]), const SizedBox(height: 20),
          const Text('Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed posuere lorem id quam interdum, a lobortis massa feugiat.', style: TextStyle(height: 1.45, color: _muted)),
          const Spacer(),
          OutlinedButton(onPressed: () => Navigator.pop(context), style: OutlinedButton.styleFrom(minimumSize: const Size.fromHeight(48), foregroundColor: _ink, side: const BorderSide(color: Color(0xFFD7CCC7)), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))), child: const Text('volver a la lista')),
        ])),
      );
}

class _SearchField extends StatelessWidget {
  const _SearchField();
  @override Widget build(BuildContext context) => Container(height: 42, decoration: BoxDecoration(border: Border.all(color: const Color(0xFFE5DFDB)), borderRadius: BorderRadius.circular(10)), child: const Row(children: [SizedBox(width: 12), Icon(Icons.search, size: 19, color: _muted), SizedBox(width: 8), Text('buscar armas, mapas...', style: TextStyle(color: _muted, fontSize: 13))]));
}

class _CategoryCard extends StatelessWidget {
  const _CategoryCard({required this.label, required this.icon, required this.color, this.onTap});
  final String label; final IconData icon; final Color color; final VoidCallback? onTap;
  @override Widget build(BuildContext context) => InkWell(onTap: onTap, borderRadius: BorderRadius.circular(11), child: Ink(decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(11)), child: Padding(padding: const EdgeInsets.all(10), child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.end, children: [Icon(icon, color: _orange, size: 20), const SizedBox(height: 6), Text(label, style: const TextStyle(fontSize: 12, color: _ink))]))));
}

class _Pill extends StatelessWidget {
  const _Pill({required this.text, required this.color}); final String text; final Color color;
  @override Widget build(BuildContext context) => Container(padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4), decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(20)), child: Text(text, style: const TextStyle(fontSize: 11, color: _ink)));
}

class _Stat extends StatelessWidget {
  const _Stat({required this.title, required this.caption}); final String title; final String caption;
  @override Widget build(BuildContext context) => Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(fontWeight: FontWeight.w800, color: _ink)), Text(caption, style: const TextStyle(fontSize: 11, color: _muted))]));
}

class _BottomNavigation extends StatelessWidget {
  const _BottomNavigation({required this.active}); final int active;
  @override Widget build(BuildContext context) { const icons = [Icons.home_outlined, Icons.groups_outlined, Icons.shield_outlined, Icons.map_outlined]; return SizedBox(height: 54, child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: List.generate(icons.length, (index) => Icon(icons[index], color: index == active ? _orange : const Color(0xFF8D8D8D), size: 22)))); }
}
