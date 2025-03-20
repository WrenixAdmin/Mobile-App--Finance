import 'package:flutter/material.dart';
import '../../components/navigator.dart';
import '../../components/profile_avatar.dart';
import '../../service/greeting.dart';
import '../../utils/colors.dart';
import '../../utils/style.dart';
import '../profile/profile_screen.dart';
import '../../services/budget_service.dart';

class BudgetScreen extends StatefulWidget {
  const BudgetScreen({Key? key}) : super(key: key);

  @override
  State<BudgetScreen> createState() => _BudgetScreenState();
}

class _BudgetScreenState extends State<BudgetScreen> {
  String _selectedPeriod = 'monthly';
  int _selectedYear = DateTime.now().year;
  int _selectedMonth = DateTime.now().month;
  bool _isLoading = true;
  String _error = '';
  Map<String, dynamic>? _budgetData;
  List<Map<String, dynamic>> _budgetHistory = [];

  @override
  void initState() {
    super.initState();
    _loadBudgetData();
    _loadBudgetHistory();
  }

  Future<void> _loadBudgetData() async {
    try {
      setState(() {
        _isLoading = true;
        _error = '';
      });

      final response = await BudgetService.getBudget(
        period: _selectedPeriod,
        year: _selectedYear,
        month: _selectedPeriod == 'monthly' ? _selectedMonth : null,
      );

      setState(() {
        _budgetData = response;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _loadBudgetHistory() async {
    try {
      final history = await BudgetService.getBudgetHistory(
        period: _selectedPeriod,
      );
      setState(() {
        _budgetHistory = history;
      });
    } catch (e) {
      // Handle error silently as this is not critical
    }
  }

  Future<void> _showBudgetDialog() async {
    final formKey = GlobalKey<FormState>();
    final categoriesController = TextEditingController();
    final amountController = TextEditingController();

    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Set Budget'),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: amountController,
                decoration: const InputDecoration(
                  labelText: 'Total Amount',
                  prefixText: '\$',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an amount';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: categoriesController,
                decoration: const InputDecoration(
                  labelText: 'Categories (comma-separated)',
                  hintText: 'e.g., Food, Transport, Entertainment',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter categories';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (formKey.currentState!.validate()) {
                final categories = categoriesController.text
                    .split(',')
                    .map((e) => e.trim())
                    .toList();
                final amount = double.parse(amountController.text);

                try {
                  await BudgetService.setBudget(
                    period: _selectedPeriod,
                    year: _selectedYear,
                    month: _selectedPeriod == 'monthly' ? _selectedMonth : 1,
                    categories: categories.map((category) {
                      return {
                        'category': category,
                        'amount': amount / categories.length,
                      };
                    }).toList(),
                    totalAmount: amount,
                  );

                  Navigator.pop(context);
                  _loadBudgetData();
                  _loadBudgetHistory();
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to set budget: $e')),
                  );
                }
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Budget'),
        backgroundColor: AppColors.lightPurpleColor,
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error.isNotEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _error,
                        style: const TextStyle(color: Colors.red),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _loadBudgetData,
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                )
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildPeriodSelector(),
                      const SizedBox(height: 24),
                      _buildTotalBudget(),
                      const SizedBox(height: 24),
                      _buildCategoryBudgets(),
                      const SizedBox(height: 24),
                      _buildBudgetHistory(),
                    ],
                  ),
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showBudgetDialog,
        backgroundColor: AppColors.primaryColor,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildPeriodSelector() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: DropdownButtonFormField<String>(
              value: _selectedPeriod,
              decoration: const InputDecoration(
                labelText: 'Period',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: 'monthly', child: Text('Monthly')),
                DropdownMenuItem(value: 'yearly', child: Text('Yearly')),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedPeriod = value;
                  });
                  _loadBudgetData();
                  _loadBudgetHistory();
                }
              },
            ),
          ),
          const SizedBox(width: 16),
          if (_selectedPeriod == 'monthly')
            Expanded(
              child: DropdownButtonFormField<int>(
                value: _selectedMonth,
                decoration: const InputDecoration(
                  labelText: 'Month',
                  border: OutlineInputBorder(),
                ),
                items: List.generate(12, (index) {
                  return DropdownMenuItem(
                    value: index + 1,
                    child: Text(DateTime(2000, index + 1).toString().split(' ')[0].split('-')[1]),
                  );
                }),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _selectedMonth = value;
                    });
                    _loadBudgetData();
                    _loadBudgetHistory();
                  }
                },
              ),
            ),
          const SizedBox(width: 16),
          Expanded(
            child: DropdownButtonFormField<int>(
              value: _selectedYear,
              decoration: const InputDecoration(
                labelText: 'Year',
                border: OutlineInputBorder(),
              ),
              items: List.generate(5, (index) {
                final year = DateTime.now().year - 2 + index;
                return DropdownMenuItem(
                  value: year,
                  child: Text(year.toString()),
                );
              }),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedYear = value;
                  });
                  _loadBudgetData();
                  _loadBudgetHistory();
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTotalBudget() {
    final total = _budgetData?['budget']['totalAmount'] ?? 0.0;
    final spent = _budgetData?['progress']['total']['spent'] ?? 0.0;
    final percentage = total > 0 ? (spent / total) : 0.0;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primaryColor, AppColors.lightPurpleColor],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryColor.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Total Budget',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '\$${total.toStringAsFixed(2)}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          LinearProgressIndicator(
            value: percentage,
            backgroundColor: Colors.white.withOpacity(0.3),
            valueColor: AlwaysStoppedAnimation<Color>(
              percentage > 1 ? Colors.red : Colors.white,
            ),
            minHeight: 8,
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryBudgets() {
    final categories = _budgetData?['progress']['byCategory'] ?? [];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Category Budgets',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          if (categories.isEmpty)
            const Text('No categories found')
          else
            ...categories.map((category) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        category['category'],
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                      Text(
                        '\$${category['spent'].toStringAsFixed(2)} / \$${category['budgeted'].toStringAsFixed(2)}',
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  LinearProgressIndicator(
                    value: category['percentage'] / 100,
                    backgroundColor: Colors.grey[200],
                    valueColor: AlwaysStoppedAnimation<Color>(
                      category['percentage'] > 100
                          ? Colors.red
                          : category['percentage'] > 90
                              ? Colors.orange
                              : AppColors.primaryColor,
                    ),
                    minHeight: 4,
                  ),
                  const SizedBox(height: 16),
                ],
              );
            }).toList(),
        ],
      ),
    );
  }

  Widget _buildBudgetHistory() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Budget History',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          if (_budgetHistory.isEmpty)
            const Text('No history available')
          else
            ..._budgetHistory.map((budget) {
              return ListTile(
                title: Text(
                  '${budget['year']} - ${budget['month']}',
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                subtitle: Text(
                  '\$${budget['totalAmount'].toStringAsFixed(2)}',
                ),
                trailing: Text(
                  '${budget['categories'].length} categories',
                  style: TextStyle(color: Colors.grey[600]),
                ),
              );
            }).toList(),
        ],
      ),
    );
  }
}
