import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:bearstards_movil_application/features/results/data/http_results_repository.dart';
import 'package:bearstards_movil_application/features/results/domain/repositories/results_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

import 'cases.dart';
import 'test_case.dart';

/// Two players in the real format of `GET /api/ranking/`: one with an accent
/// in the name and one with no games.
const _body =
    '[{"id":9,"username":"memo","partidas":2,"victorias":2,"derrotas":0,'
    '"empates":0,"kills":3,"puntos_totales":600,"mejor_puntuacion":400},'
    '{"id":5,"username":"Ñandú","partidas":0,"victorias":0,"derrotas":0,'
    '"empates":0,"kills":0,"puntos_totales":0,"mejor_puntuacion":0}]';

HttpResultsRepository repositoryFor(
  Future<http.Response> Function(http.Request) handler, {
  Duration timeout = const Duration(seconds: 10),
}) => HttpResultsRepository(
  baseUrl: 'https://example.test/api',
  client: MockClient(handler),
  timeout: timeout,
);

http.Response answer(String body, [int status = 200]) =>
    http.Response.bytes(utf8.encode(body), status);

void main() {
  suiteTest(tc27, () async {
    final ranking = await repositoryFor((_) async => answer(_body)).ranking();

    expect(ranking.map((p) => p.username), ['memo', 'Ñandú']);
    final first = ranking.first;
    expect(first.id, 9);
    expect(first.games, 2);
    expect(first.wins, 2);
    expect(first.losses, 0);
    expect(first.draws, 0);
    expect(first.kills, 3);
    expect(first.totalPoints, 600);
    expect(first.bestScore, 400);
    expect(ranking.last.winRate, isNull);
    expect(() => ranking.clear(), throwsUnsupportedError);
  });

  suiteTest(tc28, () async {
    Future<Object?> outcome(
      Future<http.Response> Function(http.Request) handler, {
      Duration timeout = const Duration(seconds: 10),
    }) async {
      try {
        await repositoryFor(handler, timeout: timeout).ranking();
        return null;
      } on ResultsException catch (error) {
        return error;
      }
    }

    for (final status in [404, 500, 503]) {
      expect(
        await outcome((_) async => answer('{"detail":"x"}', status)),
        isA<ResultsUnavailable>(),
        reason: 'código $status',
      );
    }
    expect(
      await outcome((_) async => throw const SocketException('sin red')),
      isA<ResultsUnavailable>(),
      reason: 'sin conexión',
    );
    expect(
      await outcome(
        (_) => Completer<http.Response>().future,
        timeout: const Duration(milliseconds: 50),
      ),
      isA<ResultsUnavailable>(),
      reason: 'tiempo agotado',
    );

    expect(
      await outcome((_) async => answer('no es json')),
      isA<ResultsFormatError>(),
      reason: 'texto que no es JSON',
    );
    expect(
      await outcome((_) async => answer('[{"id":1,"username":"a"}]')),
      isA<ResultsFormatError>(),
      reason: 'jugador sin puntos',
    );
  });

  suiteTest(tc29, () async {
    late http.Request seen;
    await repositoryFor((request) async {
      seen = request;
      return answer('[]');
    }).ranking();

    expect(seen.method, 'GET');
    expect(seen.url.toString(), 'https://example.test/api/ranking/');
    expect(seen.headers['Accept'], 'application/json');
    expect(seen.headers.containsKey('Authorization'), isFalse);
    expect(seen.headers.containsKey('Cookie'), isFalse);
    expect(seen.body, isEmpty);
  });
}
