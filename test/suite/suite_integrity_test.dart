import 'package:flutter_test/flutter_test.dart';

import 'cases.dart';
import 'manual_cases.dart';
import 'user_stories.dart';
import 'test_case.dart';

void main() {
  const valid = TestCase(
    id: 'TC-01',
    title: 'Ejemplo',
    priority: Priority.alta,
    requirements: ['RF-01'],
    preconditions: 'App iniciada',
    input: 'Un toque',
    steps: ['Tocar'],
    expected: 'Se abre la pantalla',
  );

  test('a complete case has no problems and a searchable name', () {
    expect(valid.validate(), isEmpty);
    expect(valid.name, 'TC-01 Ejemplo');
  });

  test('an incomplete case reports every problem at once', () {
    const broken = TestCase(
      id: 'T1',
      title: ' ',
      priority: Priority.baja,
      requirements: [],
      preconditions: '',
      input: 'x',
      steps: [],
      expected: 'y',
    );
    expect(broken.validate(), hasLength(5));
  });

  test('every registered case is complete and its id is unique', () {
    final problems = [for (final c in suiteCases) ...c.validate()];
    expect(problems, isEmpty);
    final ids = suiteCases.map((c) => c.id).toList();
    expect(ids.toSet(), hasLength(ids.length));
  });

  test('every case belongs to exactly one user story', () {
    final owners = <String, List<String>>{};
    for (final story in userStories) {
      for (final id in story.caseIds) {
        owners.putIfAbsent(id, () => []).add(story.id);
      }
    }
    final known = suiteCases.map((c) => c.id).toSet();

    expect(
      owners.keys.toSet().difference(known),
      isEmpty,
      reason: 'historias que citan casos que no existen',
    );
    expect(
      known.difference(owners.keys.toSet()),
      isEmpty,
      reason: 'casos sin historia de usuario',
    );
    expect(
      owners.entries.where((e) => e.value.length > 1),
      isEmpty,
      reason: 'casos repetidos en varias historias',
    );
  });

  test('every user story is complete and its id is unique', () {
    final ids = userStories.map((s) => s.id).toList();
    expect(ids.toSet(), hasLength(ids.length));
    for (final story in userStories) {
      expect(
        RegExp(r'^HU-\d{2}$').hasMatch(story.id),
        isTrue,
        reason: story.id,
      );
      for (final text in [story.title, story.asA, story.iWant, story.soThat]) {
        expect(text.trim(), isNotEmpty, reason: story.id);
      }
      expect(story.criteria.length, greaterThanOrEqualTo(3), reason: story.id);
      expect(story.criteria.every((c) => c.trim().isNotEmpty), isTrue);
      expect(story.caseIds, isNotEmpty, reason: '${story.id} sin casos');
    }
  });

  test('every manual case is complete, unique and under a real story', () {
    final problems = [for (final m in manualCases) ...m.validate()];
    expect(problems, isEmpty);

    final ids = manualCases.map((m) => m.id).toList();
    expect(ids.toSet(), hasLength(ids.length));

    final stories = userStories.map((s) => s.id).toSet();
    for (final manual in manualCases) {
      expect(stories, contains(manual.storyId), reason: manual.id);
    }
  });

  test('an executed manual case must say what happened', () {
    const executed = ManualCase(
      id: 'MC-99',
      storyId: 'HU-01',
      title: 'x',
      priority: Priority.baja,
      preconditions: 'x',
      input: 'x',
      steps: ['x'],
      expected: 'x',
      status: ManualStatus.ok,
    );
    expect(executed.validate(), hasLength(1));
    expect(executed.validate().single, contains('resultado obtenido'));
  });
}
