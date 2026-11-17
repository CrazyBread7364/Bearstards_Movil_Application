import '../models/player_score.dart';

/// Source of the global results. The screen depends on this contract, not on
/// how the data is fetched.
abstract interface class ResultsRepository {
  /// The top players, best first.
  Future<List<PlayerScore>> ranking();
}

/// Why the results could not be loaded.
sealed class ResultsException implements Exception {
  const ResultsException(this.message);
  final String message;

  @override
  String toString() => '$runtimeType: $message';
}

/// No connection, a timeout, or the server answered with an error.
final class ResultsUnavailable extends ResultsException {
  const ResultsUnavailable(super.message);
}

/// The server answered, but not with the data the contract promises.
final class ResultsFormatError extends ResultsException {
  const ResultsFormatError(super.message);
}
