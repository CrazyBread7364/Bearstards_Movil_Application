import 'package:flutter_test/flutter_test.dart';

import 'test_case.dart';

void main() {
  const valid = TestCase(
    id: 'TC-01',
    title: 'Ejemplo',
    priority: Priority.alta,
    requirements: ['RF-01'],
    preconditions: 'App iniciada',
    input: 'Un toque',
    steps: ['Tocar'],
    expected: 'Se abre la pantalla',
  );

  test('a complete case has no problems and a searchable name', () {
    expect(valid.validate(), isEmpty);
    expect(valid.name, 'TC-01 Ejemplo');
  });

  test('an incomplete case reports every problem at once', () {
    const broken = TestCase(
      id: 'T1',
      title: ' ',
      priority: Priority.baja,
      requirements: [],
      preconditions: '',
      input: 'x',
      steps: [],
      expected: 'y',
    );
    expect(broken.validate(), hasLength(5));
  });
}
