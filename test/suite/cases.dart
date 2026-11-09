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

/// Every documented case, in order. The report reads this list.
const suiteCases = [tc01];
