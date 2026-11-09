import 'dart:async';

import 'package:flutter_test/flutter_test.dart';

enum Priority {
  alta('Alta'),
  media('Media'),
  baja('Baja');

  const Priority(this.label);
  final String label;
}

/// Documented test case: the fields the suite reports for every case.
///
/// The case id leads the test name, so the report can match each result
/// with its definition.
class TestCase {
  const TestCase({
    required this.id,
    required this.title,
    required this.priority,
    required this.requirements,
    required this.preconditions,
    required this.input,
    required this.steps,
    required this.expected,
  });

  final String id;
  final String title;
  final Priority priority;
  final List<String> requirements;
  final String preconditions;
  final String input;
  final List<String> steps;
  final String expected;

  String get name => '$id $title';

  /// Returns every problem found, so a case can be fixed in one pass.
  List<String> validate() {
    final problems = <String>[];
    if (!RegExp(r'^TC-\d{2}$').hasMatch(id)) {
      problems.add('$id: el identificador debe tener el formato TC-01.');
    }
    final text = {
      'title': title,
      'preconditions': preconditions,
      'input': input,
      'expected': expected,
    };
    for (final entry in text.entries) {
      if (entry.value.trim().isEmpty) {
        problems.add('$id: falta ${entry.key}.');
      }
    }
    if (requirements.isEmpty) problems.add('$id: falta el requerimiento.');
    if (steps.isEmpty || steps.any((step) => step.trim().isEmpty)) {
      problems.add('$id: los pasos están vacíos o incompletos.');
    }
    return problems;
  }
}

/// Registers a documented case as a plain test.
void suiteTest(TestCase testCase, FutureOr<void> Function() body) =>
    test(testCase.name, body);

/// Registers a documented case as a widget test.
void suiteWidgetTest(
  TestCase testCase,
  Future<void> Function(WidgetTester tester) body,
) => testWidgets(testCase.name, body);
