import 'dart:convert';
import 'dart:io';

import '../test/suite/cases.dart';
import '../test/suite/manual_cases.dart';
import '../test/suite/user_stories.dart';
import 'suite_report.dart';
import 'suite_report_render.dart';
import 'verify_environment.dart' show readConfiguration;

const appName = 'Bearstards Wiki (aplicación móvil Flutter)';
const defaultOutput = 'docs/entrega/suite-de-pruebas.html';

class Options {
  const Options({
    this.out = defaultOutput,
    this.fromJson,
    this.pdf = false,
    this.browser,
  });

  /// HTML file to write. The PDF, if requested, uses the same name.
  final String out;

  /// Reads the output of a previous `flutter test --reporter json` instead of
  /// running the suite.
  final String? fromJson;
  final bool pdf;

  /// Chrome or Edge executable; looked up automatically when null.
  final String? browser;
}

const usage =
    '''
Uso: dart run tool/generate_suite_report.dart [opciones]

Ejecuta la suite (flutter test test/suite) y genera el documento de entrega
con las historias de usuario y la suite de pruebas.

  --out=<archivo>        HTML de salida (por defecto $defaultOutput)
  --pdf                  genera también el PDF, con Chrome o Edge
  --browser=<ruta>       navegador para el PDF si no se encuentra solo
  --from-json=<archivo>  usa una salida JSON ya guardada en vez de ejecutar
  --help                 muestra esta ayuda
''';

/// Reads the command line. Throws a [FormatException] for anything unknown, so
/// a typo fails loudly instead of being ignored.
Options parseOptions(List<String> args) {
  var options = const Options();
  for (final arg in args) {
    if (arg == '--pdf') {
      options = Options(
        out: options.out,
        fromJson: options.fromJson,
        pdf: true,
        browser: options.browser,
      );
    } else if (arg.startsWith('--out=')) {
      options = Options(
        out: arg.substring(6),
        fromJson: options.fromJson,
        pdf: options.pdf,
        browser: options.browser,
      );
    } else if (arg.startsWith('--from-json=')) {
      options = Options(
        out: options.out,
        fromJson: arg.substring(12),
        pdf: options.pdf,
        browser: options.browser,
      );
    } else if (arg.startsWith('--browser=')) {
      options = Options(
        out: options.out,
        fromJson: options.fromJson,
        pdf: options.pdf,
        browser: arg.substring(10),
      );
    } else {
      throw FormatException('Opción desconocida: $arg');
    }
  }
  return options;
}

/// Turns the JSON lines of a test run into the HTML document.
String buildHtml(
  Iterable<String> jsonLines, {
  required DateTime now,
  required String flutterVersion,
  required String dartVersion,
}) {
  final results = completeResults(
    suiteCases.map((c) => c.id),
    parseSuiteResults(jsonLines),
  );
  return renderSuiteHtml(
    appName: appName,
    stories: userStories,
    cases: suiteCases,
    manualCases: manualCases,
    results: results,
    generatedAt: now,
    flutterVersion: flutterVersion,
    dartVersion: dartVersion,
  );
}

/// 1 when any case failed, so the command can guard a pipeline.
int exitCodeFor(Map<String, CaseResult> results) =>
    results.values.any((r) => r.status == CaseStatus.fallido) ? 1 : 0;

Future<void> main(List<String> args) async {
  if (args.contains('--help')) {
    stdout.write(usage);
    return;
  }
  final Options options;
  try {
    options = parseOptions(args);
  } on FormatException catch (error) {
    stderr
      ..writeln(error.message)
      ..write(usage);
    exitCode = 64;
    return;
  }

  final saved = options.fromJson;
  if (saved != null && !File(saved).existsSync()) {
    stderr.writeln('No existe el archivo de --from-json: $saved');
    exitCode = 66;
    return;
  }
  final lines = saved != null
      ? File(saved).readAsLinesSync()
      : await _runSuite();
  if (lines == null) return;

  final results = completeResults(
    suiteCases.map((c) => c.id),
    parseSuiteResults(lines),
  );
  final toolchain = readConfiguration(File('toolchain.json'));
  final html = buildHtml(
    lines,
    now: DateTime.now(),
    flutterVersion: '${toolchain['flutterVersion']}',
    dartVersion: '${toolchain['dartVersion']}',
  );

  final output = File(options.out)..createSync(recursive: true);
  output.writeAsStringSync(html);
  stdout.writeln('Documento generado: ${options.out}');
  _printSummary(results);

  if (options.pdf) {
    final pdf = await _printPdf(output, options.browser);
    if (pdf == null) {
      exitCode = 2;
      return;
    }
    stdout.writeln('PDF generado: ${pdf.path}');
  }
  exitCode = exitCodeFor(results);
}

Future<List<String>?> _runSuite() async {
  stdout.writeln('Ejecutando flutter test test/suite ...');
  final run = await Process.run('flutter', [
    'test',
    'test/suite',
    '--no-pub',
    '--reporter',
    'json',
  ], runInShell: true);
  final lines = const LineSplitter().convert('${run.stdout}');
  if (!lines.any((line) => line.contains('"type":"done"'))) {
    stderr.writeln('flutter test no terminó correctamente:\n${run.stderr}');
    exitCode = 2;
    return null;
  }
  return lines;
}

void _printSummary(Map<String, CaseResult> results) {
  final count = {for (final s in CaseStatus.values) s: 0};
  for (final result in results.values) {
    count[result.status] = count[result.status]! + 1;
  }
  stdout.writeln(
    'Automatizados: ${results.length} | OK ${count[CaseStatus.aprobado]} | '
    'FALLO ${count[CaseStatus.fallido]} | '
    'PENDIENTE ${count[CaseStatus.pendiente]}',
  );
  int manual(ManualStatus status) =>
      manualCases.where((m) => m.status == status).length;
  stdout.writeln(
    'Manuales: ${manualCases.length} | OK ${manual(ManualStatus.ok)} | '
    'FALLO ${manual(ManualStatus.fallo)} | '
    'PENDIENTE ${manual(ManualStatus.pendiente)}',
  );
}

/// Prints the HTML to PDF with a headless Chrome or Edge.
Future<File?> _printPdf(File html, String? browserPath) async {
  final browser = browserPath ?? _findBrowser();
  if (browser == null) {
    stderr.writeln(
      'No se encontró Chrome ni Edge. Indica uno con --browser=<ruta>.',
    );
    return null;
  }
  final pdf = File(html.path.replaceAll(RegExp(r'\.html?$'), '.pdf'));
  final result = await Process.run(browser, [
    '--headless=new',
    '--disable-gpu',
    '--no-pdf-header-footer',
    '--print-to-pdf=${pdf.absolute.path}',
    Uri.file(html.absolute.path).toString(),
  ]);
  if (!pdf.existsSync()) {
    stderr.writeln('El navegador no generó el PDF:\n${result.stderr}');
    return null;
  }
  return pdf;
}

String? _findBrowser() {
  for (final path in const [
    r'C:\Program Files\Google\Chrome\Application\chrome.exe',
    r'C:\Program Files (x86)\Google\Chrome\Application\chrome.exe',
    r'C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe',
    '/Applications/Google Chrome.app/Contents/MacOS/Google Chrome',
    '/usr/bin/google-chrome',
    '/usr/bin/chromium',
  ]) {
    if (File(path).existsSync()) return path;
  }
  return null;
}
