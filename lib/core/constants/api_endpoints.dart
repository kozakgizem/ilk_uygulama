class ApiEndpoints {
  static const String baseUrl = 'http://127.0.0.1:8000';
  static const String login = '/auth/token';
  static const String register = '/users/';
  static const String userProfile = '/users/me';
  static const String services = '/services/';
  static const String health = '/health'; // Bu satırı eklediğinden emin ol
  static const String managementConfig = '/management/config/json';
  static const String systemStatus = '/api/system/status';
  static const String systemMetrics = '/api/system/metrics';
  static const String systemLogs = '/api/logs';
}