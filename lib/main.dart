import 'package:flutter/material.dart';

void main() => runApp(const BastardososWikiApp());

class BastardososWikiApp extends StatelessWidget {
  const BastardososWikiApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Bearstards Wiki',
        theme: ThemeData(useMaterial3: true, fontFamily: 'Arial'),
        home: const HomeScreen(),
      );
}

abstract final class C {
  static const ink = Color(0xff1b1030), night = Color(0xff241a55), night2 = Color(0xff34248a);
  static const paper = Color(0xfffffaf0), cream = Color(0xfffff3d6), sun = Color(0xffffd23f);
  static const pink = Color(0xffff5fa2), sky = Color(0xff3ec6ff), mint = Color(0xff5be3b0), orange = Color(0xffff8a3d);
}

abstract final class A {
  static const base = 'assets/images/mvp/';
  static const lowPolyBase = 'assets/images/wiki_low_poly/';
  static const background = '${lowPolyBase}background_toy_warehouse_night.png';
  static const homeBackground = '${lowPolyBase}background_toy_warehouse_night.png';
  static const homeBear = '${lowPolyBase}bear_hero_behind_crates.png';
  static const playerBear = '${lowPolyBase}bear_player_fullbody.png';
  static const npcBear = '${lowPolyBase}bear_npc_fullbody.png';
  static const homeCrates = '${lowPolyBase}hero_foreground_crates.png';
  static const homeSign = '${lowPolyBase}logo_hanging_sign.png';
  static const homeCharacters = '${lowPolyBase}home_card_characters.png';
  static const homeStealth = '${lowPolyBase}home_card_stealth.png';
  static const mechanicWalk = '${lowPolyBase}mechanic_walk_safe.png';
  static const mechanicRun = '${lowPolyBase}mechanic_run_detected.png';
  static const mechanicJump = '${lowPolyBase}mechanic_jump_detected.png';
  static const mechanicWeapon = '${lowPolyBase}mechanic_weapon_detected.png';
  static const mapToyStore = '${lowPolyBase}map_toy_store_three_aisles.png';
  static const phaseLightsOff = '${lowPolyBase}phase_lights_off.png';
  static const phaseNewStock = '${lowPolyBase}phase_new_stock.png';
  static const phaseFinalSale = '${lowPolyBase}phase_final_sale.png';
  static const weaponDartBlaster = '${lowPolyBase}weapon_dart_blaster.png';
  static const logo = '${base}logo_bearstards_light.png';
  static const player = '${base}bear_player.png';
  static const npc = '${base}bear_npc.png';
  static const emptySearch = '${base}empty_state_search.png';
  static const back = '${base}icon_back.png';
  static const navHome = '${base}icon_nav_home.png';
  static String category(String value) => switch (value) {
    'personajes' => '${base}icon_category_characters.png',
    'armas' => '${base}icon_category_weapons.png',
    'objetos' => '${base}icon_category_items.png',
    'mapas' => '${base}icon_category_maps.png',
    _ => '${base}icon_category_mechanics.png',
  };
  static String entry(Entry value) => switch (value.title) {
    'osos NPC' => homeBear,
    'aguja para coser' => '${lowPolyBase}weapon_sewing_needle.png',
    'pistola de dardos' => '${lowPolyBase}weapon_dart_blaster.png',
    'casco' => '${lowPolyBase}item_helmet.png',
    'rollo de hilo' => '${lowPolyBase}item_thread_spool.png',
    'La Juguetería' => '${lowPolyBase}map_toy_store_three_aisles.png',
    'camuflaje y acciones delatoras' => '${lowPolyBase}mechanic_walk_safe.png',
    'vida, combate y respawn' => homeBear,
    _ => '${lowPolyBase}phase_lights_off.png',
  };
}

class Entry {
  const Entry(this.title, this.subtitle, this.category, this.icon, this.color, this.tags, this.body, this.tip);
  final String title, subtitle, category, body, tip;
  final IconData icon;
  final Color color;
  final List<String> tags;
}

