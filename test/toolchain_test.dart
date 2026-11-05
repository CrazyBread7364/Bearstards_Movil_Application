import 'package:flutter_test/flutter_test.dart';

import '../tool/verify_environment.dart';

void main() {
  const expected = <String, Object?>{
    'flutterVersion': '3.47.6',
    'flutterChannel': 'stable',
    'flutterRevision': 'reference-revision',
    'dartVersion': '3.13.5',
  };

  test('matching SDK metadata passes without changing the configurations', () {
    expect(toolchainDifferences(expected, expected), isEmpty);
  });

  for (final key in toolchainKeys) {
    test('a different $key is rejected even when other fields match', () {
      final actual = {...expected, key: 'different'};
      final differences = toolchainDifferences(expected, actual);
      expect(differences, hasLength(1));
      expect(differences.single, startsWith('$key:'));
    });
  }

  test('missing SDK metadata and incomplete baseline are reported', () {
    expect(toolchainDifferences(expected, {}).length, toolchainKeys.length);
    final incomplete = {...expected}..remove('dartVersion');
    expect(
      toolchainDifferences(incomplete, expected).single,
      contains('Configuración inválida'),
    );
  });
}
