/// User story in the format of the course template: "Como / Quiero / Para"
/// plus numbered acceptance criteria.
class UserStory {
  const UserStory({
    required this.id,
    required this.title,
    required this.asA,
    required this.iWant,
    required this.soThat,
    required this.criteria,
    required this.caseIds,
  });

  final String id;

  /// Name of the functional area, as the story and its tests are titled.
  final String title;
  final String asA;
  final String iWant;
  final String soThat;
  final List<String> criteria;

  /// Test cases (ids of `cases.dart`) that verify this story.
  final List<String> caseIds;
}

/// Stories of the mobile app. Each documented test case belongs to exactly
/// one story, which is the functional area of the suite.
const userStories = [
  UserStory(
    id: 'HU-01',
    title: 'Navegar por la guía',
    asA: 'jugador de Little Bearstards',
    iWant: 'una portada con acceso a todos los capítulos de la guía',
    soThat: 'encontrar rápido la información que necesito',
    criteria: [
      'La portada muestra seis tarjetas: Personajes, Sigilo, Objetos, Arsenal, La Juguetería y Resultados globales.',
      'Cada tarjeta abre su capítulo y el botón Volver regresa a la portada.',
      'La navegación inferior permite cambiar de capítulo y, al tocar el capítulo activo, conserva su estado.',
      'La cinta de texto de la portada se puede pausar y no se mueve si el sistema reduce las animaciones.',
    ],
    caseIds: ['TC-01', 'TC-04', 'TC-14', 'TC-19', 'TC-20'],
  ),
  UserStory(
    id: 'HU-02',
    title: 'Conocer a los personajes',
    asA: 'jugador de Little Bearstards',
    iWant: 'conocer al jugador, a los osos NPC y las reglas de eliminación',
    soThat: 'entender cómo se juega antes de entrar a una partida',
    criteria: [
      'Personajes explica la diferencia entre el jugador y los osos NPC.',
      'Muestra tres reglas numeradas: encontrar al rival, equiparse sin llamar la atención y eliminar al correcto.',
      'Indica que al ser eliminado se reaparece con 100 de vida y se pierde el casco.',
      'Indica que golpear a un NPC resta 50 puntos.',
    ],
    caseIds: ['TC-15'],
  ),
  UserStory(
    id: 'HU-03',
    title: 'Aprender a pasar desapercibido',
    asA: 'jugador de Little Bearstards',
    iWant: 'saber qué acciones me delatan ante el rival',
    soThat: 'mezclarme con los osos NPC sin ser descubierto',
    criteria: [
      'Sigilo muestra cuatro acciones: caminar sin armas, correr, saltar y llevar un arma.',
      'Al elegir una acción se explica si es discreta o delatora.',
      'Correr, saltar y llevar un arma se marcan como delatoras.',
    ],
    caseIds: ['TC-03'],
  ),
  UserStory(
    id: 'HU-04',
    title: 'Consultar armas, objetos y puntuación',
    asA: 'jugador de Little Bearstards',
    iWant: 'consultar las armas y los objetos con sus cifras',
    soThat: 'decidir cómo equiparme y cuántos puntos gano',
    criteria: [
      'Arsenal muestra la aguja de coser (25 de daño) y la pistola de dardos (50 de daño, 6 dardos, sin recarga).',
      'Objetos muestra el casco (vida máxima 125, no se acumula) y el rollo de hilo (+25 de vida).',
      'Cada arma y objeto tiene una ficha con sus reglas y se puede volver a la lista.',
      'La puntuación muestra +200, +350, +400 y −50 según el tipo de eliminación.',
    ],
    caseIds: ['TC-02', 'TC-06', 'TC-16'],
  ),
  UserStory(
    id: 'HU-05',
    title: 'Conocer La Juguetería y sus fases',
    asA: 'jugador de Little Bearstards',
    iWant: 'ver el escenario y cómo cambia la partida en cada fase',
    soThat: 'planear mis rutas y saber cuándo aparece cada arma',
    criteria: [
      'La Juguetería muestra el mapa de tres pasillos.',
      'El selector muestra tres fases de igual duración, cada una con su descripción: la pistola aparece en la fase 2 y la mitad de los NPC regresa a los estantes en la fase 3.',
      'No se publican intervalos fijos de minutos para las fases.',
      'Explica el desempate: gana quien tiene más puntos y, si hay empate, quien eliminó más veces al rival.',
    ],
    caseIds: ['TC-05', 'TC-11', 'TC-17'],
  ),
  UserStory(
    id: 'HU-06',
    title: 'Ver los resultados globales',
    asA: 'jugador de Little Bearstards',
    iWant: 'ver el ranking global de jugadores',
    soThat: 'saber quiénes son los mejores osos y compararme con ellos',
    criteria: [
      'La pantalla muestra el podio de los tres primeros y la lista del resto, en el orden que entrega el servidor.',
      'Cada jugador muestra sus puntos, partidas y porcentaje de victorias; si no tiene partidas se muestra un guion.',
      'Los puntos negativos se muestran con el signo menos.',
      'La lectura del ranking es pública: no pide iniciar sesión ni envía contraseñas ni tokens.',
    ],
    caseIds: ['TC-21', 'TC-22', 'TC-23', 'TC-27', 'TC-29'],
  ),
  UserStory(
    id: 'HU-07',
    title: 'Entender qué pasa cuando no cargan los resultados',
    asA: 'jugador de Little Bearstards',
    iWant: 'que la app me explique por qué no puede mostrar el ranking',
    soThat: 'no quedarme con una pantalla rota ni datos que parezcan actuales',
    criteria: [
      'Si todavía no hay partidas registradas, se explica en lugar de mostrar una lista vacía.',
      'Si falla la primera carga, aparece un mensaje claro con un botón Reintentar que recupera los datos.',
      'Si falla una recarga, se conservan los últimos resultados con un aviso de que están desactualizados.',
      'Se distingue un servidor que no responde de datos inesperados.',
    ],
    caseIds: ['TC-24', 'TC-25', 'TC-26', 'TC-28'],
  ),
  UserStory(
    id: 'HU-08',
    title: 'Usar la app en cualquier pantalla',
    asA: 'jugador de Little Bearstards',
    iWant: 'que la app se vea bien en pantallas pequeñas, con texto grande y en horizontal',
    soThat: 'leerla cómodamente en mi teléfono',
    criteria: [
      'Ninguna pantalla desborda en 320×568, con el texto al 180 % ni en horizontal.',
      'La app no se cierra si Android le da un primer fotograma sin tamaño.',
      'Todas las ilustraciones usadas están empaquetadas con la app.',
      'El catálogo de la wiki no se puede modificar y el entorno de desarrollo es reproducible.',
    ],
    caseIds: ['TC-07', 'TC-08', 'TC-09', 'TC-10', 'TC-12', 'TC-13', 'TC-18'],
  ),
];