const entries = <Entry>[
  Entry('osos NPC', 'camuflaje, rutina y sospechas', 'personajes', Icons.face_6_rounded, C.sky, ['camuflaje', 'observa patrones'], 'Los NPC recorren La Juguetería con movimientos repetidos. Mezclarte con ellos ayuda a ocultar tu identidad, pero una acción fuera de rutina puede delatarte.', 'Imita el ritmo de los NPC antes de intentar sorprender a otro jugador.'),
  Entry('aguja para coser', 'arma cuerpo a cuerpo: 25 de daño', 'armas', Icons.push_pin_rounded, C.pink, ['25 daño', 'cuerpo a cuerpo'], 'La aguja es el arma del MVP para un enfrentamiento cercano. Cada golpe causa 25 de daño.', 'Acércate sin correr para reducir las sospechas antes de atacar.'),
  Entry('pistola de dardos', '50 de daño, 6 disparos y aparece en fase 2', 'armas', Icons.gps_fixed_rounded, C.sun, ['50 daño', '6 disparos', 'fase 2'], 'La pistola de dardos aparece durante Mercancía nueva. Tiene seis disparos y cada uno hace 50 de daño.', 'No malgastes dardos: solo tienes seis oportunidades antes de quedarte sin munición.'),
  Entry('casco', '+25 de vida y no es visible', 'objetos', Icons.health_and_safety_rounded, C.sky, ['vida máxima 125', 'oculto'], 'El casco aumenta tu vida en 25 puntos. Como no se ve en el personaje, tus rivales no sabrán que lo llevas.', 'Con casco puedes llegar a 125 de vida; úsalo para resistir un intercambio inesperado.'),
  Entry('rollo de hilo', 'recupera 25 puntos de vida', 'objetos', Icons.auto_awesome_rounded, C.mint, ['cura 25', 'recuperación'], 'El rollo de hilo restaura 25 puntos de vida. Es un recurso para recuperarte y seguir en la ronda.', 'Úsalo cuando tengas un momento seguro; curarte mientras te observan puede exponerte.'),
  Entry('La Juguetería', 'un mapa de tres pasillos', 'mapas', Icons.toys_rounded, C.mint, ['3 pasillos', 'rutas', 'NPCs'], 'La partida ocurre en La Juguetería. Sus tres pasillos crean rutas de encuentro, escape y observación entre los osos NPC.', 'Aprende por dónde pasan los NPC: esas rutas son tu mejor cobertura.'),
  Entry('camuflaje y acciones delatoras', 'correr, brincar o portar un arma revela pistas', 'mecánicas', Icons.visibility_rounded, C.pink, ['caminar', 'correr', 'brincar', 'portar arma'], 'Caminar sin arma ayuda a confundirte con los NPC. Correr, brincar y portar un arma son acciones delatoras: otros jugadores pueden descubrirte.', 'Caminar y observar suele ser más seguro que actuar sin necesidad.'),
];

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Night(child: SafeArea(child: HomeLanding())),
      );
}

class HomeLanding extends StatelessWidget {
  const HomeLanding({super.key});

  @override
  Widget build(BuildContext context) => LayoutBuilder(
        builder: (context, constraints) {
          final heroHeight = (constraints.maxHeight * .49).clamp(300.0, 405.0).toDouble();
          return Semantics(
            label: 'Portada de Bearstards Wiki',
            image: true,
            child: Stack(children: [
              Positioned(left: 0, top: 0, right: 0, height: heroHeight, child: const HomeHeroScene()),
              Positioned(
                left: 14,
                right: 14,
                top: heroHeight - 16,
                bottom: 12,
                child: GridView.count(
                  padding: EdgeInsets.zero,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  childAspectRatio: .94,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  children: const [
                    HomeCategory('Personajes', A.homeCharacters, Color(0xffff9db2), 1),
                    HomeCategory('Sigilo', A.homeStealth, Color(0xffffdc58), 1),
                    HomeCategory('Arsenal', A.weaponDartBlaster, Color(0xff5de2e8), 3),
                    HomeCategory('La Juguetería', A.mapToyStore, Color(0xffd7adf2), 4),
                  ],
                ),
              ),
            ]),
          );
        },
      );
}

