import 'package:flutter/material.dart';
import '../models/currency_model.dart';

class CurrencySelector extends StatefulWidget {
  final List<Currency> currencies;
  final String selectedCurrency;
  final ValueChanged<Currency> onSelect;

  const CurrencySelector({
    Key? key,
    required this.currencies,
    required this.selectedCurrency,
    required this.onSelect,
  }) : super(key: key);

  @override
  State<CurrencySelector> createState() => _CurrencySelectorState();
}

class _CurrencySelectorState extends State<CurrencySelector> {
  late TextEditingController _searchController;
  List<Currency> _filteredCurrencies = [];

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _filteredCurrencies = widget.currencies;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterCurrencies(String query) {
    setState(() {
      _filteredCurrencies = widget.currencies.where((currency) {
        final lowercaseQuery = query.toLowerCase();
        return currency.code.toLowerCase().contains(lowercaseQuery) ||
            currency.name.toLowerCase().contains(lowercaseQuery);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Select Currency',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: 'Search currency...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: _filterCurrencies,
            ),
            const SizedBox(height: 16),
            Container(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.5,
              ),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: _filteredCurrencies.length,
                itemBuilder: (context, index) {
                  final currency = _filteredCurrencies[index];
                  return ListTile(
                    leading: Text(
                      currency.symbol,
                      style: const TextStyle(fontSize: 18),
                    ),
                    title: Text(currency.code),
                    subtitle: Text(currency.name),
                    trailing: currency.code == widget.selectedCurrency
                        ? const Icon(Icons.check, color: Colors.green)
                        : null,
                    onTap: () {
                      widget.onSelect(currency);
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
} 