import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../domain/models/player_score.dart';
import '../domain/repositories/results_repository.dart';

/// Reads the public ranking of the web API. It sends no credentials: the
/// ranking is public, so the app never handles a password or a token here.
class HttpResultsRepository implements ResultsRepository {
  HttpResultsRepository({
    required this.baseUrl,
    http.Client? client,
    this.timeout = const Duration(seconds: 10),
  }) : _client = client ?? http.Client();

  final String baseUrl;
  final Duration timeout;
  final http.Client _client;

  @override
  Future<List<PlayerScore>> ranking() async {
    final http.Response response;
    try {
      response = await _client
          .get(
            Uri.parse('$baseUrl/ranking/'),
            headers: const {'Accept': 'application/json'},
          )
          .timeout(timeout);
    } on TimeoutException {
      throw const ResultsUnavailable(
        'El servidor tardó demasiado en responder.',
      );
    } on SocketException {
      throw const ResultsUnavailable('No hay conexión con el servidor.');
    } on http.ClientException {
      throw const ResultsUnavailable('No hay conexión con el servidor.');
    }

    if (response.statusCode != 200) {
      throw ResultsUnavailable(
        'El servidor respondió con el código ${response.statusCode}.',
      );
    }
    return _parse(response);
  }

  List<PlayerScore> _parse(http.Response response) {
    try {
      final data = jsonDecode(utf8.decode(response.bodyBytes));
      if (data is! List) {
        throw const FormatException('Se esperaba una lista de jugadores.');
      }
      return List.unmodifiable([
        for (final item in data)
          if (item is Map<String, Object?>)
            PlayerScore.fromJson(item)
          else
            throw const FormatException('Un jugador no es un objeto JSON.'),
      ]);
    } on FormatException catch (error) {
      throw ResultsFormatError(error.message);
    }
  }
}
