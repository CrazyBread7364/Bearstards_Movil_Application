import 'package:bearstards_movil_application/core/assets/wiki_assets.dart';
import 'package:bearstards_movil_application/core/widgets/wiki_artwork.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget host(double width) => Directionality(
    textDirection: TextDirection.ltr,
    child: Align(
      alignment: Alignment.topLeft,
      child: SizedBox(
        width: width,
        height: 100,
        child: const WikiArtwork(WikiAssets.needle),
      ),
    ),
  );

  testWidgets('a zero-width frame decodes no image', (tester) async {
    await tester.pumpWidget(host(0));
    expect(find.byType(Image), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('a real width decodes the image as before', (tester) async {
    await tester.pumpWidget(host(200));
    expect(find.byType(Image), findsOneWidget);
  });
}
