import 'test_case_model.dart';

const tc01 = TestCase(
  id: 'TC-01',
  title: 'Personajes tiene ruta propia',
  priority: Priority.alta,
  requirements: ['RF-01', 'RF-02'],
  preconditions: 'App iniciada en la portada, pantalla de 390×844',
  input: 'Toque en la tarjeta "Explorar Personajes" y luego en "Volver"',
  steps: [
    'Tocar la tarjeta "Explorar Personajes".',
    'Verificar qué pantalla se abre.',
    'Tocar el botón "Volver".',
  ],
  expected:
      'Se abre la pantalla de Personajes y no la de Sigilo. Volver regresa a '
      'la portada, donde "Explorar Arsenal" vuelve a estar visible.',
);

const tc02 = TestCase(
  id: 'TC-02',
  title: 'Detalle del Arsenal y regreso',
  priority: Priority.alta,
  requirements: ['RF-05', 'RF-01'],
  preconditions: 'App iniciada en la portada, pantalla de 390×844',
  input: 'Toques en "Explorar Arsenal", "Consultar Aguja de coser" y "Volver"',
  steps: [
    'Tocar la tarjeta "Explorar Arsenal".',
    'Tocar la ficha "Aguja de coser".',
    'Leer el texto de la ficha.',
    'Tocar el botón "Volver".',
  ],
  expected:
      'La ficha corresponde a la aguja de coser y menciona "25 puntos de '
      'vida". Volver regresa al Arsenal con su encabezado "Dos armas. Dos '
      'formas de actuar." y sin errores.',
);

const tc03 = TestCase(
  id: 'TC-03',
  title: 'Selección en Sigilo explica la acción',
  priority: Priority.alta,
  requirements: ['RF-03'],
  preconditions: 'App iniciada en la portada, pantalla de 390×844',
  input: 'Toques en "Explorar Sigilo" y luego en "Correr te delata"',
  steps: [
    'Tocar la tarjeta "Explorar Sigilo".',
    'Tocar la acción "Correr te delata".',
    'Desplazar hasta el mensaje de la acción seleccionada.',
  ],
  expected:
      'Se muestra "Acción delatora" con la explicación de que el movimiento '
      'apresurado rompe la rutina de los NPC.',
);

const tc04 = TestCase(
  id: 'TC-04',
  title: 'La pestaña activa conserva su estado',
  priority: Priority.media,
  requirements: ['RF-01', 'RF-03'],
  preconditions: 'App iniciada en la portada, pantalla de 390×844',
  input:
      'Toques en "Explorar Sigilo", "Correr te delata" y "Ir a Sigilo" '
      '(la pestaña ya activa)',
  steps: [
    'Tocar la tarjeta "Explorar Sigilo".',
    'Tocar la acción "Correr te delata".',
    'Tocar "Ir a Sigilo" en la navegación inferior.',
    'Desplazar hasta el mensaje de la acción seleccionada.',
  ],
  expected:
      'La pantalla de Sigilo no se reconstruye: sigue siendo la misma y la '
      'selección "Correr te delata" se mantiene.',
);

const tc05 = TestCase(
  id: 'TC-05',
  title: 'Las tres fases muestran su cambio real',
  priority: Priority.alta,
  requirements: ['RF-06', 'RF-07'],
  preconditions: 'App iniciada en la portada, pantalla de 390×844',
  input:
      'Toque en "Explorar La Juguetería" y luego en las fases 2, 3 y 1 del '
      'selector',
  steps: [
    'Desplazar la portada hasta "Explorar La Juguetería" y tocar la tarjeta.',
    'Desplazar hasta el selector de fases y leer la fase inicial.',
    'Tocar "Fase 2: Mercancía nueva" y leer su descripción.',
    'Tocar "Fase 3: Remate final" y leer su descripción.',
    'Tocar "Fase 1: Luces apagadas" y leer su descripción.',
  ],
  expected:
      'La fase inicial es el primer tercio. La fase 2 es el segundo tercio y '
      'anuncia que la pistola aparece una sola vez. La fase 3 indica que la '
      'mitad de los NPC regresa a los estantes. No se publica ningún '
      'intervalo fijo de 10–15 minutos.',
);

