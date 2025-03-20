import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/notification_model.dart';
import '../config/api_config.dart';
import '../service/auth_service.dart';

class NotificationService {
  static Future<void> registerFcmToken(String token) async {
    try {
      final authToken = await AuthService.getToken();
      if (authToken == null) throw Exception('No authentication token found');

      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/api/notifications/token'),
        headers: {
          'Authorization': 'Bearer $authToken',
          'Content-Type': 'application/json',
        },
        body: json.encode({'token': token}),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to register FCM token');
      }
    } catch (e) {
      throw Exception('Error registering FCM token: $e');
    }
  }

  static Future<NotificationPreferences> getNotificationPreferences() async {
    try {
      final token = await AuthService.getToken();
      if (token == null) throw Exception('No authentication token found');

      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/api/notifications/preferences'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return NotificationPreferences.fromJson(data['data']);
      } else {
        throw Exception('Failed to load notification preferences');
      }
    } catch (e) {
      throw Exception('Error fetching notification preferences: $e');
    }
  }

  static Future<NotificationPreferences> updateNotificationPreferences(
    NotificationPreferences preferences,
  ) async {
    try {
      final token = await AuthService.getToken();
      if (token == null) throw Exception('No authentication token found');

      final response = await http.put(
        Uri.parse('${ApiConfig.baseUrl}/api/notifications/preferences'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode(preferences.toJson()),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return NotificationPreferences.fromJson(data['data']);
      } else {
        throw Exception('Failed to update notification preferences');
      }
    } catch (e) {
      throw Exception('Error updating notification preferences: $e');
    }
  }

  static Future<List<AppNotification>> getNotificationHistory({int limit = 50}) async {
    try {
      final token = await AuthService.getToken();
      if (token == null) throw Exception('No authentication token found');

      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/api/notifications/history?limit=$limit'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return (data['data'] as List)
            .map((json) => AppNotification.fromJson(json))
            .toList();
      } else {
        throw Exception('Failed to load notification history');
      }
    } catch (e) {
      throw Exception('Error fetching notification history: $e');
    }
  }

  static Future<void> markNotificationAsRead(String notificationId) async {
    try {
      final token = await AuthService.getToken();
      if (token == null) throw Exception('No authentication token found');

      final response = await http.put(
        Uri.parse('${ApiConfig.baseUrl}/api/notifications/$notificationId/read'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to mark notification as read');
      }
    } catch (e) {
      throw Exception('Error marking notification as read: $e');
    }
  }
} 