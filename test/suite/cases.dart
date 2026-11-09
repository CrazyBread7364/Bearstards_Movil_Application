import 'test_case.dart';

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

/// Every documented case, in order. The report reads this list.
const suiteCases = [tc01, tc02];