const tc06 = TestCase(
  id: 'TC-06',
  title: 'Objetos desde la navegación inferior',
  priority: Priority.alta,
  requirements: ['RF-04', 'RF-01'],
  preconditions: 'App iniciada en la portada, pantalla de 390×844',
  input:
      'Toques en "Explorar Sigilo", "Ir a Objetos" y en las fichas "Casco" '
      'y "Rollo de hilo"',
  steps: [
    'Tocar la tarjeta "Explorar Sigilo".',
    'Tocar "Ir a Objetos" en la navegación inferior.',
    'Abrir la ficha "Casco", verificar su título y tocar "Volver".',
    'Abrir la ficha "Rollo de hilo", verificar su título y tocar "Volver".',
  ],
  expected:
      'Objetos se abre desde la navegación. Cada ficha muestra su título y '
      'Volver regresa a la lista de objetos.',
);

const tc07 = TestCase(
  id: 'TC-07',
  title: 'Adaptación a pantalla pequeña (320×568)',
  priority: Priority.alta,
  requirements: ['RF-09'],
  preconditions: 'Pantalla de 320×568 y escala de texto al 100 %',
  input: 'Recorrido por la portada, los cinco capítulos y las cuatro fichas',
  steps: [
    'Iniciar la app en una pantalla de 320×568.',
    'Abrir cada capítulo y desplazar hasta el final.',
    'Abrir cada ficha de detalle y desplazar hasta el final.',
  ],
  expected:
      'Ninguna pantalla produce desbordes ni excepciones de diseño, ni al '
      'abrirse ni al desplazarse.',
);

const tc08 = TestCase(
  id: 'TC-08',
  title: 'Adaptación con texto al 180 %',
  priority: Priority.alta,
  requirements: ['RF-09'],
  preconditions: 'Pantalla de 390×844 y escala de texto al 180 %',
  input: 'Recorrido por la portada, los cinco capítulos y las cuatro fichas',
  steps: [
    'Iniciar la app con el texto ampliado al 180 %.',
    'Abrir cada capítulo y desplazar hasta el final.',
    'Abrir cada ficha de detalle y desplazar hasta el final.',
  ],
  expected:
      'Ninguna pantalla produce desbordes ni excepciones de diseño, ni al '
      'abrirse ni al desplazarse.',
);

const tc09 = TestCase(
  id: 'TC-09',
  title: 'Adaptación en horizontal (844×390)',
  priority: Priority.media,
  requirements: ['RF-09'],
  preconditions: 'Pantalla en horizontal de 844×390 y escala de texto al 100 %',
  input: 'Recorrido por la portada, los cinco capítulos y las cuatro fichas',
  steps: [
    'Iniciar la app con el teléfono en horizontal.',
    'Abrir cada capítulo y desplazar hasta el final.',
    'Abrir cada ficha de detalle y desplazar hasta el final.',
  ],
  expected:
      'Ninguna pantalla produce desbordes ni excepciones de diseño, ni al '
      'abrirse ni al desplazarse.',
);

const tc10 = TestCase(
  id: 'TC-10',
  title: 'Catálogo completo e inmutable',
  priority: Priority.alta,
  requirements: ['RF-07', 'RF-11'],
  preconditions: 'Repositorio local del catálogo (LocalWikiRepository)',
  input: 'Categorías armas y objetos; los cuatro identificadores de entrada',
  steps: [
    'Consultar las entradas de la categoría armas y de la categoría objetos.',
    'Intentar vaciar la lista de armas devuelta.',
    'Consultar las reglas de cada entrada por su identificador.',
  ],
  expected:
      'Armas contiene la aguja y la pistola; objetos contiene el casco y el '
      'rollo de hilo. La lista devuelta no se puede modificar y cada entrada '
      'tiene al menos una regla.',
);

const tc11 = TestCase(
  id: 'TC-11',
  title: 'Los ViewModels notifican solo ante cambios reales',
  priority: Priority.media,
  requirements: ['RF-03', 'RF-06'],
  preconditions: 'StealthViewModel y PhasesViewModel creados con el catálogo',
  input: 'Seleccionar "correr" dos veces y luego la fase "Remate final"',
  steps: [
    'Seleccionar la acción "correr" y volver a seleccionarla.',
    'Seleccionar la fase "Remate final".',
    'Contar las notificaciones de cada modelo.',
  ],
  expected:
      'Cada modelo notifica una sola vez. La acción correr no es discreta, '
      'la descripción de la fase final menciona la mitad de los NPC y el '
      'cambio de un modelo no altera al otro.',
);

