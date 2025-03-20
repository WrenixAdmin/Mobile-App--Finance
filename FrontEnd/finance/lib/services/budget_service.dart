import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import '../service/auth_service.dart';

class BudgetService {
  static Future<Map<String, dynamic>> getBudget({
    required String period,
    required int year,
    int? month,
  }) async {
    try {
      final token = await AuthService.getToken();
      if (token == null) throw Exception('No authentication token found');

      final queryParams = {
        'period': period,
        'year': year.toString(),
        if (month != null) 'month': month.toString(),
      };

      final uri = Uri.parse('${ApiConfig.baseUrl}/api/budgets').replace(
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
        throw Exception('Failed to load budget: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error fetching budget: $e');
    }
  }

  static Future<List<Map<String, dynamic>>> getBudgetHistory({
    required String period,
    int limit = 10,
  }) async {
    try {
      final token = await AuthService.getToken();
      if (token == null) throw Exception('No authentication token found');

      final queryParams = {
        'period': period,
        'limit': limit.toString(),
      };

      final uri = Uri.parse('${ApiConfig.baseUrl}/api/budgets/history').replace(
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
        return List<Map<String, dynamic>>.from(data['data']);
      } else {
        throw Exception('Failed to load budget history: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error fetching budget history: $e');
    }
  }

  static Future<Map<String, dynamic>> setBudget({
    required String period,
    required int year,
    required int month,
    required List<Map<String, dynamic>> categories,
    required double totalAmount,
  }) async {
    try {
      final token = await AuthService.getToken();
      if (token == null) throw Exception('No authentication token found');

      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/api/budgets'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'period': period,
          'year': year,
          'month': month,
          'categories': categories,
          'totalAmount': totalAmount,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = json.decode(response.body);
        return data['data'];
      } else {
        throw Exception('Failed to set budget: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error setting budget: $e');
    }
  }
} 