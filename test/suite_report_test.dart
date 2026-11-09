import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';

import '../tool/suite_report.dart';

String start(int id, String name) => jsonEncode({
  'type': 'testStart',
  'test': {'id': id, 'name': name},
});

String done(int id, {String result = 'success', bool skipped = false}) =>
    jsonEncode({
      'type': 'testDone',
      'testID': id,
      'result': result,
      'skipped': skipped,
      'hidden': false,
    });

String error(int id, String message) =>
    jsonEncode({'type': 'error', 'testID': id, 'error': message});

void main() {
  test('a passing case is approved', () {
    final results = parseSuiteResults([
      start(1, 'TC-01 Personajes tiene ruta propia'),
      done(1),
    ]);
    expect(results['TC-01']!.status, CaseStatus.aprobado);
  });

  test('a failing case is failed and keeps a one-line reason', () {
    final results = parseSuiteResults([
      start(2, 'TC-02 Detalle'),
      error(2, 'Expected: <1>\n  Actual: <2>\n'),
      done(2, result: 'failure'),
    ]);
    expect(results['TC-02']!.status, CaseStatus.fallido);
    expect(results['TC-02']!.obtained, contains('Expected: <1> Actual: <2>'));
  });

  test('an erroring case is failed even without a message', () {
    final results = parseSuiteResults([
      start(3, 'TC-03 Sigilo'),
      done(3, result: 'error'),
    ]);
    expect(results['TC-03']!.status, CaseStatus.fallido);
    expect(results['TC-03']!.obtained, contains('sin detalle'));
  });

  test('a skipped case stays pending', () {
    final results = parseSuiteResults([
      start(4, 'TC-04 Omitida'),
      done(4, skipped: true),
    ]);
    expect(results['TC-04']!.status, CaseStatus.pendiente);
  });

  test('other tests, loading entries and garbage lines are ignored', () {
    final results = parseSuiteResults([
      'esto no es json',
      '[1, 2]',
      start(5, 'loading test/suite/navigation_cases_test.dart'),
      done(5),
      start(6, 'una prueba cualquiera'),
      done(6),
      error(7, 'error de una prueba que no es un caso'),
    ]);
    expect(results, isEmpty);
  });

  test('cases that never ran are completed as pending', () {
    final parsed = parseSuiteResults([start(1, 'TC-01 A'), done(1)]);
    final complete = completeResults(['TC-01', 'TC-02'], parsed);
    expect(complete.keys, ['TC-01', 'TC-02']);
    expect(complete['TC-01']!.status, CaseStatus.aprobado);
    expect(complete['TC-02']!.status, CaseStatus.pendiente);
  });

  test('long failure messages are shortened to one line', () {
    final summary = summarizeError('${'palabra ' * 100}\nfin', maxLength: 50);
    expect(summary.length, 50);
    expect(summary, isNot(contains('\n')));
    expect(summary, endsWith('…'));
  });

  test('the parser understands the real reporter output', () {
    final results = parseSuiteResults([
      '{"test":{"id":21,"name":"TC-01 Personajes tiene ruta propia","suiteID":6,'
          '"groupIDs":[19],"metadata":{"skip":false,"skipReason":null}},'
          '"type":"testStart","time":900}',
      '{"testID":21,"result":"success","skipped":false,"hidden":false,'
          '"type":"testDone","time":1100}',
    ]);
    expect(results['TC-01']!.status, CaseStatus.aprobado);
  });
}
