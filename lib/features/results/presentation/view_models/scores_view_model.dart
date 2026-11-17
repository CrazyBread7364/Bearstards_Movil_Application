import 'package:flutter/foundation.dart';

import '../../domain/models/player_score.dart';
import '../../domain/repositories/results_repository.dart';

enum ScoresStatus {
  /// Nothing requested yet.
  idle,

  /// The first load, with nothing to show yet.
  loading,
  loaded,

  /// The server answered with no players.
  empty,

  /// The first load failed, so there is nothing to show but the error.
  failed,
}

/// State of the global results screen.
///
/// One instance lives for the whole app session, so the last good ranking
/// stays available when the screen is opened again or when a refresh fails:
/// the player then keeps seeing the data with a warning instead of an error.
class ScoresViewModel extends ChangeNotifier {
  ScoresViewModel(this._repository);

  final ResultsRepository _repository;
  var _status = ScoresStatus.idle;
  var _ranking = const <PlayerScore>[];
  ResultsException? _error;
  Future<void>? _inFlight;
  var _disposed = false;

  ScoresStatus get status => _status;

  /// The last ranking that loaded well, best player first.
  List<PlayerScore> get ranking => _ranking;

  /// Why the last attempt failed; null when it worked.
  ResultsException? get error => _error;

  /// A request is running, including a refresh over data already shown.
  bool get isLoading => _inFlight != null;

  bool get hasData =>
      _status == ScoresStatus.loaded || _status == ScoresStatus.empty;

  /// The data on screen is the last good one, because the newest attempt
  /// failed.
  bool get isStale => hasData && _error != null;

  /// Loads the ranking, or reloads it. Calls made while a request is running
  /// share that request instead of starting another one.
  Future<void> load() => _inFlight ??= _run();

  Future<void> _run() async {
    if (!hasData) _status = ScoresStatus.loading;
    _notify();
    try {
      final ranking = await _repository.ranking();
      _ranking = ranking;
      _status = ranking.isEmpty ? ScoresStatus.empty : ScoresStatus.loaded;
      _error = null;
    } on ResultsException catch (error) {
      _fail(error);
    } catch (_) {
      // Whatever went wrong, the screen must leave the loading state.
      _fail(const ResultsUnavailable('No se pudieron cargar los resultados.'));
    } finally {
      _inFlight = null;
      _notify();
    }
  }

  void _fail(ResultsException error) {
    _error = error;
    if (!hasData) _status = ScoresStatus.failed;
  }

  void _notify() {
    if (!_disposed) notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}
