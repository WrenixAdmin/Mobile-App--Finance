import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/currency_model.dart';

class CurrencyService {
  // Using ExchangeRate-API (https://www.exchangerate-api.com/)
  // Free tier includes 1500 requests per month
  static const String _apiKey = 'YOUR_API_KEY';  // Replace with your API key
  static const String _baseUrl = 'https://v6.exchangerate-api.com/v6';

  // Get all available currencies
  static Future<List<Currency>> getAllCurrencies() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/$_apiKey/codes'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['result'] == 'success') {
          final List<dynamic> codes = data['supported_codes'];
          return codes.map((code) {
            return Currency(
              code: code[0],
              name: code[1],
              symbol: currencySymbols[code[0]] ?? code[0],
              rate: 1.0,  // Will be updated with getExchangeRates
            );
          }).toList();
        }
      }
      throw Exception('Failed to load currencies');
    } catch (e) {
      throw Exception('Error loading currencies: $e');
    }
  }

  // Get latest exchange rates for a base currency
  static Future<Map<String, double>> getExchangeRates(String baseCurrency) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/$_apiKey/latest/$baseCurrency'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['result'] == 'success') {
          final Map<String, dynamic> rates = data['conversion_rates'];
          return rates.map((key, value) => MapEntry(key, value.toDouble()));
        }
      }
      throw Exception('Failed to load exchange rates');
    } catch (e) {
      throw Exception('Error loading exchange rates: $e');
    }
  }

  // Convert amount from one currency to another
  static Future<double> convertCurrency(
    String from,
    String to,
    double amount,
  ) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/$_apiKey/pair/$from/$to/$amount'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['result'] == 'success') {
          return data['conversion_result'].toDouble();
        }
      }
      throw Exception('Failed to convert currency');
    } catch (e) {
      throw Exception('Error converting currency: $e');
    }
  }

  // Format amount with currency symbol
  static String formatAmount(String currencyCode, double amount) {
    final symbol = currencySymbols[currencyCode] ?? currencyCode;
    return '$symbol${amount.toStringAsFixed(2)}';
  }
} 