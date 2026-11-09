import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'cases.dart';
import 'support/app_harness.dart';
import 'support/screen_tour.dart';
import 'test_case.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(loadWikiFonts);

  suiteWidgetTest(tc07, (tester) async {
    await launchApp(tester, size: const Size(320, 568));
    await tourEveryScreen(tester);
  });
}
