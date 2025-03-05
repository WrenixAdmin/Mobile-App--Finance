import 'package:flutter/material.dart';
import '../../components/navigator.dart';
import '../../components/profile_avatar.dart';
import '../../service/greeting.dart';
import '../../utils/colors.dart';
import '../../utils/style.dart';
import '../profile/profile_screen.dart';

class BudgetScreen extends StatelessWidget {
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
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildBudgetOverview(738, 2550),
            SizedBox(height: 20),
            _buildCategoryCard('Food & transport', 700, [
              _buildSubCategory('Foods', 350, 186),
              _buildSubCategory('Rides', 250, 120),
            ], Icons.directions_car, AppColors.primaryColor),
            SizedBox(height: 20),
            _buildCategoryCard('Bill & Utilities', 320, [
              _buildSubCategory('Subscriptions', 52, 0),
              _buildSubCategory('House service', 138, 10),
              _buildSubCategory('Maintenance', 130, 30),
            ], Icons.receipt_long, AppColors.black),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: 3, // Set the current index to the Budget screen
        onTap: (index) {
          // Handle navigation logic
        },
      ),
    );
  }

  Widget _buildBudgetOverview(double leftToSpend, double monthlyBudget) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3))],
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
                  Text('Left to spend', style: TextStyle(fontSize: 14, color: Colors.black54)),
                  SizedBox(height: 4),
                  Text('\$$leftToSpend', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('Monthly budget', style: TextStyle(fontSize: 14, color: Colors.black54)),
                  SizedBox(height: 4),
                  Text('\$$monthlyBudget', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ],
              ),
            ],
          ),
          SizedBox(height: 10),
          LinearProgressIndicator(
            value: leftToSpend / monthlyBudget,
            backgroundColor: Colors.grey[300],
            valueColor: AlwaysStoppedAnimation(AppColors.primaryColor),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryCard(String title, double total, List<Widget> subCategories, IconData icon, Color color) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color),
              SizedBox(width: 10),
              Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Spacer(),
              Text('\$$total', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ],
          ),
          SizedBox(height: 10),
          ...subCategories,
        ],
      ),
    );
  }

  Widget _buildSubCategory(String name, double amount, double left) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(name, style: TextStyle(fontSize: 16, color: Colors.black54)),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('\$$amount', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              Text('Left \$$left', style: TextStyle(fontSize: 14, color: Colors.black45)),
            ],
          ),
        ],
      ),
    );
  }
}
