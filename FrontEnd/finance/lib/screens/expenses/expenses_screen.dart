import 'package:flutter/material.dart';
import '../../models/expense_model.dart';
import '../../services/expense_service.dart';
import '../../utils/style.dart';

class ExpensesScreen extends StatefulWidget {
  const ExpensesScreen({Key? key}) : super(key: key);

  @override
  State<ExpensesScreen> createState() => _ExpensesScreenState();
}

class _ExpensesScreenState extends State<ExpensesScreen> {
  bool _isLoading = true;
  String _error = '';
  List<Expense> _expenses = [];
  List<String> _categories = [];
  String? _selectedCategory;
  DateTime? _startDate;
  DateTime? _endDate;
  final ScrollController _scrollController = ScrollController();
  bool _hasMore = true;
  int _page = 1;
  static const int _pageSize = 20;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadInitialData() async {
    try {
      setState(() {
        _isLoading = true;
        _error = '';
      });

      await Future.wait([
        _loadCategories(),
        _loadExpenses(),
      ]);

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _loadCategories() async {
    try {
      final categories = await ExpenseService.getCategories();
      setState(() {
        _categories = categories;
      });
    } catch (e) {
      // Handle error silently as this is not critical
    }
  }

  Future<void> _loadExpenses() async {
    if (!_hasMore || _isLoading) return;

    try {
      setState(() {
        _isLoading = true;
      });

      final expenses = await ExpenseService.getExpenses(
        category: _selectedCategory,
        startDate: _startDate,
        endDate: _endDate,
        page: _page,
        limit: _pageSize,
      );

      setState(() {
        if (_page == 1) {
          _expenses = expenses;
        } else {
          _expenses.addAll(expenses);
        }
        _hasMore = expenses.length == _pageSize;
        _page++;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _loadExpenses();
    }
  }

  Future<void> _showAddExpenseDialog() async {
    final formKey = GlobalKey<FormState>();
    final amountController = TextEditingController();
    final descriptionController = TextEditingController();
    String? selectedCategory;
    DateTime selectedDate = DateTime.now();

    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Expense'),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: amountController,
                decoration: const InputDecoration(
                  labelText: 'Amount',
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
                controller: descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: selectedCategory,
                decoration: const InputDecoration(
                  labelText: 'Category',
                ),
                items: _categories.map((category) {
                  return DropdownMenuItem(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (value) {
                  selectedCategory = value;
                },
                validator: (value) {
                  if (value == null) {
                    return 'Please select a category';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              ListTile(
                title: const Text('Date'),
                subtitle: Text(
                  '${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}',
                ),
                trailing: const Icon(Icons.calendar_today),
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: selectedDate,
                    firstDate: DateTime(2000),
                    lastDate: DateTime.now(),
                  );
                  if (date != null) {
                    selectedDate = date;
                  }
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
                try {
                  await ExpenseService.createExpense(
                    amount: double.parse(amountController.text),
                    category: selectedCategory!,
                    description: descriptionController.text,
                    date: selectedDate,
                  );

                  Navigator.pop(context);
                  _page = 1;
                  _hasMore = true;
                  _loadExpenses();
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to create expense: $e')),
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

  Future<void> _showEditExpenseDialog(Expense expense) async {
    final formKey = GlobalKey<FormState>();
    final amountController = TextEditingController(text: expense.amount.toString());
    final descriptionController = TextEditingController(text: expense.description);
    String selectedCategory = expense.category;
    DateTime selectedDate = expense.date;

    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Expense'),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: amountController,
                decoration: const InputDecoration(
                  labelText: 'Amount',
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
                controller: descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: selectedCategory,
                decoration: const InputDecoration(
                  labelText: 'Category',
                ),
                items: _categories.map((category) {
                  return DropdownMenuItem(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (value) {
                  selectedCategory = value!;
                },
                validator: (value) {
                  if (value == null) {
                    return 'Please select a category';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              ListTile(
                title: const Text('Date'),
                subtitle: Text(
                  '${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}',
                ),
                trailing: const Icon(Icons.calendar_today),
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: selectedDate,
                    firstDate: DateTime(2000),
                    lastDate: DateTime.now(),
                  );
                  if (date != null) {
                    selectedDate = date;
                  }
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
                try {
                  await ExpenseService.updateExpense(
                    id: expense.id,
                    amount: double.parse(amountController.text),
                    category: selectedCategory,
                    description: descriptionController.text,
                    date: selectedDate,
                  );

                  Navigator.pop(context);
                  _page = 1;
                  _hasMore = true;
                  _loadExpenses();
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to update expense: $e')),
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

  Future<void> _showDeleteConfirmationDialog(Expense expense) async {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Expense'),
        content: const Text('Are you sure you want to delete this expense?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              try {
                await ExpenseService.deleteExpense(expense.id);
                Navigator.pop(context);
                _page = 1;
                _hasMore = true;
                _loadExpenses();
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Failed to delete expense: $e')),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Expenses'),
        backgroundColor: AppColors.lightPurpleColor,
        elevation: 0,
      ),
      body: _isLoading && _expenses.isEmpty
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
                        onPressed: _loadInitialData,
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                )
              : Column(
                  children: [
                    Container(
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
                        children: [
                          DropdownButtonFormField<String>(
                            value: _selectedCategory,
                            decoration: const InputDecoration(
                              labelText: 'Category',
                              border: OutlineInputBorder(),
                            ),
                            items: [
                              const DropdownMenuItem(
                                value: null,
                                child: Text('All Categories'),
                              ),
                              ..._categories.map((category) {
                                return DropdownMenuItem(
                                  value: category,
                                  child: Text(category),
                                );
                              }).toList(),
                            ],
                            onChanged: (value) {
                              setState(() {
                                _selectedCategory = value;
                                _page = 1;
                                _hasMore = true;
                              });
                              _loadExpenses();
                            },
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: TextButton.icon(
                                  onPressed: () async {
                                    final date = await showDatePicker(
                                      context: context,
                                      initialDate: _startDate ?? DateTime.now(),
                                      firstDate: DateTime(2000),
                                      lastDate: DateTime.now(),
                                    );
                                    if (date != null) {
                                      setState(() {
                                        _startDate = date;
                                        _page = 1;
                                        _hasMore = true;
                                      });
                                      _loadExpenses();
                                    }
                                  },
                                  icon: const Icon(Icons.calendar_today),
                                  label: Text(
                                    _startDate != null
                                        ? '${_startDate!.year}-${_startDate!.month.toString().padLeft(2, '0')}-${_startDate!.day.toString().padLeft(2, '0')}'
                                        : 'Start Date',
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: TextButton.icon(
                                  onPressed: () async {
                                    final date = await showDatePicker(
                                      context: context,
                                      initialDate: _endDate ?? DateTime.now(),
                                      firstDate: DateTime(2000),
                                      lastDate: DateTime.now(),
                                    );
                                    if (date != null) {
                                      setState(() {
                                        _endDate = date;
                                        _page = 1;
                                        _hasMore = true;
                                      });
                                      _loadExpenses();
                                    }
                                  },
                                  icon: const Icon(Icons.calendar_today),
                                  label: Text(
                                    _endDate != null
                                        ? '${_endDate!.year}-${_endDate!.month.toString().padLeft(2, '0')}-${_endDate!.day.toString().padLeft(2, '0')}'
                                        : 'End Date',
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: RefreshIndicator(
                        onRefresh: () async {
                          _page = 1;
                          _hasMore = true;
                          await _loadExpenses();
                        },
                        child: ListView.builder(
                          controller: _scrollController,
                          padding: const EdgeInsets.all(16),
                          itemCount: _expenses.length + (_hasMore ? 1 : 0),
                          itemBuilder: (context, index) {
                            if (index == _expenses.length) {
                              return const Center(
                                child: Padding(
                                  padding: EdgeInsets.all(16.0),
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            }

                            final expense = _expenses[index];
                            return Card(
                              margin: const EdgeInsets.only(bottom: 16),
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: AppColors.primaryColor.withOpacity(0.1),
                                  child: Icon(
                                    _getCategoryIcon(expense.category),
                                    color: AppColors.primaryColor,
                                  ),
                                ),
                                title: Text(expense.description),
                                subtitle: Text(
                                  '${expense.category} • ${expense.date.year}-${expense.date.month.toString().padLeft(2, '0')}-${expense.date.day.toString().padLeft(2, '0')}',
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      '\$${expense.amount.toStringAsFixed(2)}',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.more_vert),
                                      onPressed: () {
                                        showModalBottomSheet(
                                          context: context,
                                          builder: (context) => Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              ListTile(
                                                leading: const Icon(Icons.edit),
                                                title: const Text('Edit'),
                                                onTap: () {
                                                  Navigator.pop(context);
                                                  _showEditExpenseDialog(expense);
                                                },
                                              ),
                                              ListTile(
                                                leading: const Icon(Icons.delete),
                                                title: const Text('Delete'),
                                                onTap: () {
                                                  Navigator.pop(context);
                                                  _showDeleteConfirmationDialog(expense);
                                                },
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddExpenseDialog,
        backgroundColor: AppColors.primaryColor,
        child: const Icon(Icons.add),
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'food':
        return Icons.restaurant;
      case 'transport':
        return Icons.directions_car;
      case 'utilities':
        return Icons.home;
      case 'entertainment':
        return Icons.movie;
      case 'shopping':
        return Icons.shopping_cart;
      case 'health':
        return Icons.local_hospital;
      case 'education':
        return Icons.school;
      default:
        return Icons.category;
    }
  }
} 