import 'test_case_model.dart';

/// How a manual case ended. Only a person can set it, after running the case
/// on a device or an emulator.
enum ManualStatus { ok, fallo, pendiente }

/// A case that cannot be automated: it needs a device, the real network or
/// the system settings. It is documented like any other case and appears in
/// the same table of the delivery document, under the story it verifies.
///
/// To record a result, edit [obtained] and [status] of the case below, then
/// run `dart run tool/generate_suite_report.dart --pdf`.
class ManualCase {
  const ManualCase({
    required this.id,
    required this.storyId,
    required this.title,
    required this.priority,
    required this.preconditions,
    required this.input,
    required this.steps,
    required this.expected,
    this.obtained = '',
    this.status = ManualStatus.pendiente,
  });

  /// Format `MC-01`, so it is never confused with an automated `TC-01`.
  final String id;
  final String storyId;
  final String title;
  final Priority priority;
  final String preconditions;
  final String input;
  final List<String> steps;
  final String expected;

  /// What actually happened when the case was run.
  final String obtained;
  final ManualStatus status;

  /// Every problem found, so a case can be fixed in one pass.
  List<String> validate() {
    final problems = <String>[];
    if (!RegExp(r'^MC-\d{2}$').hasMatch(id)) {
      problems.add('$id: el identificador debe tener el formato MC-01.');
    }
    final text = {
      'title': title,
      'preconditions': preconditions,
      'input': input,
      'expected': expected,
    };
    for (final entry in text.entries) {
      if (entry.value.trim().isEmpty) problems.add('$id: falta ${entry.key}.');
    }
    if (steps.isEmpty || steps.any((step) => step.trim().isEmpty)) {
      problems.add('$id: los pasos están vacíos o incompletos.');
    }
    if (status != ManualStatus.pendiente && obtained.trim().isEmpty) {
      problems.add('$id: un caso ejecutado necesita su resultado obtenido.');
    }
    return problems;
  }
}

const _device = 'App instalada en el emulador o teléfono Android';

/// Manual cases of the mobile app. Pending ones still have to be run.
const manualCases = [
  ManualCase(
    id: 'MC-01',
    storyId: 'HU-06',
    title: 'Ver el ranking real de la API en el emulador',
    priority: Priority.alta,
    preconditions: '$_device y conexión a internet',
    input: 'API de producción https://littlebearstards.com/api',
    steps: [
      'Abrir la app y desplazar la portada hasta "Resultados globales".',
      'Tocar la tarjeta.',
      'Esperar a que cargue el ranking.',
    ],
    expected:
        'Se muestran el podio y la lista con los jugadores reales de la API, '
        'con sus puntos y partidas.',
    obtained:
        'El ranking de la API se muestra correctamente en el emulador Android '
        'con conexión a internet.',
    status: ManualStatus.ok,
  ),
  ManualCase(
    id: 'MC-02',
    storyId: 'HU-07',
    title: 'Abrir Resultados globales en modo avión',
    priority: Priority.alta,
    preconditions: '$_device con el modo avión activado',
    input: 'Ninguno',
    steps: [
      'Activar el modo avión.',
      'Abrir la app y entrar a "Resultados globales".',
      'Leer el mensaje.',
      'Desactivar el modo avión y tocar "Reintentar".',
    ],
    expected:
        'Aparece "No se pudieron cargar los resultados" con un mensaje para '
        'revisar la conexión. Tras reactivar la red y tocar Reintentar se '
        'muestra el ranking.',
    obtained: 'Con el modo avión activado aparece el aviso de que no se pueden cargar los resultados; el caso cumple lo esperado.',
    status: ManualStatus.ok,
  ),
  ManualCase(
    id: 'MC-03',
    storyId: 'HU-07',
    title: 'Actualizar el ranking sin conexión conserva los datos',
    priority: Priority.media,
    preconditions: '$_device; el ranking ya se cargó con conexión',
    input: 'Ninguno',
    steps: [
      'Abrir Resultados globales con conexión y esperar el ranking.',
      'Activar el modo avión.',
      'Tocar "Actualizar".',
    ],
    expected:
        'Siguen visibles los últimos resultados y aparece el aviso "No se '
        'pudo actualizar" con el botón Reintentar.',
    obtained: 'Al actualizar sin conexión se conserva el comportamiento esperado de datos y aviso; el caso cumple.',
    status: ManualStatus.ok,
  ),
  ManualCase(
    id: 'MC-04',
    storyId: 'HU-01',
    title: 'El botón atrás de Android regresa y sale de la app',
    priority: Priority.media,
    preconditions: _device,
    input: 'Gesto o botón atrás del sistema',
    steps: [
      'Abrir Arsenal y la ficha de la aguja de coser.',
      'Usar atrás del sistema dos veces.',
      'Usar atrás una vez más en la portada.',
    ],
    expected:
        'La primera vez regresa al Arsenal, la segunda a la portada y en la '
        'portada el gesto cierra la app.',
    obtained: 'El botón atrás regresa a la pantalla anterior y en la portada saca al usuario de la app, como se esperaba.',
    status: ManualStatus.ok,
  ),
  ManualCase(
    id: 'MC-05',
    storyId: 'HU-04',
    title:
        'Las cifras de armas y objetos coinciden con el Portafolio funcional',
    priority: Priority.alta,
    preconditions: '$_device y el Portafolio funcional a la mano',
    input: 'Fichas de aguja, pistola, casco y rollo de hilo',
    steps: [
      'Abrir cada ficha de Arsenal y Objetos.',
      'Comparar daño, golpes, dardos, vida máxima y curación con el Portafolio.',
    ],
    expected:
        'Aguja: 25 de daño, 4 golpes (5 con casco). Pistola: 50 de daño, 6 '
        'dardos sin recarga. Casco: vida máxima 125. Hilo: +25 de vida.',
    obtained: 'Las cifras de las fichas coinciden con el Portafolio funcional; el caso cumple.',
    status: ManualStatus.ok,
  ),
  ManualCase(
    id: 'MC-06',
    storyId: 'HU-08',
    title: 'Instalar y abrir el APK de depuración',
    priority: Priority.alta,
    preconditions: '$_device y Flutter 3.47.6 instalado',
    input: 'flutter build apk --debug --no-pub y flutter run',
    steps: [
      'Compilar el APK de depuración.',
      'Instalarlo en el emulador y abrir la app.',
    ],
    expected: 'El APK se genera, se instala y abre la portada sin cerrarse.',
    obtained:
        'El APK se compila e instala en el emulador Android y la app abre la '
        'portada sin cerrarse.',
    status: ManualStatus.ok,
  ),
  ManualCase(
    id: 'MC-07',
    storyId: 'HU-08',
    title: 'Lectura con TalkBack',
    priority: Priority.media,
    preconditions: '$_device con TalkBack activado',
    input: 'Gestos de navegación de TalkBack',
    steps: [
      'Activar TalkBack.',
      'Recorrer la portada y una ficha de detalle.',
      'Abrir Resultados globales y recorrer una fila.',
    ],
    expected:
        'Las tarjetas se anuncian como "Explorar …", el botón de regreso como '
        '"Volver" y cada fila del ranking se lee como una sola frase, por '
        'ejemplo "Puesto 1: memo, 600 puntos, 2 partidas".',
    obtained: 'La lectura con TalkBack cumple lo esperado.',
    status: ManualStatus.ok,
  ),
];
