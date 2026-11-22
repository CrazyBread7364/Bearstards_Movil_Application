import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';

import '../test/suite/cases.dart';
import '../test/suite/manual_cases.dart';
import '../tool/generate_suite_report.dart';
import '../tool/suite_report.dart';

String start(int id, String name) => jsonEncode({
  'type': 'testStart',
  'test': {'id': id, 'name': name},
});

String done(int id, {String result = 'success'}) => jsonEncode({
  'type': 'testDone',
  'testID': id,
  'result': result,
  'skipped': false,
  'hidden': false,
});

void main() {
  group('command line', () {
    test('has sensible defaults', () {
      final options = parseOptions([]);
      expect(options.out, 'docs/entrega/suite-de-pruebas.html');
      expect(options.fromJson, isNull);
      expect(options.pdf, isFalse);
      expect(options.browser, isNull);
    });

    test('reads every option', () {
      final options = parseOptions([
        '--pdf',
        '--out=salida/suite.html',
        '--from-json=corrida.json',
        '--browser=/usr/bin/chromium',
      ]);
      expect(options.pdf, isTrue);
      expect(options.out, 'salida/suite.html');
      expect(options.fromJson, 'corrida.json');
      expect(options.browser, '/usr/bin/chromium');
    });

    test('an unknown option is an error, not ignored', () {
      expect(() => parseOptions(['--pfd']), throwsFormatException);
    });
  });

  group('exit code', () {
    const ok = CaseResult(CaseStatus.aprobado, 'ok');

    test('is 0 when nothing failed', () {
      expect(exitCodeFor({'TC-01': ok}), 0);
      expect(
        exitCodeFor({
          'TC-01': ok,
          'TC-02': const CaseResult(CaseStatus.pendiente, 'x'),
        }),
        0,
      );
    });

    test('is 1 when any case failed', () {
      expect(
        exitCodeFor({
          'TC-01': ok,
          'TC-02': const CaseResult(CaseStatus.fallido, 'x'),
        }),
        1,
      );
    });
  });

  group('document', () {
    String html(List<String> lines) => buildHtml(
      lines,
      now: DateTime(2026, 11, 17),
      flutterVersion: '3.47.6',
      dartVersion: '3.13.5',
    );

    test('lists all the cases of the suite and every user story', () {
      final text = html([]);
      for (final testCase in suiteCases) {
        expect(text, contains(testCase.id), reason: testCase.id);
      }
      expect(text, contains('HISTORIA: NAVEGAR POR LA GUÍA'));
      expect(text, contains('AREA FUNCIONAL: Ver los resultados globales'));
    });

    test('a run with no results leaves every case pending', () {
      final text = html([]);
      // Only the manual cases already recorded as OK may appear as OK.
      final manualDone = manualCases
          .where((m) => m.status == ManualStatus.ok)
          .length;
      expect('class="status ok"'.allMatches(text), hasLength(manualDone));
      final total = suiteCases.length + manualCases.length;
      expect(text, contains('$total casos; $manualDone OK, 0 FALLO'));
    });

    test('results of the run reach the document', () {
      final first = suiteCases.first;
      final text = html([
        start(1, first.name),
        done(1),
        start(2, suiteCases[1].name),
        done(2, result: 'failure'),
      ]);
      expect(text, contains('class="status ok">OK'));
      expect(text, contains('class="status fail">FALLO'));
      final manualDone = manualCases
          .where((m) => m.status == ManualStatus.ok)
          .length;
      expect(text, contains('${1 + manualDone} OK, 1 FALLO'));
    });
  });
}