const navLabels = ['inicio', 'sigilo', 'objetos', 'arsenal', 'mapa'];

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({super.key, required this.category}); final String category;
  @override Widget build(BuildContext context) {
    final list = entries.where((e) => e.category == category).toList();
    return Scaffold(body: Night(child: SafeArea(child: Column(children: [
      TopBar(category == 'armas' ? 'arsenal' : category),
      Expanded(child: ListView(padding: const EdgeInsets.fromLTRB(20, 10, 20, 22), children: [CategoryHeader(category, list.length), const SizedBox(height: 20), ...list.map((e) => Padding(padding: const EdgeInsets.only(bottom: 12), child: EntryCard(e)))])),
      Bottom(active: 0, onTap: (i) => navigateBottom(context, i)),
    ]))));
  }
}

class DetailScreen extends StatelessWidget {
  const DetailScreen({super.key, required this.entry}); final Entry entry;
  @override Widget build(BuildContext context) => Scaffold(body: Night(child: SafeArea(child: Column(children: [
    TopBar(entry.category),
    Expanded(child: ListView(padding: const EdgeInsets.fromLTRB(20,8,20,28), children: [DetailHero(entry), const SizedBox(height: 20), Article(entry)])),
  ]))));
}

class StealthGuideScreen extends StatelessWidget {
  const StealthGuideScreen({super.key});
  @override Widget build(BuildContext context) => Scaffold(body: Night(child: SafeArea(child: Column(children: [
    const TopBar('sigilo'),
    Expanded(child: ListView(padding: const EdgeInsets.fromLTRB(20, 8, 20, 28), children: [
      const StealthIdentityCard(), const SizedBox(height: 16),
      GridView.count(crossAxisCount: 2, shrinkWrap: true, physics: const NeverScrollableScrollPhysics(), childAspectRatio: .92, crossAxisSpacing: 12, mainAxisSpacing: 12, children: const [
        StealthTile('caminar sin armas', A.mechanicWalk, C.mint, true),
        StealthTile('correr te delata', A.mechanicRun, C.pink, false),
        StealthTile('saltar te delata', A.mechanicJump, C.pink, false),
        StealthTile('llevar un arma te delata', A.mechanicWeapon, C.pink, false),
      ]),
    ])),
    Bottom(active: 1, onTap: (i) => navigateBottom(context, i)),
  ]))));
}

class MapGuideScreen extends StatelessWidget {
  const MapGuideScreen({super.key});
  @override Widget build(BuildContext context) => Scaffold(body: Night(child: SafeArea(child: Column(children: [
    const TopBar('La Juguetería'),
    Expanded(child: ListView(padding: const EdgeInsets.fromLTRB(20, 8, 20, 28), children: const [
      Toon(color: C.paper, padding: EdgeInsets.all(12), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        SizedBox(height: 230, width: double.infinity, child: Image(image: AssetImage(A.mapToyStore), fit: BoxFit.contain)),
        SizedBox(height: 10), Text('tres pasillos para perderte', style: TextStyle(fontSize: 21, fontWeight: FontWeight.w900, color: C.ink)),
        SizedBox(height: 6), Text('Las estanterías bloquean la vista y crean rutas para moverte sin levantar sospechas.', style: TextStyle(height: 1.25, fontWeight: FontWeight.w600)),
      ])),
      SizedBox(height: 16), PhaseStrip(),
    ])),
    Bottom(active: 4, onTap: (i) => navigateBottom(context, i)),
  ]))));
}

class ArsenalGuideScreen extends StatelessWidget {
  const ArsenalGuideScreen({super.key});
  @override Widget build(BuildContext context) => Scaffold(body: Night(child: SafeArea(child: Column(children: [
    const TopBar('arsenal'),
    Expanded(child: ListView(padding: const EdgeInsets.fromLTRB(20, 8, 20, 28), children: [
      ArsenalWeaponCard(entry: entries[1], imageHeight: 150),
      const SizedBox(height: 16),
      ArsenalWeaponCard(entry: entries[2], imageHeight: 172),
    ])),
    Bottom(active: 3, onTap: (i) => navigateBottom(context, i)),
  ]))));
}

