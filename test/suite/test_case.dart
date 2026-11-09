import 'dart:async';

import 'package:flutter_test/flutter_test.dart';

import 'test_case_model.dart';

export 'test_case_model.dart';

/// Registers a documented case as a plain test.
void suiteTest(TestCase testCase, FutureOr<void> Function() body) =>
    test(testCase.name, body);

/// Registers a documented case as a widget test.
void suiteWidgetTest(
  TestCase testCase,
  Future<void> Function(WidgetTester tester) body,
) => testWidgets(testCase.name, body);
