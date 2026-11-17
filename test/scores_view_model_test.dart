import 'dart:async';

import 'package:bearstards_movil_application/features/results/domain/models/player_score.dart';
import 'package:bearstards_movil_application/features/results/domain/repositories/results_repository.dart';
import 'package:bearstards_movil_application/features/results/presentation/view_models/scores_view_model.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/results_fakes.dart';

void main() {
  final ranking = [
    testScore('memo', points: 600),
    testScore('CarlOso', points: 500),
  ];

  ScoresViewModel modelFor(FakeResultsRepository repository) {
    final model = ScoresViewModel(repository);
    addTearDown(model.dispose);
    return model;
  }

  test('starts idle, with nothing to show and nothing requested', () {
    final repository = FakeResultsRepository.always(ranking);
    final model = modelFor(repository);
    expect(model.status, ScoresStatus.idle);
    expect(model.ranking, isEmpty);
    expect(model.isLoading, isFalse);
    expect(model.hasData, isFalse);
    expect(repository.calls, 0);
  });

  test('loading shows the loading state, then the ranking in order', () async {
    final model = modelFor(FakeResultsRepository.always(ranking));
    final seen = <ScoresStatus>[];
    model.addListener(() => seen.add(model.status));

    final pending = model.load();
    expect(model.status, ScoresStatus.loading);
    expect(model.isLoading, isTrue);

    await pending;
    expect(model.status, ScoresStatus.loaded);
    expect(model.ranking.map((p) => p.username), ['memo', 'CarlOso']);
    expect(model.isLoading, isFalse);
    expect(model.error, isNull);
    expect(seen, [ScoresStatus.loading, ScoresStatus.loaded]);
  });

  test('an empty ranking is the empty state, not an error', () async {
    final model = modelFor(FakeResultsRepository.always(const []));
    await model.load();
    expect(model.status, ScoresStatus.empty);
    expect(model.hasData, isTrue);
    expect(model.error, isNull);
    expect(model.isStale, isFalse);
  });

  test(
    'a first failure is the failed state, and retrying can recover',
    () async {
      final model = modelFor(
        FakeResultsRepository([
          () => throw const ResultsUnavailable('sin red'),
          () => ranking,
        ]),
      );
      await model.load();
      expect(model.status, ScoresStatus.failed);
      expect(model.error, isA<ResultsUnavailable>());
      expect(model.hasData, isFalse);
      expect(model.isStale, isFalse);

      await model.load();
      expect(model.status, ScoresStatus.loaded);
      expect(model.error, isNull);
      expect(model.ranking, hasLength(2));
    },
  );

  test('a format error is reported as such', () async {
    final model = modelFor(
      FakeResultsRepository.failing(const ResultsFormatError('mal formado')),
    );
    await model.load();
    expect(model.status, ScoresStatus.failed);
    expect(model.error, isA<ResultsFormatError>());
  });

  test(
    'refreshing keeps showing the data while it loads, then updates it',
    () async {
      final newer = [testScore('Nuevo', points: 900)];
      final model = modelFor(
        FakeResultsRepository([() => ranking, () => newer]),
      );
      await model.load();

      final pending = model.load();
      expect(model.status, ScoresStatus.loaded, reason: 'no vuelve a cargando');
      expect(model.isLoading, isTrue);
      expect(model.ranking, hasLength(2));

      await pending;
      expect(model.ranking.map((p) => p.username), ['Nuevo']);
      expect(model.isLoading, isFalse);
    },
  );

  test(
    'a failed refresh keeps the last good data and marks it stale',
    () async {
      final model = modelFor(
        FakeResultsRepository([
          () => ranking,
          () => throw const ResultsUnavailable('sin red'),
          () => ranking,
        ]),
      );
      await model.load();
      expect(model.isStale, isFalse);

      await model.load();
      expect(model.status, ScoresStatus.loaded);
      expect(model.ranking, hasLength(2));
      expect(model.error, isA<ResultsUnavailable>());
      expect(model.isStale, isTrue);

      await model.load();
      expect(
        model.isStale,
        isFalse,
        reason: 'una recarga buena quita el aviso',
      );
      expect(model.error, isNull);
    },
  );

  test(
    'a refresh that finds the ranking empty replaces the old data',
    () async {
      final model = modelFor(
        FakeResultsRepository([() => ranking, () => const []]),
      );
      await model.load();
      await model.load();
      expect(model.status, ScoresStatus.empty);
      expect(model.ranking, isEmpty);
    },
  );

  test('calls made while a request runs share it', () async {
    final answer = Completer<List<PlayerScore>>();
    final repository = FakeResultsRepository([() => answer.future]);
    final model = modelFor(repository);

    final first = model.load();
    final second = model.load();
    expect(identical(first, second), isTrue);

    answer.complete(ranking);
    await Future.wait([first, second]);
    expect(repository.calls, 1);
    expect(model.status, ScoresStatus.loaded);
  });

  test('an unexpected error still leaves the loading state', () async {
    final model = modelFor(
      FakeResultsRepository([() => throw StateError('bug')]),
    );
    await model.load();
    expect(model.status, ScoresStatus.failed);
    expect(model.error, isA<ResultsUnavailable>());
    expect(model.isLoading, isFalse);
  });

  test('answering after the model was disposed does nothing', () async {
    final answer = Completer<List<PlayerScore>>();
    final model = ScoresViewModel(FakeResultsRepository([() => answer.future]));
    final pending = model.load();

    model.dispose();
    answer.complete(ranking);
    await expectLater(pending, completes);
  });
}