class ObjectsGuideScreen extends StatelessWidget {
  const ObjectsGuideScreen({super.key});
  @override Widget build(BuildContext context) => Scaffold(body: Night(child: SafeArea(child: Column(children: [
    const TopBar('objetos'),
    Expanded(child: ListView(padding: const EdgeInsets.fromLTRB(20, 8, 20, 28), children: [
      const GuideIntro('objetos del mapa', 'Encuentra estos recursos entre las estanterías. Ambos forman parte del MVP.'),
      const SizedBox(height: 16),
      ObjectGuideCard(entry: entries[3]),
      const SizedBox(height: 16),
      ObjectGuideCard(entry: entries[4]),
    ])),
    Bottom(active: 2, onTap: (i) => navigateBottom(context, i)),
  ]))));
}

class Night extends StatelessWidget {
  const Night({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) => Container(
        color: C.night,
        child: Stack(children: [
          Positioned.fill(child: Opacity(opacity: .72, child: Image.asset(A.background, fit: BoxFit.cover))),
          Positioned.fill(child: ColoredBox(color: C.ink.withValues(alpha: .18))),
          child,
        ]),
      );
}
class Dots extends CustomPainter { const Dots(); @override void paint(Canvas c, Size s) { final p=Paint()..color=C.cream.withValues(alpha:.2); for(double x=18;x<s.width;x+=38){for(double y=12;y<s.height;y+=38){c.drawCircle(Offset(x,y),1.4,p);}}} @override bool shouldRepaint(Dots old)=>false; }
class HomeHeroScene extends StatelessWidget {
  const HomeHeroScene({super.key});

  @override
  Widget build(BuildContext context) => Stack(fit: StackFit.expand, clipBehavior: Clip.none, children: [
        Positioned(top: 0, left: 20, right: 20, height: 138, child: Image.asset(A.homeSign, fit: BoxFit.contain)),
        Positioned(top: 108, left: 14, right: 14, bottom: -6, child: Image.asset(A.homeBear, fit: BoxFit.contain, alignment: Alignment.bottomCenter)),
        Positioned(left: -8, right: -8, bottom: -2, height: 112, child: Image.asset(A.homeCrates, fit: BoxFit.fill, alignment: Alignment.bottomCenter)),
      ]);
}
class Brand extends StatelessWidget { const Brand({super.key}); @override Widget build(BuildContext context) => Row(children: [Expanded(child:Image.asset(A.logo,height:62,alignment:Alignment.centerLeft,fit:BoxFit.contain)),const SizedBox(width:8),const Chip('GUÍA',C.sun)]); }
class Hero extends StatelessWidget { const Hero({super.key}); @override Widget build(BuildContext context) => Toon(color:C.sun,padding:const EdgeInsets.all(20),child:Row(children:[const Expanded(child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[Chip('GUÍA DEL MVP',C.pink),SizedBox(height:12),Text('¿cómo se gana?',style:TextStyle(fontSize:28,height:1,fontWeight:FontWeight.w900,color:C.ink)),SizedBox(height:8),Text('Aprende fases, sigilo y objetos antes de entrar a La Juguetería.',style:TextStyle(height:1.3,fontWeight:FontWeight.w600))])),const SizedBox(width:12),SizedBox(width:92,height:92,child:Image(image:AssetImage(A.player),fit:BoxFit.contain))])); }
class Search extends StatelessWidget { const Search({super.key,required this.onChanged}); final ValueChanged<String> onChanged; @override Widget build(BuildContext context)=>Semantics(textField:true,label:'Buscar en la wiki',child:TextField(onChanged:onChanged,style:const TextStyle(color:C.ink,fontWeight:FontWeight.w600),decoration:InputDecoration(hintText:'buscar fases, objetos, armas…',hintStyle:const TextStyle(color:Color(0xff655b71),fontWeight:FontWeight.w600),prefixIcon:Padding(padding:const EdgeInsets.all(10),child:Image.asset('${A.base}icon_nav_search.png')),filled:true,fillColor:C.paper,contentPadding:const EdgeInsets.symmetric(vertical:16),enabledBorder:outline(C.ink),focusedBorder:outline(C.sun,w:4)))); }
class HomeCategory extends StatelessWidget {
  const HomeCategory(this.label, this.asset, this.color, this.destination, {super.key});
  final String label;
  final String asset;
  final Color color;
  final int destination;

