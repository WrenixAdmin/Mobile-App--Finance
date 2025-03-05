import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../service/greeting.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(150),
        child: Container(
          padding: EdgeInsets.only(top: 40, left: 16, right: 16),
          decoration: BoxDecoration(
            color: Color(0xFFD7C3FB),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(GreetingMessage().getGreeting(),
                          style: TextStyle(fontSize: 16, color: Colors.black54)),
                      SizedBox(height: 4),
                      Text('Nico Robin',
                          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                      Text('Welcome to Dashboard',
                          style: TextStyle(fontSize: 14, color: Colors.black54)),
                    ],
                  ),
                  CircleAvatar(
                    backgroundImage: AssetImage('assets/profile.jpg'),
                    radius: 24,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6,
                    offset: Offset(0, 3),
                  )
                ],
              ),
              child: Column(
                children: [
                  Text('Total Balance',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  Text('\$50,943',
                      style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
                  SizedBox(height: 4),
                  Text('Last 30 Days +12%',
                      style: TextStyle(color: Colors.green, fontSize: 16)),
                  SizedBox(height: 16),
                  Container(height: 150, child: _buildChart()),
                ],
              ),
            ),
            SizedBox(height: 16),
            Column(
              children: [
                _buildInfoTile('Buying Power', '\$580.00'),
                _buildInfoTile('Interest accrued this month', '\$23.20'),
                _buildInfoTile('Lifetime interest paid', '\$86.52'),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Spending'),
          BottomNavigationBarItem(icon: Icon(Icons.swap_horiz), label: 'Transaction'),
          BottomNavigationBarItem(icon: Icon(Icons.account_balance_wallet), label: 'Budget'),
        ],
        currentIndex: 0,
        selectedItemColor: Colors.purple,
        onTap: (int index) {},
      ),
    );
  }

  Widget _buildChart() {
    return LineChart(
      LineChartData(
        gridData: FlGridData(show: false),
        titlesData: FlTitlesData(show: false),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: [
              FlSpot(0, 2),
              FlSpot(1, 2.5),
              FlSpot(2, 1.8),
              FlSpot(3, 2.2),
              FlSpot(4, 1.5),
              FlSpot(5, 2.8),
              FlSpot(6, 2.5),
            ],
            isCurved: true,
            color: Colors.purple,
            barWidth: 3,
            dotData: FlDotData(show: false),
            belowBarData: BarAreaData(show: false),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoTile(String title, String amount) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 6),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: TextStyle(fontSize: 16, color: Colors.black54)),
          Text(amount, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        ],
      ),
    );
  }
}
