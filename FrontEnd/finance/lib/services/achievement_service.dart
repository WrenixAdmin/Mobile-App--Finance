import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/achievement_model.dart';
import '../config/api_config.dart';
import '../service/auth_service.dart';

class AchievementService {
  static Future<Map<String, dynamic>> getUserAchievements() async {
    try {
      final token = await AuthService.getToken();
      if (token == null) throw Exception('No authentication token found');

      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/api/achievements'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return {
          'achievements': (data['data']['achievements'] as List)
              .map((json) => Achievement.fromJson(json))
              .toList(),
          'allAchievements': (data['data']['allAchievements'] as List)
              .map((json) => Achievement.fromJson(json))
              .toList(),
          'totalPoints': data['data']['totalPoints'],
        };
      } else {
        throw Exception('Failed to load achievements');
      }
    } catch (e) {
      throw Exception('Error fetching achievements: $e');
    }
  }

  static Future<void> shareAchievement(String achievementId, String platform) async {
    try {
      final token = await AuthService.getToken();
      if (token == null) throw Exception('No authentication token found');

      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/api/achievements/share'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'achievementId': achievementId,
          'platform': platform,
        }),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to share achievement');
      }
    } catch (e) {
      throw Exception('Error sharing achievement: $e');
    }
  }

  static Future<List<Achievement>> checkNewAchievements() async {
    try {
      final token = await AuthService.getToken();
      if (token == null) throw Exception('No authentication token found');

      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/api/achievements/check'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return (data['data']['newAchievements'] as List)
            .map((json) => Achievement.fromJson(json))
            .toList();
      } else {
        throw Exception('Failed to check new achievements');
      }
    } catch (e) {
      throw Exception('Error checking new achievements: $e');
    }
  }
} 