  @override
  Widget build(BuildContext context) => Semantics(
        button: true,
        label: 'Explorar $label',
        child: Press(
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => guideFor(destination))),
          child: Container(
            decoration: BoxDecoration(
              color: color,
              border: Border.all(color: C.ink, width: 4),
              borderRadius: BorderRadius.circular(18),
              boxShadow: const [BoxShadow(color: C.ink, offset: Offset(3, 4))],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Stack(children: [
                Positioned.fill(child: ColoredBox(color: color)),
                Positioned.fill(child: Opacity(opacity: .98, child: Image.asset(asset, fit: label == 'La Juguetería' ? BoxFit.cover : BoxFit.contain))),
                Positioned(
                  left: 7,
                  right: 7,
                  bottom: 7,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 7),
                    decoration: BoxDecoration(color: C.paper, borderRadius: BorderRadius.circular(10), border: Border.all(color: C.ink, width: 2)),
                    child: Row(children: [
                      Expanded(child: Text(label, style: display(18))),
                      const Icon(Icons.arrow_forward_ios_rounded, color: C.ink, size: 16),
                    ]),
                  ),
                ),
              ]),
            ),
          ),
        ),
      );
}
class Feature extends StatelessWidget { const Feature(this.entry,{super.key}); final Entry entry; @override Widget build(BuildContext context)=>Press(onTap:()=>Navigator.push(context,MaterialPageRoute(builder:(_)=>DetailScreen(entry:entry))),child:Toon(color:C.paper,child:Row(children:[EntryIcon(entry,70),const SizedBox(width:14),Expanded(child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[const Chip('NO TE LO PIERDAS',C.sun),const SizedBox(height:8),Text(entry.title,style:display(21)),const SizedBox(height:4),Text(entry.subtitle,style:const TextStyle(height:1.2,fontWeight:FontWeight.w600))]))]))); }
class EntryCard extends StatelessWidget { const EntryCard(this.entry,{super.key}); final Entry entry; @override Widget build(BuildContext context)=>Press(onTap:()=>Navigator.push(context,MaterialPageRoute(builder:(_)=>DetailScreen(entry:entry))),child:Toon(color:C.paper,padding:const EdgeInsets.all(14),child:Row(children:[EntryIcon(entry,58),const SizedBox(width:12),Expanded(child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[Text(entry.category.toUpperCase(),style:const TextStyle(fontSize:11,fontWeight:FontWeight.w900,letterSpacing:1.1,color:Color(0xff655b71))),Text(entry.title,style:display(19)),const SizedBox(height:3),Text(entry.subtitle,maxLines:2,overflow:TextOverflow.ellipsis,style:const TextStyle(fontSize:13,height:1.2,fontWeight:FontWeight.w600))])),const Icon(Icons.arrow_forward_rounded,color:C.ink)]))); }
class CategoryHeader extends StatelessWidget { const CategoryHeader(this.category,this.count,{super.key}); final String category; final int count; @override Widget build(BuildContext context) { const cs={'personajes':C.sky,'armas':C.orange,'objetos':C.mint,'mapas':C.sky,'mecánicas':C.pink};return Toon(color:cs[category]!,padding:const EdgeInsets.all(20),child:Row(children:[SizedBox(width:58,height:58,child:Image.asset(A.category(category))),const SizedBox(width:16),Expanded(child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[Text(category=='armas'?'arsenal':category,style:display(30)),Text('$count ${count==1?'entrada':'entradas'} para investigar',style:const TextStyle(fontWeight:FontWeight.w700))]))]));} }
class DetailHero extends StatelessWidget { const DetailHero(this.entry,{super.key}); final Entry entry; @override Widget build(BuildContext context)=>Toon(color:C.paper,padding:const EdgeInsets.all(14),child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[SizedBox(height:entry.title=='La Juguetería'?190:170,width:double.infinity,child:ClipRRect(borderRadius:BorderRadius.circular(14),child:Image.asset(A.entry(entry),fit:BoxFit.contain,alignment:Alignment.center))),const SizedBox(height:14),Chip(entry.category.toUpperCase(),entry.color),const SizedBox(height:12),Text(entry.title,style:display(32)),const SizedBox(height:6),Text(entry.subtitle,style:const TextStyle(fontSize:16,height:1.25,fontWeight:FontWeight.w700))])); }
class Article extends StatelessWidget { const Article(this.entry,{super.key}); final Entry entry; @override Widget build(BuildContext context)=>Toon(color:C.paper,padding:const EdgeInsets.all(20),child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[Text('datos clave',style:display(24)),const SizedBox(height:12),Wrap(spacing:8,runSpacing:8,children:entry.tags.map((e)=>Chip(e.toUpperCase(),C.cream)).toList()),const SizedBox(height:22),Text('¿qué debes saber?',style:display(21)),const SizedBox(height:8),Text(entry.body,style:const TextStyle(fontSize:15,height:1.45,fontWeight:FontWeight.w600)),const SizedBox(height:20),const Divider(height:1,thickness:2,color:Color(0x331b1030)),const SizedBox(height:16),Row(children:[const Icon(Icons.lightbulb_rounded,color:C.orange),const SizedBox(width:8),Expanded(child:Text('Consejo: ${entry.tip}',style:display(17)))]) ])); }
class GuideIntro extends StatelessWidget { const GuideIntro(this.title,this.body,{super.key}); final String title,body; @override Widget build(BuildContext context)=>Toon(color:C.sun,padding:const EdgeInsets.all(18),child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[Text(title,style:display(27)),const SizedBox(height:7),Text(body,style:const TextStyle(fontSize:15,height:1.25,fontWeight:FontWeight.w700))])); }
class ArsenalWeaponCard extends StatelessWidget {
  const ArsenalWeaponCard({super.key, required this.entry, required this.imageHeight});
  final Entry entry;
  final double imageHeight;

