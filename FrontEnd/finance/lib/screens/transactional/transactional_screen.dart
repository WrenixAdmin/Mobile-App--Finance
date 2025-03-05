import 'package:finance/components/ProfileIcon.dart';
import 'package:flutter/material.dart';

class Transaction {
  final String month;
  final String name;
  final String amount;
  final String date;
  final String icon;

  const Transaction({
    required this.month,
    required this.name,
    required this.amount,
    required this.date,
    required this.icon,
  });
}

class TransactionHistoryScreen extends StatelessWidget {
  final List<Transaction> transactions = const [
    Transaction(month: "October, 2024", name: "Starbucks-Coffee", amount: "\$12.50", date: "Oct 19, 05:45 AM", icon: "assets/starbucks.png"),
    Transaction(month: "October, 2024", name: "Uber-Ride", amount: "\$54.00", date: "Oct 15, 09:10 PM", icon: "assets/uber.png"),
    Transaction(month: "October, 2024", name: "Uber-Ride", amount: "\$25.00", date: "Oct 12, 02:13 PM", icon: "assets/uber.png"),
    Transaction(month: "October, 2024", name: "Walmart-Household", amount: "\$10.50", date: "Oct 07, 09:10 PM", icon: "assets/walmart.png"),
    Transaction(month: "October, 2024", name: "Pizzahut-Chilly Fry Pizza", amount: "\$08.00", date: "Oct 02, 01:19 AM", icon: "assets/pizzahut.png"),
    Transaction(month: "September, 2024", name: "Uber-Ride", amount: "\$13.00", date: "Sep 28, 09:10 PM", icon: "assets/uber.png"),
    Transaction(month: "September, 2024", name: "Walmart-Table", amount: "\$20.00", date: "Sep 25, 09:10 PM", icon: "assets/walmart.png"),
    Transaction(month: "September, 2024", name: "Uber-Ride", amount: "\$15.00", date: "Sep 22, 10:24 AM", icon: "assets/uber.png"),
  ];

  const TransactionHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        backgroundColor: Colors.purple.shade100,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text("Transaction", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        centerTitle: false,
        actions: [
          IconButton(icon: const Icon(Icons.search, color: Colors.black), onPressed: () {}),
          ProfileIcon(userName: "John Doe"),
          const SizedBox(width: 15),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: ["Today", "Week", "Month", "Year"]
                  .map((filter) => _buildFilterButton(filter))
                  .toList(),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: transactions.length,
              itemBuilder: (context, index) {
                final transaction = transactions[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.white,
                    backgroundImage: AssetImage(transaction.icon),
                  ),
                  title: Text(transaction.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(transaction.date, style: TextStyle(color: Colors.grey.shade600)),
                  trailing: Text(transaction.amount, style: const TextStyle(fontWeight: FontWeight.bold)),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterButton(String text) {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.black,
        backgroundColor: Colors.purple.shade100,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      child: Text(text),
    );
  }
}