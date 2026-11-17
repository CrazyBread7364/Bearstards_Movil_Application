import 'package:bearstards_movil_application/app/app_config.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('the default API address is the secure production one', () {
    expect(AppConfig.apiBaseUrl, 'https://littlebearstards.com/api');
  });

  test('the base address has no trailing slash, so paths join cleanly', () {
    expect(AppConfig.apiBaseUrl.endsWith('/'), isFalse);
    expect(Uri.parse('${AppConfig.apiBaseUrl}/ranking/').path, '/api/ranking/');
  });
}
