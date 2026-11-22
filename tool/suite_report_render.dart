import '../test/suite/manual_cases.dart';
import '../test/suite/test_case_model.dart';
import '../test/suite/user_stories.dart';
import 'suite_report.dart';

/// Builds the deliverable of the course: an HTML page, ready to print as a
/// PDF, with the layout of the instructor's template.
///
/// Section 1 lists the user stories ("Como / Quiero / Para" and acceptance
/// criteria). Section 2 is the test suite: the cases grouped by functional
/// area, one row per case with the template's nine columns. The obtained
/// result and the status come from [results], read from a real test run, so
/// nothing is filled in by hand.
String renderSuiteHtml({
  required String appName,
  required List<UserStory> stories,
  required List<TestCase> cases,
  required Map<String, CaseResult> results,
  required DateTime generatedAt,
  required String flutterVersion,
  required String dartVersion,
  List<ManualCase> manualCases = const [],
}) {
  final byId = {for (final testCase in cases) testCase.id: testCase};
  for (final story in stories) {
    for (final id in story.caseIds) {
      if (!byId.containsKey(id)) {
        throw ArgumentError('${story.id} cita un caso que no existe: $id');
      }
    }
  }

  final storyIds = stories.map((s) => s.id).toSet();
  for (final manual in manualCases) {
    if (!storyIds.contains(manual.storyId)) {
      throw ArgumentError(
        '${manual.id} pertenece a una historia que no existe: '
        '${manual.storyId}',
      );
    }
  }

  CaseResult resultOf(String id) =>
      results[id] ??
      const CaseResult(CaseStatus.pendiente, 'No se ejecutó la prueba.');

  final out = StringBuffer()
    ..writeln('<!doctype html>')
    ..writeln('<html lang="es">')
    ..writeln('<head>')
    ..writeln('<meta charset="utf-8">')
    ..writeln('<title>Suite de pruebas - ${_esc(appName)}</title>')
    ..writeln('<style>$_css</style>')
    ..writeln('</head>')
    ..writeln('<body>')
    ..writeln('<section class="stories">');

  for (final story in stories) {
    out
      ..writeln('<table class="story" id="${_anchor(story.id)}">')
      ..writeln(
        '<tr><td class="bar" colspan="4">'
        'HISTORIA: ${_esc(story.title.toUpperCase())}</td></tr>',
      )
      ..writeln(
        '<tr class="head"><th>ID</th>'
        '<th colspan="2">Descripción Historia de Usuario</th>'
        '<th>Criterios de Aceptación</th></tr>',
      )
      ..writeln(
        '<tr><td class="id" rowspan="3">${_esc(story.id)}</td>'
        '<td class="label">Como</td><td>${_esc(story.asA)}</td>'
        '<td class="criteria" rowspan="3">${_numbered(story.criteria, '.')}</td>'
        '</tr>',
      )
      ..writeln(
        '<tr><td class="label">Quiero</td><td>${_esc(story.iWant)}</td></tr>',
      )
      ..writeln(
        '<tr><td class="label">Para</td><td>${_esc(story.soThat)}</td></tr>',
      )
      ..writeln('</table>');
  }
  out
    ..writeln('</section>')
    ..writeln('<section class="suite" id="suite">')
    ..writeln('<table class="cases">')
    ..writeln(
      '<colgroup><col style="width:4%"><col style="width:11%">'
      '<col style="width:6%"><col style="width:12%"><col style="width:13%">'
      '<col style="width:24%"><col style="width:14%"><col style="width:10%">'
      '<col style="width:6%"></colgroup>',
    )
    ..writeln(
      '<thead>'
      '<tr><td class="bar" colspan="9">'
      'SUITE DE PRUEBAS - ${_esc(appName)}</td></tr>'
      '<tr class="head"><th>No</th><th>Caso de prueba</th><th>Prioridad</th>'
      '<th>Precondiciones</th><th>Datos de entrada</th><th>Pasos</th>'
      '<th>Resultados Esperado</th><th>Resultado Obtenido</th>'
      '<th>Estado prueba</th></tr>'
      '</thead>',
    )
    ..writeln('<tbody>');

  var number = 0;
  final counts = {for (final status in CaseStatus.values) status: 0};

  void row({
    required String id,
    required String title,
    required String priority,
    required String preconditions,
    required String input,
    required List<String> steps,
    required String expected,
    required String obtained,
    required CaseStatus status,
  }) {
    counts[status] = counts[status]! + 1;
    number++;
    out.writeln(
      '<tr>'
      '<td class="no">$number<span class="tc">${_esc(id)}</span></td>'
      '<td>${_esc(title)}</td>'
      '<td>$priority</td>'
      '<td>${_esc(preconditions)}</td>'
      '<td>${_esc(input)}</td>'
      '<td>${_numbered(steps, '.-')}</td>'
      '<td>${_esc(expected)}</td>'
      '<td>${_esc(obtained)}</td>'
      '<td class="status ${_statusClass(status)}">${_statusLabel(status)}</td>'
      '</tr>',
    );
  }

  for (final story in stories) {
    out.writeln(
      '<tr class="area" id="area-${_anchor(story.id)}"><td colspan="9">'
      'AREA FUNCIONAL: ${_esc(story.title)} (${_esc(story.id)})</td></tr>',
    );
    for (final id in story.caseIds) {
      final testCase = byId[id]!;
      final result = resultOf(id);
      row(
        id: id,
        title: testCase.title,
        priority: testCase.priority.label,
        preconditions: testCase.preconditions,
        input: testCase.input,
        steps: testCase.steps,
        expected: testCase.expected,
        obtained: _obtained(id, result),
        status: result.status,
      );
    }
    for (final manual in manualCases.where((m) => m.storyId == story.id)) {
      row(
        id: manual.id,
        title: manual.title,
        priority: manual.priority.label,
        preconditions: manual.preconditions,
        input: manual.input,
        steps: manual.steps,
        expected: manual.expected,
        obtained: manual.obtained.trim().isEmpty
            ? 'Pendiente de ejecutar.'
            : manual.obtained,
        status: switch (manual.status) {
          ManualStatus.ok => CaseStatus.aprobado,
          ManualStatus.fallo => CaseStatus.fallido,
          ManualStatus.pendiente => CaseStatus.pendiente,
        },
      );
    }
  }

  out
    ..writeln('</tbody>')
    ..writeln('</table>')
    ..writeln(
      '<p class="summary"><strong>Resumen:</strong> '
      '$number casos; '
      '${counts[CaseStatus.aprobado]} OK, '
      '${counts[CaseStatus.fallido]} FALLO, '
      '${counts[CaseStatus.pendiente]} pendientes.</p>',
    )
    ..writeln(
      '<p class="note">El número de la columna No sigue el orden de las '
      'áreas; debajo de él está el identificador del caso: TC-xx son pruebas '
      'automatizadas (<code>test/suite/cases.dart</code>), cuyo resultado y '
      'estado salen de ejecutar <code>flutter test test/suite</code>; MC-xx '
      'son casos manuales (<code>test/suite/manual_cases.dart</code>), cuyo '
      'resultado anota una persona al ejecutarlos. Documento generado con '
      '<code>dart run tool/generate_suite_report.dart</code> el '
      '${_date(generatedAt)}, con Flutter ${_esc(flutterVersion)} y Dart '
      '${_esc(dartVersion)}.</p>',
    )
    ..writeln('</section>')
    ..writeln('</body>')
    ..writeln('</html>');
  return out.toString();
}

