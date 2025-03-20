import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import '../service/auth_service.dart';

class SubscriptionService {
  static Future<Map<String, dynamic>> getSubscriptions({
    String? status,
    String? category,
  }) async {
    try {
      final token = await AuthService.getToken();
      if (token == null) throw Exception('No authentication token found');

      final queryParams = {
        if (status != null) 'status': status,
        if (category != null) 'category': category,
      };

      final uri = Uri.parse('${ApiConfig.baseUrl}/api/subscriptions/list').replace(
        queryParameters: queryParams,
      );

      final response = await http.get(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['data'];
      } else {
        throw Exception('Failed to load subscriptions: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error fetching subscriptions: $e');
    }
  }

  static Future<Map<String, dynamic>> createSubscription({
    required String name,
    required double amount,
    required String frequency,
    required DateTime startDate,
    required String category,
    String status = 'active',
  }) async {
    try {
      final token = await AuthService.getToken();
      if (token == null) throw Exception('No authentication token found');

      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/api/subscriptions/create'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'name': name,
          'amount': amount,
          'frequency': frequency,
          'startDate': startDate.toIso8601String(),
          'category': category,
          'status': status,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = json.decode(response.body);
        return data['data'];
      } else {
        throw Exception('Failed to create subscription: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error creating subscription: $e');
    }
  }

  static Future<Map<String, dynamic>> updateSubscription({
    required String id,
    required String name,
    required double amount,
    required String frequency,
    required DateTime startDate,
    required String category,
    required String status,
  }) async {
    try {
      final token = await AuthService.getToken();
      if (token == null) throw Exception('No authentication token found');

      final response = await http.put(
        Uri.parse('${ApiConfig.baseUrl}/api/subscriptions/$id'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'name': name,
          'amount': amount,
          'frequency': frequency,
          'startDate': startDate.toIso8601String(),
          'category': category,
          'status': status,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['data'];
      } else {
        throw Exception('Failed to update subscription: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error updating subscription: $e');
    }
  }

  static Future<void> cancelSubscription(String id) async {
    try {
      final token = await AuthService.getToken();
      if (token == null) throw Exception('No authentication token found');

      final response = await http.delete(
        Uri.parse('${ApiConfig.baseUrl}/api/subscriptions/cancel/$id'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to cancel subscription: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error canceling subscription: $e');
    }
  }
} 