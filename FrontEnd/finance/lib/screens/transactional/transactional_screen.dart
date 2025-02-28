import 'package:finance/utils/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:finance/components/ProfileIcon.dart';

class Transaction {
  final String month;
  final String name;
  final String amount;
  final String date;

  const Transaction({
    required this.month,
    required this.name,
    required this.amount,
    required this.date,
  });
}

class TransactionHistory {
  final List<Transaction> transactions;

  const TransactionHistory({this.transactions = const [
    Transaction(month: "October, 2024", name: "Starbucks-Coffee", amount: "\$12.50", date: "Oct 19, 05:45 AM"),
    Transaction(month: "October, 2024", name: "Uber-Ride", amount: "\$54.00", date: "Oct 15, 09:10 PM"),
    Transaction(month: "October, 2024", name: "Uber-Ride", amount: "\$25.00", date: "Oct 17, 02:13 PM"),
    Transaction(month: "October, 2024", name: "Walmart-Household", amount: "\$10.50", date: "Oct 07, 08:10 PM"),
    Transaction(month: "October, 2024", name: "Pitzahut-chity fry Pizza", amount: "\$08.00", date: "Oct 02, 01:19 AM"),
    Transaction(month: "September, 2024", name: "Uber-Ride", amount: "\$13.00", date: "Sep 28, 09:10 PM"),
    Transaction(month: "September, 2024", name: "Walmart-Table", amount: "\$20.00", date: "Sep 23, 09:10 PM"),
    Transaction(month: "September, 2024", name: "Uber-Ride", amount: "\$15.00", date: "Sep 22, 10:24 AM"),
  ]});
}

class TransactionHistoryScreen extends StatelessWidget {
  final TransactionHistory history = const TransactionHistory();

  const TransactionHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.bodyBagroundColor,
        title: const Text('Transaction'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black), // Left arrow icon
          onPressed: () {
            Navigator.of(context).pop(); // Navigate back to the previous page
          },
        ),
        actions: [
          ProfileIcon(userName: 'John Doe'), // Add the ProfileIcon here
        ],
      ),
      body: Column(
        children: [
          ClipPath(
            clipper: CurveClipper(),
            child: Container(
              color:  AppColors.bodyBagroundColor,
              height: 150,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildTimeFilterButton("Today"),
                _buildTimeFilterButton("Week"),
                _buildTimeFilterButton("Month"),
                _buildTimeFilterButton("Year"),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: history.transactions.length,
              itemBuilder: (context, index) {
                final transaction = history.transactions[index];
                final isNewMonth = index == 0 || transaction.month != history.transactions[index - 1].month;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (isNewMonth)
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          transaction.month,
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ListTile(
                      title: Text(transaction.name),
                      subtitle: Text(transaction.date),
                      trailing: Text(transaction.amount),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeFilterButton(String text) {
    return ElevatedButton(
      onPressed: () {
        // Handle the time filter button press
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.purple.withOpacity(0.2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      child: Text(text),
    );
  }
}

class CurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height - 50);
    path.quadraticBezierTo(size.width / 2, size.height, size.width, size.height - 50);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}