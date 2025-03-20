import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String _tokenKey = 'jwt_token';
  static const String _emailKey = 'user_email';

  // Save auth data
  static Future<void> saveAuthData(String token, String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
    await prefs.setString(_emailKey, email);
  }

  // Get token
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  // Get email
  static Future<String?> getEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_emailKey);
  }

  // Check if user is logged in
  static Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null;
  }

  // Logout
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_emailKey);
  }

  // Get auth headers
  static Future<Map<String, String>> getAuthHeaders() async {
    final token = await getToken();
    return {
      'Authorization': 'Bearer ${token ?? ''}',
      'Content-Type': 'application/json',
    };
  }
} 