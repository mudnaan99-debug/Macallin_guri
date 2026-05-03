/// Backend Django API base URL (no trailing slash).
///
/// Android emulator → host machine: use default `10.0.2.2`.
/// iOS Simulator: `--dart-define=API_BASE_URL=http://127.0.0.1:8000`
/// Taleefan dhab ah: IP-ga kombiyuutarka (tusaale `http://192.168.1.5:8000`)
class ApiConfig {
  ApiConfig._();

  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://10.0.2.2:8000',
  );
}
