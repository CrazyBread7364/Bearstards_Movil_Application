import 'dart:convert';
import 'dart:io';

const toolchainKeys = [
  'flutterVersion',
  'flutterChannel',
  'flutterRevision',
  'dartVersion',
];

/// Returns every mismatch so a developer can fix the environment in one pass.
List<String> toolchainDifferences(
  Map<String, Object?> expected,
  Map<String, Object?> actual,
) {
  final differences = <String>[];
  for (final key in toolchainKeys) {
    final value = expected[key];
    if (value is! String || value.trim().isEmpty) {
      differences.add('Configuración inválida: falta un valor para $key.');
    } else if (actual[key] != value) {
      differences.add(
        '$key: se requiere $value; se encontró ${actual[key] ?? "sin dato"}.',
      );
    }
  }
  return differences;
}

Map<String, Object?> readConfiguration(File file) {
  final decoded = jsonDecode(file.readAsStringSync());
  if (decoded is! Map<String, dynamic>) {
    throw FormatException('Se esperaba un objeto JSON en ${file.path}.');
  }
  return decoded;
}

/// Uses the Dart executable's own Flutter SDK, not another SDK found on PATH.
void main() {
  try {
    final expected = readConfiguration(
      File.fromUri(Platform.script.resolve('../toolchain.json')),
    );
    final dartExecutable = File(Platform.resolvedExecutable)
        .resolveSymbolicLinksSync();
    final dartSdk = File(dartExecutable).parent.parent;
    final flutterSdk = dartSdk.parent.parent.parent;
    final metadata = File.fromUri(
      flutterSdk.uri.resolve('bin/cache/flutter.version.json'),
    );
    if (!metadata.existsSync()) {
      stderr.writeln(
        'No se encontró el SDK de Flutter asociado a este Dart. '
        'Ejecuta el script con el Dart incluido en Flutter.',
      );
      exitCode = 1;
      return;
    }
    final flutter = readConfiguration(metadata);
    final actual = <String, Object?>{
      'flutterVersion': flutter['frameworkVersion'],
      'flutterChannel': flutter['channel'],
      'flutterRevision': flutter['frameworkRevision'],
      'dartVersion': Platform.version.split(' ').first,
    };
    final differences = toolchainDifferences(expected, actual);
    if (differences.isNotEmpty) {
      stderr.writeln('El entorno no coincide con toolchain.json:');
      for (final difference in differences) {
        stderr.writeln('- $difference');
      }
      exitCode = 1;
      return;
    }
    stdout.writeln(
      'Entorno validado: Flutter ${actual["flutterVersion"]} '
      '(${actual["flutterChannel"]}), Dart ${actual["dartVersion"]}.',
    );
  } on FileSystemException catch (error) {
    stderr.writeln(
      'No se pudo leer la configuración del entorno: ${error.message}',
    );
    exitCode = 1;
  } on FormatException catch (error) {
    stderr.writeln('Configuración del entorno inválida: ${error.message}');
    exitCode = 1;
  }
}
