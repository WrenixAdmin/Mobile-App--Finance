import 'package:flutter/material.dart';
import '../../utils/colors.dart';
import '../../utils/style.dart';

class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({Key? key}) : super(key: key);

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  bool _isLoading = true;
  String _error = '';
  List<Map<String, dynamic>> _subscriptions = [];
  String? _selectedStatus;
  String? _selectedCategory;
  double _totalMonthlyCost = 0;

  @override
  void initState() {
    super.initState();
    _loadSubscriptions();
  }

  Future<void> _loadSubscriptions() async {
    try {
      setState(() {
        _isLoading = true;
        _error = '';
      });

      // TODO: Implement API call to get subscriptions
      // final response = await SubscriptionService.getSubscriptions(
      //   status: _selectedStatus,
      //   category: _selectedCategory,
      // );
      // setState(() {
      //   _subscriptions = response['subscriptions'];
      //   _totalMonthlyCost = response['totalMonthlyCost'];
      //   _isLoading = false;
      // });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Subscriptions'),
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
                        onPressed: _loadSubscriptions,
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                )
              : Column(
                  children: [
                    _buildTotalCost(),
                    _buildFilters(),
                    Expanded(
                      child: RefreshIndicator(
                        onRefresh: _loadSubscriptions,
                        child: ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: _subscriptions.length,
                          itemBuilder: (context, index) {
                            return _buildSubscriptionCard(_subscriptions[index]);
                          },
                        ),
                      ),
                    ),
                  ],
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Show add subscription dialog
        },
        backgroundColor: AppColors.primaryColor,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildTotalCost() {
    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.all(16),
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
        children: [
          const Text(
            'Total Monthly Cost',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '\$${_totalMonthlyCost.toStringAsFixed(2)}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilters() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
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
              value: _selectedStatus,
              decoration: const InputDecoration(
                labelText: 'Status',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(
                  value: null,
                  child: Text('All Status'),
                ),
                DropdownMenuItem(
                  value: 'active',
                  child: Text('Active'),
                ),
                DropdownMenuItem(
                  value: 'cancelled',
                  child: Text('Cancelled'),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  _selectedStatus = value;
                });
                _loadSubscriptions();
              },
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: DropdownButtonFormField<String>(
              value: _selectedCategory,
              decoration: const InputDecoration(
                labelText: 'Category',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(
                  value: null,
                  child: Text('All Categories'),
                ),
                DropdownMenuItem(
                  value: 'entertainment',
                  child: Text('Entertainment'),
                ),
                DropdownMenuItem(
                  value: 'utilities',
                  child: Text('Utilities'),
                ),
                DropdownMenuItem(
                  value: 'software',
                  child: Text('Software'),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  _selectedCategory = value;
                });
                _loadSubscriptions();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubscriptionCard(Map<String, dynamic> subscription) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: CircleAvatar(
          backgroundColor: AppColors.primaryColor.withOpacity(0.1),
          child: Icon(
            _getCategoryIcon(subscription['category']),
            color: AppColors.primaryColor,
          ),
        ),
        title: Text(
          subscription['name'] ?? 'Unnamed Subscription',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Text(
              subscription['category'] ?? 'Uncategorized',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Next billing: ${_formatDate(subscription['nextBillingDate'])}',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '\$${subscription['amount']?.toStringAsFixed(2) ?? '0.00'}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            Text(
              subscription['frequency'] ?? 'Monthly',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
              ),
            ),
          ],
        ),
        onTap: () {
          // TODO: Show subscription details dialog
        },
      ),
    );
  }

  IconData _getCategoryIcon(String? category) {
    switch (category?.toLowerCase()) {
      case 'entertainment':
        return Icons.movie;
      case 'utilities':
        return Icons.home;
      case 'software':
        return Icons.computer;
      default:
        return Icons.subscriptions;
    }
  }

  String _formatDate(String? dateString) {
    if (dateString == null) return 'N/A';
    final date = DateTime.parse(dateString);
    return '${date.day}/${date.month}/${date.year}';
  }
} 