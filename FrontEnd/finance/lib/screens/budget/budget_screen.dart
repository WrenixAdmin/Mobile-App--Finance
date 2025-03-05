import 'package:flutter/material.dart';
import '../../utils/colors.dart';
import '../../utils/icons.dart';

class BudgetScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.purple.shade100,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Budgets',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'September 2024',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '\$1,812',
                    style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16),
                  _budgetSummaryCard(),
                ],
              ),
            ),
            SizedBox(height: 16),
            _categoryCard(
              title: 'Food & Transport',
              total: 700,
              items: [
                {'name': 'Foods', 'amount': 350, 'left': 186},
                {'name': 'Rides', 'amount': 250, 'left': 120},
              ],
              icon: Icons.directions_car,
            ),
            _categoryCard(
              title: 'Bill & Utilities',
              total: 320,
              items: [
                {'name': 'Subscriptions', 'amount': 52, 'left': 0},
                {'name': 'House service', 'amount': 138, 'left': 10},
                {'name': 'Maintenance', 'amount': 130, 'left': 30},
              ],
              icon: Icons.receipt,
            ),
          ],
        ),
      ),
    );
  }

  Widget _budgetSummaryCard() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 4, spreadRadius: 1),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Left to spend', style: TextStyle(color: Colors.grey)),
              Text('Monthly budget', style: TextStyle(color: Colors.grey)),
            ],
          ),
          SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('\$738', style: TextStyle(fontWeight: FontWeight.bold)),
              Text('\$2,550', style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _categoryCard({required String title, required int total, required List<Map<String, dynamic>> items, required IconData icon}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4, spreadRadius: 1)],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Colors.purple),
                SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Spacer(),
                Text('\$$total', style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            SizedBox(height: 8),
            ...items.map((item) => _budgetItem(item)).toList(),
          ],
        ),
      ),
    );
  }

  Widget _budgetItem(Map<String, dynamic> item) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(item['name']),
              Text('\$${item['amount']}'),
            ],
          ),
          SizedBox(height: 4),
          LinearProgressIndicator(
            value: (item['amount'] - item['left']) / item['amount'],
            backgroundColor: Colors.grey.shade300,
            color: item['left'] == 0 ? Colors.red : Colors.purple,
          ),
          SizedBox(height: 4),
          Text('Left \$${item['left']}', style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}
