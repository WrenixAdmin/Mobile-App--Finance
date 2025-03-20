import 'package:flutter/material.dart';
import '../../config/style.dart';
import '../../models/transaction_model.dart';
import '../../services/transaction_service.dart';
import '../budget/budget_screen.dart';
import '../expenses/expenses_screen.dart';
import '../subscription/subscription_screen.dart';

class TransactionScreen extends StatefulWidget {
  const TransactionScreen({super.key});

  @override
  State<TransactionScreen> createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  bool _isLoading = true;
  String? _error;
  List<Transaction> _transactions = [];
  final ScrollController _scrollController = ScrollController();
  int _currentPage = 1;
  bool _hasMore = true;
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    _loadTransactions();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadTransactions({bool refresh = false}) async {
    if (refresh) {
      setState(() {
        _currentPage = 1;
        _hasMore = true;
        _transactions = [];
      });
    }

    if (!_hasMore || _isLoadingMore) return;

    setState(() {
      _isLoadingMore = true;
    });

    try {
      final transactions = await TransactionService.getTransactions(
        page: _currentPage,
        limit: 10,
      );

      setState(() {
        if (refresh) {
          _transactions = transactions;
        } else {
          _transactions.addAll(transactions);
        }
        _hasMore = transactions.length == 10;
        _currentPage++;
        _isLoading = false;
        _isLoadingMore = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
        _isLoadingMore = false;
      });
    }
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _loadTransactions();
    }
  }

  Widget _buildTransactionButton({
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: color, size: 32),
              const SizedBox(height: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transactions'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => _loadTransactions(refresh: true),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                _buildTransactionButton(
                  title: 'Budget',
                  icon: Icons.account_balance_wallet,
                  color: Colors.blue,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const BudgetScreen(),
                      ),
                    );
                  },
                ),
                const SizedBox(width: 16),
                _buildTransactionButton(
                  title: 'Expenses',
                  icon: Icons.money_off,
                  color: Colors.red,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ExpensesScreen(),
                      ),
                    );
                  },
                ),
                const SizedBox(width: 16),
                _buildTransactionButton(
                  title: 'Subscription',
                  icon: Icons.subscriptions,
                  color: Colors.green,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SubscriptionScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _error != null
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              _error!,
                              style: const TextStyle(color: Colors.red),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () => _loadTransactions(refresh: true),
                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      )
                    : RefreshIndicator(
                        onRefresh: () => _loadTransactions(refresh: true),
                        child: ListView.builder(
                          controller: _scrollController,
                          padding: const EdgeInsets.all(16),
                          itemCount: _transactions.length + (_hasMore ? 1 : 0),
                          itemBuilder: (context, index) {
                            if (index == _transactions.length) {
                              return const Center(
                                child: Padding(
                                  padding: EdgeInsets.all(16),
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            }

                            final transaction = _transactions[index];
                            return Card(
                              margin: const EdgeInsets.only(bottom: 16),
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: transaction.type == 'income'
                                      ? Colors.green.withOpacity(0.1)
                                      : Colors.red.withOpacity(0.1),
                                  child: Icon(
                                    transaction.type == 'income'
                                        ? Icons.arrow_downward
                                        : Icons.arrow_upward,
                                    color: transaction.type == 'income'
                                        ? Colors.green
                                        : Colors.red,
                                  ),
                                ),
                                title: Text(transaction.description),
                                subtitle: Text(
                                  '${transaction.category} • ${transaction.date.toString().split(' ')[0]}',
                                ),
                                trailing: Text(
                                  '${transaction.type == 'income' ? '+' : '-'}\$${transaction.amount.toStringAsFixed(2)}',
                                  style: TextStyle(
                                    color: transaction.type == 'income'
                                        ? Colors.green
                                        : Colors.red,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
          ),
        ],
      ),
    );
  }
} 