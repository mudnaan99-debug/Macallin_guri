/// REST base URL (no trailing slash). API paths also omit trailing slash (Apache 301 otherwise).
class ApiConfig {
  ApiConfig._();

  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue:
        'http://10.150.141.126/Macllin_guri/backend_ci4/public',
  );
}
