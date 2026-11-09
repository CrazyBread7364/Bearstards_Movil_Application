import 'dart:convert';

enum CaseStatus {
  aprobado('Aprobado'),
  fallido('Fallido'),
  pendiente('Pendiente');

  const CaseStatus(this.label);
  final String label;
}

class CaseResult {
  const CaseResult(this.status, this.obtained);
  final CaseStatus status;
  final String obtained;
}

final _caseName = RegExp(r'^(TC-\d{2}) ');

/// Reads the output of `flutter test --reporter json` and returns one result
/// per documented case, keyed by its id (the test name starts with it).
///
/// Tests that are not documented cases, hidden internal tests and lines that
/// are not JSON are ignored.
Map<String, CaseResult> parseSuiteResults(Iterable<String> lines) {
  final caseIds = <int, String>{};
  final errors = <int, String>{};
  final results = <String, CaseResult>{};

  for (final line in lines) {
    final Object? event;
    try {
      event = jsonDecode(line);
    } on FormatException {
      continue;
    }
    if (event is! Map<String, dynamic>) continue;
    final data = event;

    switch (data['type']) {
      case 'testStart':
        final test = data['test'];
        if (test is! Map<String, dynamic>) break;
        final match = _caseName.firstMatch('${test['name']}');
        if (match != null) caseIds[test['id'] as int] = match.group(1)!;
      case 'error':
        final id = data['testID'];
        if (id is int && caseIds.containsKey(id)) {
          errors.putIfAbsent(id, () => '${data['error']}');
        }
      case 'testDone':
        final id = data['testID'];
        if (id is! int) break;
        final caseId = caseIds[id];
        if (caseId == null) break;
        results[caseId] = _resultOf(data, errors[id]);
    }
  }
  return results;
}

CaseResult _resultOf(Map<String, dynamic> done, String? error) {
  if (done['skipped'] == true) {
    return const CaseResult(CaseStatus.pendiente, 'La prueba fue omitida.');
  }
  if (done['result'] == 'success') {
    return const CaseResult(
      CaseStatus.aprobado,
      'Coincide con el resultado esperado.',
    );
  }
  return CaseResult(
    CaseStatus.fallido,
    'No coincide: ${summarizeError(error ?? 'sin detalle')}',
  );
}

/// Collapses a multi-line failure message into one short line.
String summarizeError(String error, {int maxLength = 240}) {
  final oneLine = error
      .split('\n')
      .map((line) => line.trim())
      .where((line) => line.isNotEmpty)
      .join(' ');
  if (oneLine.length <= maxLength) return oneLine;
  return '${oneLine.substring(0, maxLength - 1)}…';
}

/// Gives every documented case a result; cases that never ran are pending.
Map<String, CaseResult> completeResults(
  Iterable<String> caseIds,
  Map<String, CaseResult> results,
) => {
  for (final id in caseIds)
    id:
        results[id] ??
        const CaseResult(CaseStatus.pendiente, 'No se ejecutó la prueba.'),
};
