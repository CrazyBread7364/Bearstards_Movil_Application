/// Build-time settings. Override with `--dart-define`, for example
/// `flutter run --dart-define=API_BASE_URL=http://10.0.2.2:8000/api` to reach a
/// local backend from the Android emulator.
abstract final class AppConfig {
  static const apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://littlebearstards.com/api',
  );
}
