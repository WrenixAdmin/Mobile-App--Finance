import 'package:flutter/material.dart';
import '../../components/ProfileIcon.dart'; // Update the path as necessary

class DashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Good morning,'),
                Text('Nico Robin', style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            ProfileIcon(userName: 'Nico Robin'),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Welcome to Dashboard', style: TextStyle(fontSize: 18)),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text('Home'),
                  Text('Spending'),
                  Text('Insights'),
                  Text('Transaction'),
                ],
              ),
              SizedBox(height: 20),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Total Balance', style: TextStyle(fontSize: 16)),
                      Text('\$50,943', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                      Text('Last 30 Days +12%', style: TextStyle(fontSize: 14)),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text('1D'),
                          Text('1W'),
                          Text('1M'),
                          Text('3M'),
                          Text('1Y'),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Buying Power', style: TextStyle(fontSize: 16)),
                      Text('\$580.00', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                      SizedBox(height: 10),
                      Text('Interest accrued this month \$23.20', style: TextStyle(fontSize: 14)),
                      Text('Lifetime interest paid \$86.52', style: TextStyle(fontSize: 14)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}