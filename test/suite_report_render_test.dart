import 'package:flutter_test/flutter_test.dart';

import '../test/suite/manual_cases.dart';
import '../test/suite/test_case_model.dart';
import '../test/suite/user_stories.dart';
import '../tool/suite_report.dart';
import '../tool/suite_report_render.dart';

void main() {
  const first = TestCase(
    id: 'TC-01',
    title: 'Primer caso',
    priority: Priority.alta,
    requirements: ['RF-01'],
    preconditions: 'App iniciada',
    input: 'Un toque',
    steps: ['Tocar la tarjeta.', 'Verificar la pantalla.'],
    expected: 'Se abre la pantalla.',
  );
  const second = TestCase(
    id: 'TC-02',
    title: 'Segundo <caso> & más',
    priority: Priority.baja,
    requirements: ['RF-02'],
    preconditions: 'Nada',
    input: 'Nada',
    steps: ['Un paso'],
    expected: 'Algo',
  );
  const third = TestCase(
    id: 'TC-03',
    title: 'Tercer caso',
    priority: Priority.media,
    requirements: ['RF-03'],
    preconditions: 'Nada',
    input: 'Nada',
    steps: ['Un paso'],
    expected: 'Algo',
  );
  const stories = [
    UserStory(
      id: 'HU-01',
      title: 'Primera historia',
      asA: 'jugador',
      iWant: 'ver algo',
      soThat: 'saber algo',
      criteria: ['Criterio uno.', 'Criterio dos.', 'Criterio tres.'],
      caseIds: ['TC-03', 'TC-01'],
    ),
    UserStory(
      id: 'HU-02',
      title: 'Segunda historia',
      asA: 'jugador',
      iWant: 'ver otra cosa',
      soThat: 'saber otra cosa',
      criteria: ['A', 'B', 'C'],
      caseIds: ['TC-02'],
    ),
  ];
  const passed = CaseResult(CaseStatus.aprobado, 'Coincide con lo esperado.');

  String html(Map<String, CaseResult> results, {List<UserStory>? custom}) =>
      renderSuiteHtml(
        appName: 'Bearstards Wiki',
        stories: custom ?? stories,
        cases: const [first, second, third],
        results: results,
        generatedAt: DateTime(2026, 11, 17),
        flutterVersion: '3.47.6',
        dartVersion: '3.13.5',
      );

  final allPassed = {'TC-01': passed, 'TC-02': passed, 'TC-03': passed};

  test('section 1 lists each story with Como, Quiero, Para and criteria', () {
    final text = html(allPassed);
    expect(text, contains('HISTORIA: PRIMERA HISTORIA'));
    expect(
      text,
      contains('<th colspan="2">Descripción Historia de Usuario</th>'),
    );
    expect(text, contains('<th>Criterios de Aceptación</th>'));
    expect(text, contains('<td class="label">Como</td><td>jugador</td>'));
    expect(text, contains('<td class="label">Quiero</td><td>ver algo</td>'));
    expect(text, contains('<td class="label">Para</td><td>saber algo</td>'));
    expect(
      text,
      contains('1. Criterio uno.<br>2. Criterio dos.<br>3. Criterio tres.'),
    );
    expect(text, contains('<td class="id" rowspan="3">HU-01</td>'));
  });

  test('section 2 has the nine columns of the template', () {
    final text = html(allPassed);
    expect(text, contains('SUITE DE PRUEBAS - Bearstards Wiki'));
    for (final column in [
      'No',
      'Caso de prueba',
      'Prioridad',
      'Precondiciones',
      'Datos de entrada',
      'Pasos',
      'Resultados Esperado',
      'Resultado Obtenido',
      'Estado prueba',
    ]) {
      expect(text, contains('<th>$column</th>'), reason: column);
    }
  });

  test('cases are grouped by functional area and numbered across areas', () {
    final text = html(allPassed);
    expect(text, contains('AREA FUNCIONAL: Primera historia (HU-01)'));
    expect(text, contains('AREA FUNCIONAL: Segunda historia (HU-02)'));
    expect(
      text,
      contains('<td class="no">1<span class="tc">TC-03</span></td>'),
    );
    expect(
      text,
      contains('<td class="no">2<span class="tc">TC-01</span></td>'),
    );
    expect(
      text,
      contains('<td class="no">3<span class="tc">TC-02</span></td>'),
    );
    expect(
      text.indexOf('Primera historia (HU-01)'),
      lessThan(text.indexOf('Segunda historia (HU-02)')),
    );
  });

  test('steps are numbered in the template style', () {
    expect(
      html(allPassed),
      contains('1.- Tocar la tarjeta.<br>2.- Verificar la pantalla.'),
    );
  });

  test('the status is OK, FALLO or PENDIENTE with its own color class', () {
    final text = html({
      'TC-01': passed,
      'TC-03': const CaseResult(CaseStatus.fallido, 'No coincide: x'),
    });
    expect(text, contains('<td class="status ok">OK</td>'));
    expect(text, contains('<td class="status fail">FALLO</td>'));
    expect(text, contains('<td class="status pending">PENDIENTE</td>'));
    expect(text, contains('<td>No coincide: x</td>'));
    expect(text, contains('No se ejecutó la prueba.'));
    expect(text, contains('1 OK, 1 FALLO, 1 pendientes.'));
  });

  test('the obtained result of each case comes from the run', () {
    final text = html({
      'TC-01': const CaseResult(CaseStatus.aprobado, 'Resultado de TC-01.'),
      'TC-02': passed,
      'TC-03': passed,
    });
    expect(
      text,
      contains(
        '<td>Resultado de TC-01. Verificado por la prueba automatizada TC-01.</td>',
      ),
    );
  });

  test('text cannot inject markup', () {
    final text = html(allPassed);
    expect(text, contains('Segundo &lt;caso&gt; &amp; más'));
    expect(text, isNot(contains('<caso>')));
  });

  test('the footer states the date and the tool versions', () {
    final text = html(allPassed);
    expect(text, contains('el 2026-11-17'));
    expect(text, contains('Flutter 3.47.6'));
    expect(text, contains('Dart 3.13.5'));
  });

  test('a story that cites a missing case is an error, not a silent gap', () {
    expect(
      () => html(
        allPassed,
        custom: [
          const UserStory(
            id: 'HU-09',
            title: 'x',
            asA: 'x',
            iWant: 'x',
            soThat: 'x',
            criteria: ['a', 'b', 'c'],
            caseIds: ['TC-99'],
          ),
        ],
      ),
      throwsArgumentError,
    );
  });

  group('manual cases', () {
    const done = ManualCase(
      id: 'MC-01',
      storyId: 'HU-02',
      title: 'Caso manual hecho',
      priority: Priority.alta,
      preconditions: 'Emulador',
      input: 'Nada',
      steps: ['Probar'],
      expected: 'Funciona',
      obtained: 'Funcionó en el emulador.',
      status: ManualStatus.ok,
    );
    const failed = ManualCase(
      id: 'MC-02',
      storyId: 'HU-02',
      title: 'Caso manual fallido',
      priority: Priority.media,
      preconditions: 'Emulador',
      input: 'Nada',
      steps: ['Probar'],
      expected: 'Funciona',
      obtained: 'No funcionó.',
      status: ManualStatus.fallo,
    );
    const waiting = ManualCase(
      id: 'MC-03',
      storyId: 'HU-01',
      title: 'Caso manual pendiente',
      priority: Priority.baja,
      preconditions: 'Emulador',
      input: 'Nada',
      steps: ['Probar'],
      expected: 'Funciona',
    );

    String withManual(List<ManualCase> manual) => renderSuiteHtml(
      appName: 'Bearstards Wiki',
      stories: stories,
      cases: const [first, second, third],
      results: {'TC-01': passed, 'TC-02': passed, 'TC-03': passed},
      generatedAt: DateTime(2026, 11, 20),
      flutterVersion: '3.47.6',
      dartVersion: '3.13.5',
      manualCases: manual,
    );

    test('appear under their story after the automated cases', () {
      final text = withManual([done, waiting]);
      expect(text, contains('<span class="tc">MC-03</span>'));
      expect(
        text.indexOf('<span class="tc">TC-01</span>'),
        lessThan(text.indexOf('<span class="tc">MC-03</span>')),
        reason: 'MC-03 es de HU-01, después de TC-03 y TC-01',
      );
      expect(
        text.indexOf('<span class="tc">MC-03</span>'),
        lessThan(text.indexOf('<span class="tc">MC-01</span>')),
        reason: 'HU-01 va antes que HU-02',
      );
      expect(
        text,
        contains('<td class="no">5<span class="tc">MC-01</span></td>'),
      );
    });

    test('keep the status written by the person', () {
      final text = withManual([done, failed, waiting]);
      expect(text, contains('<td>Funcionó en el emulador.</td>'));
      expect(text, contains('<td>No funcionó.</td>'));
      expect(text, contains('<td>Pendiente de ejecutar.</td>'));
      expect(text, contains('4 OK, 1 FALLO, 1 pendientes.'));
    });

    test('are not described as verified by an automated test', () {
      final text = withManual([done]);
      expect(
        text,
        isNot(contains('Verificado por la prueba automatizada MC-01')),
      );
    });

    test('a case under a missing story is an error', () {
      const orphan = ManualCase(
        id: 'MC-09',
        storyId: 'HU-99',
        title: 'x',
        priority: Priority.baja,
        preconditions: 'x',
        input: 'x',
        steps: ['x'],
        expected: 'x',
      );
      expect(() => withManual([orphan]), throwsArgumentError);
    });
  });
}
