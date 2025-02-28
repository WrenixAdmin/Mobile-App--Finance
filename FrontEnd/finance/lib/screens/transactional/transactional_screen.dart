import 'package:finance/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:finance/components/ProfileIcon.dart';

import '../../components/curve_cliper.dart';

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
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

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
              color: AppColors.bodyBagroundColor,
              height: screenHeight * 0.2,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.02, vertical: screenHeight * 0.01),
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
          Container(
            margin: EdgeInsets.all(screenWidth * 0.03),
            padding: EdgeInsets.all(screenWidth * 0.05),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: Offset(0, 3), // changes position of shadow
                ),
              ],
            ),
            child: Column(
              children: [
                SizedBox(height: screenHeight * 0.01),
                Container(
                  height: screenHeight * 0.4, // Adjust the height of the 3D container
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: history.transactions.length,
                    itemBuilder: (context, index) {
                      final transaction = history.transactions[index];
                      return ListTile(
                        title: Text(transaction.name),
                        subtitle: Text(transaction.date),
                        trailing: Text(transaction.amount),
                      );
                    },
                  ),
                ),
              ],
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

