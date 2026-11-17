import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:bearstards_movil_application/features/results/data/http_results_repository.dart';
import 'package:bearstards_movil_application/features/results/domain/repositories/results_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

/// Two players copied from the real response of the production API, one of
/// them with no games and one with an accent in the name.
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

http.Response json(String body, [int status = 200]) => http.Response.bytes(
  utf8.encode(body),
  status,
  headers: {'content-type': 'application/json; charset=utf-8'},
);

void main() {
  test('reads the ranking in the order the server sends it', () async {
    final ranking = await repositoryFor((_) async => json(_body)).ranking();
    expect(ranking.map((p) => p.username), ['memo', 'Ñandú']);
    expect(ranking.first.totalPoints, 600);
    expect(ranking.last.winRate, isNull);
  });

  test('keeps accents in names even when the header has no charset', () async {
    final ranking = await repositoryFor(
      (_) async => http.Response.bytes(utf8.encode(_body), 200),
    ).ranking();
    expect(ranking.last.username, 'Ñandú');
  });

  test('asks the public ranking address and sends no credentials', () async {
    late http.Request seen;
    await repositoryFor((request) async {
      seen = request;
      return json('[]');
    }).ranking();
    expect(seen.method, 'GET');
    expect(seen.url.toString(), 'https://example.test/api/ranking/');
    expect(seen.headers['Accept'], 'application/json');
    expect(seen.headers.containsKey('Authorization'), isFalse);
  });

  test('an empty ranking is a valid, empty list', () async {
    final ranking = await repositoryFor((_) async => json('[]')).ranking();
    expect(ranking, isEmpty);
  });

  test('the returned list cannot be modified', () async {
    final ranking = await repositoryFor((_) async => json(_body)).ranking();
    expect(() => ranking.clear(), throwsUnsupportedError);
  });

  for (final status in [400, 404, 429, 500, 503]) {
    test('a server answer $status means the results are unavailable', () {
      expect(
        repositoryFor((_) async => json('{"detail":"x"}', status)).ranking(),
        throwsA(
          isA<ResultsUnavailable>().having(
            (e) => e.message,
            'message',
            contains('$status'),
          ),
        ),
      );
    });
  }

  test('no connection means the results are unavailable', () {
    expect(
      repositoryFor((_) async => throw const SocketException('sin red'))
          .ranking(),
      throwsA(isA<ResultsUnavailable>()),
    );
    expect(
      repositoryFor((_) async => throw http.ClientException('sin red'))
          .ranking(),
      throwsA(isA<ResultsUnavailable>()),
    );
  });

  test('a server that never answers times out as unavailable', () {
    final never = Completer<http.Response>();
    expect(
      repositoryFor(
        (_) => never.future,
        timeout: const Duration(milliseconds: 50),
      ).ranking(),
      throwsA(isA<ResultsUnavailable>()),
    );
  });

  group('an answer that breaks the contract is a format error', () {
    for (final (name, body) in [
      ('text that is not JSON', 'no es json'),
      ('an object instead of a list', '{"id":1}'),
      ('a list of numbers', '[1,2,3]'),
      ('a player without points', '[{"id":1,"username":"a"}]'),
      (
        'points as text',
        '[{"id":1,"username":"a","partidas":1,"victorias":1,"derrotas":0,'
            '"empates":0,"kills":0,"puntos_totales":"600","mejor_puntuacion":1}]',
      ),
    ]) {
      test(name, () {
        expect(
          repositoryFor((_) async => json(body)).ranking(),
          throwsA(isA<ResultsFormatError>()),
        );
      });
    }
  });
}