const tc12 = TestCase(
  id: 'TC-12',
  title: 'Ilustraciones empaquetadas',
  priority: Priority.media,
  requirements: ['RF-11'],
  preconditions: 'Paquete de la app construido para pruebas',
  input: 'Las 21 rutas de WikiAssets y el manifiesto de assets',
  steps: [
    'Cargar cada ilustración declarada en WikiAssets.',
    'Revisar el manifiesto de assets del paquete.',
  ],
  expected:
      'Cada ilustración existe y no está vacía. No se empaqueta ningún '
      'archivo de assets/images/mvp/.',
);

const tc13 = TestCase(
  id: 'TC-13',
  title: 'Entorno reproducible',
  priority: Priority.media,
  requirements: ['RF-11'],
  preconditions: 'toolchain.json presente en la raíz del proyecto',
  input:
      'Versión de Flutter, canal, revisión y versión de Dart, iguales y '
      'alteradas una por una',
  steps: [
    'Leer toolchain.json y comprobar que sus cuatro campos están completos.',
    'Comparar el SDK esperado contra uno idéntico.',
    'Comparar contra SDK con un solo campo distinto, uno por campo.',
    'Comparar contra un SDK sin datos.',
  ],
  expected:
      'El archivo está completo. Un SDK idéntico se acepta y un SDK con '
      'cualquier campo distinto se rechaza señalando solo ese campo. Un SDK '
      'sin datos se rechaza por los cuatro campos.',
);

const tc14 = TestCase(
  id: 'TC-14',
  title: 'La portada enlaza los cinco capítulos',
  priority: Priority.alta,
  requirements: ['RF-01', 'RF-04'],
  preconditions: 'App iniciada en la portada, pantalla de 390×844',
  input: 'Las tarjetas "Explorar …" y un toque en "Explorar Objetos"',
  steps: [
    'Buscar en la portada las cinco tarjetas de capítulo.',
    'Desplazar hasta "Explorar Objetos" y tocar la tarjeta.',
  ],
  expected:
      'La portada ofrece Personajes, Sigilo, Objetos, Arsenal y La Juguetería. '
      'La tarjeta Objetos abre la pantalla de Objetos.',
);

const tc15 = TestCase(
  id: 'TC-15',
  title: 'Personajes muestra las tres reglas',
  priority: Priority.alta,
  requirements: ['RF-02', 'RF-07'],
  preconditions: 'App iniciada en la portada, pantalla de 390×844',
  input: 'Toque en "Explorar Personajes" y desplazamiento hasta las reglas',
  steps: [
    'Tocar la tarjeta "Explorar Personajes".',
    'Desplazar hasta el encabezado "Tres reglas.".',
    'Leer las tres reglas numeradas.',
  ],
  expected:
      'Aparecen tres reglas numeradas: encontrar al rival, equiparse sin '
      'llamar la atención y eliminar al correcto. La tercera indica que '
      'golpear a un NPC resta 50 puntos.',
);

const tc16 = TestCase(
  id: 'TC-16',
  title: 'Arsenal muestra la puntuación',
  priority: Priority.alta,
  requirements: ['RF-05', 'RF-07'],
  preconditions: 'App iniciada en la portada, pantalla de 390×844',
  input: 'Toque en "Explorar Arsenal" y desplazamiento hasta "Cada objetivo cuenta"',
  steps: [
    'Tocar la tarjeta "Explorar Arsenal".',
    'Desplazar hasta el encabezado "Cada objetivo cuenta".',
    'Leer los cuatro valores de puntuación.',
  ],
  expected:
      'Se muestran +200 por eliminar al rival con aguja, +350 con sigilo, '
      '+400 con dardos y −50 por golpear a un NPC, igual que en el '
      'Portafolio funcional.',
);

const tc17 = TestCase(
  id: 'TC-17',
  title: 'Selector de fases con texto al 180 %',
  priority: Priority.media,
  requirements: ['RF-06', 'RF-09'],
  preconditions: 'Pantalla de 390×844 y escala de texto al 180 %',
  input: 'Toque en las fases 1, 2 y 3 del selector de La Juguetería',
  steps: [
    'Iniciar la app con el texto ampliado al 180 %.',
    'Abrir La Juguetería y desplazar hasta el selector de fases.',
    'Tocar cada fase y leer su descripción.',
  ],
  expected:
      'Las tres fases se pueden tocar con su etiqueta "Fase N: …", cada una '
      'muestra su periodo y no aparecen desbordes.',
);

/// Every documented case, in order. The report reads this list.
const suiteCases = [
  tc01,
  tc02,
  tc03,
  tc04,
  tc05,
  tc06,
  tc07,
  tc08,
  tc09,
  tc10,
  tc11,
  tc12,
  tc13,
  tc14,
  tc15,
  tc16,
  tc17,
];
