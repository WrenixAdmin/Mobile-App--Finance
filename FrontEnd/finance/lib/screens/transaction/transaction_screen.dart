import 'package:flutter/material.dart';
import '../../utils/colors.dart';
import '../../utils/style.dart';
import '../budget/budget_screen.dart';
import '../expenses/expenses_screen.dart';
import '../subscription/subscription_screen.dart';

class TransactionScreen extends StatelessWidget {
  const TransactionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transactions'),
        elevation: 0,
        backgroundColor: AppColors.lightPurpleColor,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.lightPurpleColor,
              Colors.white,
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              _buildTransactionButton(
                context,
                'Budget',
                'Manage your monthly budgets and track spending limits',
                Icons.account_balance_wallet,
                AppColors.primaryColor,
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const BudgetScreen()),
                  );
                },
              ),
              const SizedBox(height: 20),
              _buildTransactionButton(
                context,
                'Expenses',
                'Track and categorize your daily expenses',
                Icons.receipt_long,
                Colors.orange,
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ExpensesScreen()),
                  );
                },
              ),
              const SizedBox(height: 20),
              _buildTransactionButton(
                context,
                'Subscriptions',
                'Monitor and manage your recurring subscriptions',
                Icons.subscriptions,
                Colors.purple,
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SubscriptionScreen()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTransactionButton(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Icon(
                    icon,
                    color: color,
                    size: 30,
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.grey[400],
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
} 