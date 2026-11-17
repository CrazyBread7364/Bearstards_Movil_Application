import 'package:bearstards_movil_application/app/navigation/wiki_routes.dart';
import 'package:bearstards_movil_application/features/wiki/presentation/widgets/guide_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  double opacityOf(WidgetTester tester, String text) => tester
      .widget<FadeTransition>(
        find
            .ancestor(
              of: find.text(text),
              matching: find.byType(FadeTransition),
            )
            .first,
      )
      .opacity
      .value;

  Widget screen() => MaterialApp(
    home: GuideScaffold(
      title: 'Prueba',
      section: WikiSection.home,
      showNavigation: false,
      children: [
        for (var i = 0; i < 30; i++)
          SizedBox(height: 200, child: Text('item $i')),
      ],
    ),
  );

  testWidgets('items reveal on their first build', (tester) async {
    await tester.pumpWidget(screen());
    expect(opacityOf(tester, 'item 0'), 0);

    await tester.pumpAndSettle();
    expect(opacityOf(tester, 'item 0'), 1);
  });

  testWidgets('an item that already revealed does not animate again', (
    tester,
  ) async {
    await tester.pumpWidget(screen());
    await tester.pumpAndSettle();

    await tester.drag(find.byType(Scrollable).first, const Offset(0, -4000));
    await tester.pumpAndSettle();
    expect(find.text('item 0'), findsNothing, reason: 'sale de la lista');

    await tester.drag(find.byType(Scrollable).first, const Offset(0, 4000));
    await tester.pump();
    expect(find.text('item 0'), findsOneWidget);
    expect(opacityOf(tester, 'item 0'), 1, reason: 'no vuelve a animarse');
  });
}
