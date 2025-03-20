class Currency {
  final String code;
  final String name;
  final String symbol;
  final double rate;  // Exchange rate relative to base currency

  Currency({
    required this.code,
    required this.name,
    required this.symbol,
    required this.rate,
  });

  factory Currency.fromJson(Map<String, dynamic> json) {
    return Currency(
      code: json['code'],
      name: json['name'],
      symbol: json['symbol'],
      rate: json['rate'].toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
    'code': code,
    'name': name,
    'symbol': symbol,
    'rate': rate,
  };
}

// Common currency symbols
const Map<String, String> currencySymbols = {
  'USD': '\$',
  'EUR': '€',
  'GBP': '£',
  'JPY': '¥',
  'AUD': 'A\$',
  'CAD': 'C\$',
  'CHF': 'Fr',
  'CNY': '¥',
  'INR': '₹',
  // Add more as needed
}; 