  @override
  Widget build(BuildContext context) => Press(
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => DetailScreen(entry: entry))),
        child: Toon(
          color: entry.color,
          padding: const EdgeInsets.all(15),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(entry.title, style: display(27)),
            const SizedBox(height: 6),
            Text(entry.subtitle, style: const TextStyle(fontSize: 14, height: 1.2, fontWeight: FontWeight.w700)),
            SizedBox(height: imageHeight, width: double.infinity, child: Image.asset(A.entry(entry), fit: BoxFit.contain)),
            Wrap(spacing: 7, runSpacing: 7, children: entry.tags.map((tag) => Chip(tag.toUpperCase(), C.paper)).toList()),
          ]),
        ),
      );
}

class ObjectGuideCard extends StatelessWidget {
  const ObjectGuideCard({super.key, required this.entry});
  final Entry entry;

  @override
  Widget build(BuildContext context) => Press(
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => DetailScreen(entry: entry))),
        child: Toon(
          color: C.paper,
          padding: const EdgeInsets.all(14),
          child: Row(children: [
            SizedBox(width: 132, height: 142, child: Image.asset(A.entry(entry), fit: BoxFit.contain)),
            const SizedBox(width: 10),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Chip(entry.title == 'casco' ? 'VIDA MÁXIMA 125' : 'CURA 25', entry.color),
              const SizedBox(height: 9),
              Text(entry.title, style: display(26)),
              const SizedBox(height: 7),
              Text(entry.body, style: const TextStyle(fontSize: 13, height: 1.25, fontWeight: FontWeight.w600)),
              const SizedBox(height: 10),
              const Text('toca para consultar  →', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w900, color: C.night2)),
            ])),
          ]),
        ),
      );
}
class EntryIcon extends StatelessWidget { const EntryIcon(this.entry,this.size,{super.key}); final Entry entry; final double size; @override Widget build(BuildContext context)=>Container(width:size,height:size,padding:const EdgeInsets.all(3),decoration:BoxDecoration(color:entry.color,border:Border.all(color:C.ink,width:2.5),borderRadius:BorderRadius.circular(16)),child:Image.asset(A.entry(entry),fit:BoxFit.contain)); }
class TopBar extends StatelessWidget { const TopBar(this.title,{super.key}); final String title; @override Widget build(BuildContext context)=>Container(margin:const EdgeInsets.fromLTRB(14,10,14,8),padding:const EdgeInsets.symmetric(horizontal:4,vertical:4),decoration:BoxDecoration(color:C.cream,border:Border.all(color:C.ink,width:3),borderRadius:BorderRadius.circular(12)),child:Row(children:[IconButton(tooltip:'Volver',onPressed:()=>Navigator.pop(context),icon:const Icon(Icons.arrow_back_rounded,color:C.ink)),Expanded(child:Text(title=='mecánicas'?'sigilo':title=='armas'?'arsenal':title,style:display(25),textAlign:TextAlign.center)),const SizedBox(width:48)])); }
class Bottom extends StatelessWidget { const Bottom({super.key,required this.active,required this.onTap}); final int active; final ValueChanged<int> onTap; @override Widget build(BuildContext context){const icons=[A.navHome,'assets/images/mvp/icon_category_mechanics.png','assets/images/mvp/icon_category_items.png','assets/images/mvp/icon_category_weapons.png','assets/images/mvp/icon_category_maps.png'];return Container(margin:const EdgeInsets.fromLTRB(12,0,12,14),padding:const EdgeInsets.symmetric(vertical:6),decoration:BoxDecoration(color:C.paper,border:Border.all(color:C.ink,width:3),borderRadius:BorderRadius.circular(20),boxShadow:const[BoxShadow(color:C.ink,offset:Offset(4,4))]),child:Row(mainAxisAlignment:MainAxisAlignment.spaceAround,children:List.generate(navLabels.length,(i){final label=navLabels[i];final selected=i==active;return Semantics(selected:selected,label:label,button:true,child:InkWell(borderRadius:BorderRadius.circular(14),onTap:()=>onTap(i),child:Container(constraints:const BoxConstraints(minWidth:48,minHeight:48),padding:const EdgeInsets.symmetric(horizontal:5,vertical:5),decoration:BoxDecoration(color:selected?C.sun:Colors.transparent,borderRadius:BorderRadius.circular(13)),child:Column(mainAxisSize:MainAxisSize.min,children:[SizedBox(width:22,height:22,child:Image.asset(icons[i],fit:BoxFit.contain)),Text(label,style:TextStyle(fontSize:9,fontWeight:selected?FontWeight.w900:FontWeight.w700,color:C.ink))]))));})));} }
class Toon extends StatelessWidget { const Toon({super.key,required this.child,required this.color,this.padding=const EdgeInsets.all(16)}); final Widget child; final Color color; final EdgeInsetsGeometry padding; @override Widget build(BuildContext context)=>Container(padding:padding,decoration:BoxDecoration(color:color,border:Border.all(color:C.ink,width:3),borderRadius:BorderRadius.circular(22),boxShadow:const[BoxShadow(color:C.ink,offset:Offset(5,5))]),child:child); }
class Chip extends StatelessWidget { const Chip(this.label,this.color,{super.key}); final String label; final Color color; @override Widget build(BuildContext context)=>Container(padding:const EdgeInsets.symmetric(horizontal:9,vertical:5),decoration:BoxDecoration(color:color,border:Border.all(color:C.ink,width:2),borderRadius:BorderRadius.circular(99)),child:Text(label,style:const TextStyle(fontSize:10,height:1,fontWeight:FontWeight.w900,color:C.ink,letterSpacing:.6))); }
class Bear extends StatelessWidget { const Bear(this.size,{super.key}); final double size; @override Widget build(BuildContext context)=>SizedBox(width:size,height:size,child:Image.asset(A.player,fit:BoxFit.contain)); }
class Heading extends StatelessWidget { const Heading(this.title,this.caption,{super.key}); final String title,caption; @override Widget build(BuildContext context)=>Row(crossAxisAlignment:CrossAxisAlignment.end,children:[Expanded(child:Text(title,style:display(25,color:C.paper))),Padding(padding:const EdgeInsets.only(bottom:3),child:Text(caption,style:const TextStyle(color:C.cream,fontSize:11,fontWeight:FontWeight.w800)))]); }
class EmptySearch extends StatelessWidget { const EmptySearch({super.key}); @override Widget build(BuildContext context)=>Toon(color:C.cream,child:Column(children:[SizedBox(height:118,child:Image.asset(A.emptySearch,fit:BoxFit.contain)),const SizedBox(height:8),const Text('ningún oso encontró esa pista',style:TextStyle(fontWeight:FontWeight.w900,color:C.ink))])); }
class StealthIdentityCard extends StatelessWidget { const StealthIdentityCard({super.key}); @override Widget build(BuildContext context)=>Toon(color:C.paper,padding:const EdgeInsets.all(12),child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[Text('jugador vs NPC',style:display(24)),const SizedBox(height:5),const Text('Ambos se ven parecidos. Tus acciones revelan quién controlas.',style:TextStyle(fontSize:13,fontWeight:FontWeight.w700)),const SizedBox(height:9),Row(children:[Expanded(child:Column(children:[SizedBox(height:122,child:Image.asset(A.playerBear,fit:BoxFit.contain)),const Chip('OSO JUGADOR',C.pink)])),Container(width:2,height:124,color:C.ink),Expanded(child:Column(children:[SizedBox(height:122,child:Image.asset(A.npcBear,fit:BoxFit.contain)),const Chip('OSO NPC',C.sky)]))]) ])); }
class StealthTile extends StatelessWidget { const StealthTile(this.label,this.path,this.color,this.safe,{super.key}); final String label,path; final Color color; final bool safe; @override Widget build(BuildContext context)=>Toon(color:color,padding:const EdgeInsets.all(9),child:Column(children:[Align(alignment:Alignment.topRight,child:Icon(safe?Icons.check_circle:Icons.error_rounded,color:C.ink,size:22)),Expanded(child:Image.asset(path,fit:BoxFit.contain)),Text(label,textAlign:TextAlign.center,style:const TextStyle(fontSize:13,height:1,fontWeight:FontWeight.w900,color:C.ink))])); }
class PhaseStrip extends StatelessWidget { const PhaseStrip({super.key}); @override Widget build(BuildContext context){const items=[('luces apagadas',A.phaseLightsOff),('mercancía nueva',A.phaseNewStock),('remate final',A.phaseFinalSale)];return Toon(color:C.cream,padding:const EdgeInsets.all(10),child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[Text('fases de la tienda',style:display(22)),const SizedBox(height:10),Row(children:items.map((item)=>Expanded(child:Column(children:[AspectRatio(aspectRatio:1.2,child:Image.asset(item.$2,fit:BoxFit.contain)),Text(item.$1,textAlign:TextAlign.center,style:const TextStyle(fontSize:10,height:1,fontWeight:FontWeight.w900))]))).toList())]));} }
class Press extends StatelessWidget { const Press({super.key,required this.child,required this.onTap}); final Widget child; final VoidCallback onTap; @override Widget build(BuildContext context)=>Material(color:Colors.transparent,child:InkWell(borderRadius:BorderRadius.circular(22),onTap:onTap,child:child)); }
Widget guideFor(int i) => switch (i) {1 => const StealthGuideScreen(),2 => const ObjectsGuideScreen(),3 => const ArsenalGuideScreen(),4 => const MapGuideScreen(),_ => const HomeScreen()};
void navigateBottom(BuildContext context,int i){if(i==0){Navigator.popUntil(context,(route)=>route.isFirst);}else{Navigator.pushReplacement(context,MaterialPageRoute(builder:(_)=>guideFor(i)));}}
OutlineInputBorder outline(Color color,{double w=3})=>OutlineInputBorder(borderRadius:BorderRadius.circular(18),borderSide:BorderSide(color:color,width:w));
TextStyle display(double size,{Color color=C.ink,double? spacing})=>TextStyle(fontSize:size,height:.95,fontWeight:FontWeight.w900,letterSpacing:spacing,color:color);
