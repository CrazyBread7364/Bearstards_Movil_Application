import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import '../../tool/verify_environment.dart';
import 'cases.dart';
import 'test_case.dart';

void main() {
  suiteTest(tc13, () {
    final baseline = readConfiguration(File('toolchain.json'));
    for (final key in toolchainKeys) {
      expect(baseline[key], isA<String>(), reason: 'toolchain.json: $key');
      expect((baseline[key] as String).trim(), isNotEmpty, reason: key);
    }

    expect(toolchainDifferences(baseline, baseline), isEmpty);

    for (final key in toolchainKeys) {
      final altered = {...baseline, key: 'different'};
      final differences = toolchainDifferences(baseline, altered);
      expect(differences, hasLength(1), reason: key);
      expect(differences.single, startsWith('$key:'));
    }

    expect(toolchainDifferences(baseline, {}), hasLength(toolchainKeys.length));
  });
}
