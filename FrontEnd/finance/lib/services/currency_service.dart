import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/currency_model.dart';
import '../config/api_config.dart';

class CurrencyService {
  static Future<Map<String, double>> getExchangeRates(String baseCurrency) async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/$baseCurrency'),
        headers: {
          'Authorization': 'Bearer ${ApiConfig.exchangeRateApiKey}',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return Map<String, double>.from(data['rates']);
      } else {
        throw Exception('Failed to load exchange rates');
      }
    } catch (e) {
      throw Exception('Error fetching exchange rates: $e');
    }
  }

  static Future<List<Currency>> getAvailableCurrencies() async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/USD'),
        headers: {
          'Authorization': 'Bearer ${ApiConfig.exchangeRateApiKey}',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final rates = data['rates'] as Map<String, dynamic>;
        return rates.keys.map((code) => Currency(
          code: code,
          name: _getCurrencyName(code),
          symbol: _getCurrencySymbol(code),
        )).toList();
      } else {
        throw Exception('Failed to load currencies');
      }
    } catch (e) {
      throw Exception('Error fetching currencies: $e');
    }
  }

  // ... rest of the existing code ...
} 