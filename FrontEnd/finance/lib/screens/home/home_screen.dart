import 'package:finance/components/profile_avatar.dart';
import 'package:finance/screens/profile/profile_screen.dart';
import 'package:finance/utils/colors.dart';
import 'package:finance/utils/style.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';


import '../../components/navigator.dart';
import '../../service/greeting.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(150),
        child: Container(
          padding: EdgeInsets.only(top: 40, left: 16, right: 16),
          decoration: const BoxDecoration(
            color: AppColors.lightPurpleColor,
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
                          style: AppStyles.body),
                      const SizedBox(height: 4),
                      const Text('Nico Robin',
                          style: AppStyles.headr),
                      const Text('Welcome to Dashboard',
                          style: AppStyles.body),
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
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6,
                    offset: Offset(0, 3),
                  )
                ],
              ),
              child: Column(
                children: [
                  const Text('Total Balance',
                      style: AppStyles.headr),
                  SizedBox(height: 8),
                  const Text('\$50,943',
                      style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
                  SizedBox(height: 4),
                  const Text('Last 30 Days +12%',
                      style: TextStyle(color: AppColors.statusGreen, fontSize: 16)),
                  const SizedBox(height: 16),
                  Container(height: 150, child: _buildChart()),
                ],
              ),
            ),
            SizedBox(height: 50),
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
      bottomNavigationBar: CustomBottomNavigationBar(currentIndex: 0, onTap: (index) {}),
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
            color: AppColors.primaryColor,
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
        color: AppColors.lightPurpleColor,
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
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