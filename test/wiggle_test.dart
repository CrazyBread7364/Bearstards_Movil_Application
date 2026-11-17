import 'package:bearstards_movil_application/core/widgets/wiggle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget host({bool disableAnimations = false}) => MediaQuery(
    data: MediaQueryData(disableAnimations: disableAnimations),
    child: const Directionality(
      textDirection: TextDirection.ltr,
      child: Wiggle(child: SizedBox(width: 40, height: 40)),
    ),
  );

  double angle(WidgetTester tester) => tester
      .widget<Transform>(
        find.descendant(
          of: find.byType(Wiggle),
          matching: find.byType(Transform),
        ),
      )
      .transform
      .getRotation()
      .entry(1, 0);

  test('the tilt fades out to a full stop', () {
    expect(Wiggle.angleAt(0), 0);
    expect(Wiggle.angleAt(1), 0);
    var peak = 0.0;
    for (var t = 0.0; t <= 1; t += .01) {
      peak = peak < Wiggle.angleAt(t).abs() ? Wiggle.angleAt(t).abs() : peak;
    }
    expect(peak, lessThanOrEqualTo(.05));
    expect(peak, greaterThan(.02));
    expect(Wiggle.angleAt(.95).abs(), lessThan(Wiggle.angleAt(.1).abs()));
  });

  testWidgets('it rocks while animating and rests in the end', (tester) async {
    await tester.pumpWidget(host());
    var moved = false;
    for (var i = 0; i < 24; i++) {
      await tester.pump(const Duration(milliseconds: 100));
      if (angle(tester).abs() > .01) moved = true;
    }
    expect(moved, isTrue);

    await tester.pumpAndSettle();
    expect(angle(tester), 0);
  });

  testWidgets('it never moves when the system reduces motion', (tester) async {
    await tester.pumpWidget(host(disableAnimations: true));
    for (var i = 0; i < 10; i++) {
      await tester.pump(const Duration(milliseconds: 100));
      expect(angle(tester), 0);
    }
  });
}
