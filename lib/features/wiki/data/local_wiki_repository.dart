import '../domain/models/match_phase.dart';
import '../domain/models/stealth_action.dart';
import '../domain/models/wiki_entry.dart';
import '../domain/repositories/wiki_repository.dart';

/// The wiki describes the intended MVP rules, not live match state.
class LocalWikiRepository implements WikiRepository {
  const LocalWikiRepository();

  @override
  List<WikiEntry> entriesFor(EntryCategory category) =>
      List.unmodifiable(_entries.where((entry) => entry.category == category));

  @override
  WikiEntry entry(EntryId id) => _entries.firstWhere((entry) => entry.id == id);

  static const _entries = [
    WikiEntry(
      id: EntryId.needle,
      category: EntryCategory.weapons,
      title: 'Aguja de coser',
      summary: 'Silenciosa. Cercana. Decisiva.',
      description: 'El arma de costura para el cuerpo a cuerpo. Cada impacto al cuerpo resta 25 puntos de vida.',
      stats: [WikiStat('DAÑO', '25'), WikiStat('ALCANCE', 'Cuerpo a cuerpo')],
      rules: [
        '4 golpes al cuerpo eliminan a un rival sin casco; 5 si tiene casco.',
        'Un golpe a la cabeza elimina al instante, incluso con casco.',
        'Eliminar al rival suma 200 puntos, o 350 con sigilo: el atacante queda fuera de su campo de visión en el golpe final.',
        'Un impacto elimina a un NPC y resta 50 puntos.',
      ],
      tip: 'Observa la rutina de los osos antes de acercarte. Portar la aguja revela que eres un jugador.',
    ),
    WikiEntry(
      id: EntryId.dartBlaster,
      category: EntryCategory.weapons,
      title: 'Pistola de dardos',
      summary: 'Seis oportunidades. Elige bien.',
      description: 'Aparece una sola vez al comenzar Mercancía nueva. Cada dardo avanza en línea recta y causa 50 de daño.',
      stats: [
        WikiStat('DAÑO', '50'),
        WikiStat('DARDOS', '6'),
        WikiStat('APARECE', 'Fase 2'),
      ],
      rules: [
        '2 impactos al cuerpo eliminan a un rival sin casco; 3 si tiene casco.',
        'Un impacto a la cabeza elimina al instante.',
        'Tiene 6 dardos y no se recarga. Al agotarse queda vacía.',
        'Eliminar al rival suma 400 puntos. Impactar a un NPC lo elimina y resta 50.',
      ],
      tip: 'Guarda tus disparos para un objetivo identificado. Los NPC nunca llevan armas.',
    ),
    WikiEntry(
      id: EntryId.helmet,
      category: EntryCategory.objects,
      title: 'Casco',
      summary: 'Protección que pasa desapercibida.',
      description: 'Aumenta la vida máxima en 25 puntos, hasta 125. Su efecto solo se muestra en tu indicador de vida.',
      stats: [WikiStat('VIDA MÁXIMA', '125'), WikiStat('APARIENCIA', 'Oculto')],
      rules: [
        'No cambia la apariencia del oso frente al rival.',
        'No se acumula: si ya tienes casco, otro permanece en el escenario.',
        'Se pierde al ser eliminado. Al reaparecer vuelves a 100 de vida.',
        'No evita la eliminación instantánea por un impacto a la cabeza.',
      ],
      tip: 'Te permite resistir un golpe más al cuerpo; sigue cuidando tus movimientos.',
    ),
    WikiEntry(
      id: EntryId.threadSpool,
      category: EntryCategory.objects,
      title: 'Rollo de hilo',
      summary: 'Un remiendo para seguir en pie.',
      description: 'Recupera 25 puntos de vida al recogerlo, sin superar tu vida máxima. La vida no se regenera sola.',
      stats: [WikiStat('RECUPERA', '+25'), WikiStat('USO', 'Inmediato')],
      rules: [
        'Se utiliza en el momento de recogerlo.',
        'Con la vida completa no se recoge y permanece en el escenario.',
        'Es la única forma de recuperar vida durante la partida.',
        'Su efecto no cambia la apariencia del oso.',
      ],
      tip: 'Localiza los rollos entre las estanterías para saber dónde recuperarte cuando lo necesites.',
    ),
  ];

  @override
  List<StealthAction> get stealthActions => const [
    StealthAction(
      id: StealthActionId.walk,
      label: 'Caminar sin armas',
      description: 'Te mezclas con la rutina de los NPC. Caminar sin un arma visible dificulta que el rival te identifique.',
      discreet: true,
    ),
    StealthAction(
      id: StealthActionId.run,
      label: 'Correr te delata',
      description: 'El movimiento apresurado rompe la rutina de los NPC y da una pista de que un jugador controla al oso.',
      discreet: false,
    ),
    StealthAction(
      id: StealthActionId.jump,
      label: 'Saltar te delata',
      description: 'Brincar es una acción delatora: rompe el patrón de movimiento de los NPC.',
      discreet: false,
    ),
    StealthAction(
      id: StealthActionId.weapon,
      label: 'Llevar un arma',
      description: 'Los NPC nunca llevan armas. Mostrar una aguja o una pistola permite distinguir al jugador.',
      discreet: false,
    ),
  ];

  @override
  List<MatchPhase> get phases => const [
    MatchPhase(
      id: PhaseId.lightsOff,
      title: 'Luces apagadas',
      period: 'Primer tercio',
      description: 'La tienda comienza con iluminación reducida.',
      advice: 'Observa los pasillos y aprende el ritmo de los osos.',
    ),
    MatchPhase(
      id: PhaseId.newStock,
      title: 'Mercancía nueva',
      period: 'Segundo tercio',
      description: 'Aparece una sola vez la pistola de dardos, con 6 disparos de 50 de daño y sin recarga.',
      advice: 'Un arma nueva también puede revelar quién es el rival.',
    ),
    MatchPhase(
      id: PhaseId.finalSale,
      title: 'Remate final',
      period: 'Último tercio',
      description:
          'La mitad de los NPC regresa a los estantes y permanece inmóvil.',
      advice: 'Hay menos osos en movimiento para camuflarte. Elige tus rutas con cuidado.',
    ),
  ];
}
