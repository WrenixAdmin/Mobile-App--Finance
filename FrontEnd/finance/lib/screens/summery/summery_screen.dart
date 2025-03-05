import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../components/navigator.dart';
import '../../components/profile_avatar.dart';
import '../profile/profile_screen.dart';


class SpendingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(180),
        child: Container(
          padding: EdgeInsets.only(top: 50, left: 16, right: 16, bottom: 20),
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
                      Text('Summary',
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold)),
                      SizedBox(height: 4),
                      Text('Total Balance',
                          style: TextStyle(fontSize: 14, color: Colors.black54)),
                      SizedBox(height: 4),
                      Text('\$678.40',
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ProfileScreen()),
                      );
                    },
                    child: ProfileAvatar(
                      imagePath: 'images/avatar.png',
                      radius: 24,
                    ),
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
            Center(
              child: ToggleButtons(
                borderRadius: BorderRadius.circular(20),
                selectedColor: Colors.white,
                fillColor: Colors.purple,
                color: Colors.black54,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text('Monthly'),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text('Weekly'),
                  ),
                ],
                isSelected: [true, false],
                onPressed: (index) {},
              ),
            ),
            SizedBox(height: 16),
            Text('Spending by Category',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildSpendingCard('Your Spending Last Month', '\$31,943', '+30%'),
                    SizedBox(width: 16),
                    _buildSpendingCard('Projected This Month', '\$30,000', ''),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(currentIndex: 1, onTap: (index) {}),
    );
  }

  Widget _buildSpendingCard(String title, String amount, String change) {
    return Container(
      width: 300,
      margin: EdgeInsets.symmetric(vertical: 6),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(fontSize: 16, color: Colors.black54)),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(amount, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              if (change.isNotEmpty)
                Text(change, style: TextStyle(fontSize: 16, color: Colors.green)),
            ],
          ),
          SizedBox(height: 16),
          Container(height: 100, child: _buildChart()),
        ],
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
}
