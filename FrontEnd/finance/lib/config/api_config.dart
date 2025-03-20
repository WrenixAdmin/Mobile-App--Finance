class ApiConfig {
  // static const String baseUrl = 'https://node-backend-production-6638.up.railway.app';
  static const String baseUrl = 'http://localhost:5000';

  // Auth endpoints
  static const String loginUrl = '$baseUrl/auth/login';
  static const String registerUrl = '$baseUrl/auth/register';
  static const String profileUrl = '$baseUrl/api/profile';

  // Add other endpoints here as needed
  // static const String someOtherEndpoint = '$baseUrl/some/endpoint';

  static const String exchangeRateApiKey = 'a56b767ab3c4c2f0c967e9b5';
} 