/// The result of the run, plus which automated test produced it.
String _obtained(String id, CaseResult result) =>
    result.status == CaseStatus.aprobado
    ? '${result.obtained} Verificado por la prueba automatizada $id.'
    : result.obtained;

String _anchor(String id) => id.toLowerCase();

String _statusLabel(CaseStatus status) => switch (status) {
  CaseStatus.aprobado => 'OK',
  CaseStatus.fallido => 'FALLO',
  CaseStatus.pendiente => 'PENDIENTE',
};

String _statusClass(CaseStatus status) => switch (status) {
  CaseStatus.aprobado => 'ok',
  CaseStatus.fallido => 'fail',
  CaseStatus.pendiente => 'pending',
};

/// "1. first<br>2. second", with [separator] after the number.
String _numbered(List<String> items, String separator) => [
  for (var i = 0; i < items.length; i++) '${i + 1}$separator ${_esc(items[i])}',
].join('<br>');

String _date(DateTime date) =>
    '${date.year}-${date.month.toString().padLeft(2, '0')}-'
    '${date.day.toString().padLeft(2, '0')}';

String _esc(String text) => text
    .replaceAll('&', '&amp;')
    .replaceAll('<', '&lt;')
    .replaceAll('>', '&gt;')
    .replaceAll('"', '&quot;');

const _css = '''
@page { size: A4 landscape; margin: 10mm; }
* { box-sizing: border-box; }
body { font-family: Calibri, Arial, sans-serif; font-size: 10pt; color: #111; margin: 0; }
table { border-collapse: collapse; width: 100%; }
.cases { table-layout: fixed; }
td, th { border: 1px solid #1f1f1f; padding: 4px 6px; vertical-align: top; text-align: left; }
.bar { background: #2f5496; color: #fff; font-size: 13pt; font-weight: bold; }
.head th { background: #bdd6ee; text-align: center; font-weight: bold; }
.stories { margin-bottom: 8mm; }
.story { margin-bottom: 6mm; break-inside: avoid; }
.story .id { background: #bdd6ee; font-size: 14pt; text-align: center; vertical-align: middle; width: 22mm; font-weight: bold; white-space: nowrap; }
.story .label { background: #bdd6ee; width: 22mm; font-weight: bold; }
.story .criteria { width: 45%; }
.suite { break-before: page; }
.cases thead { display: table-header-group; }
.cases tr { break-inside: avoid; }
.cases .area td { background: #d9e2f3; font-weight: bold; }
.cases .no { text-align: center; font-weight: bold; width: 11mm; }
.cases .tc { display: block; font-weight: normal; font-size: 7pt; color: #444; }
.cases td { font-size: 8.5pt; }
.status { text-align: center; font-weight: bold; vertical-align: middle; width: 17mm; }
.status.ok { background: #c6efce; color: #006100; }
.status.fail { background: #ffc7ce; color: #9c0006; }
.status.pending { background: #ffeb9c; color: #7f6000; }
.summary { margin: 4mm 0 1mm; }
.note { font-size: 8pt; color: #444; margin: 0; }
code { font-family: Consolas, monospace; font-size: 8pt; }
''';
