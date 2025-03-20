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
        preferredSize: Size.fromHeight(180), // Increased height for new text
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
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back, size: 28),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  Text('Budgets', style: AppStyles.title),
                  CircleAvatar(
                    backgroundImage: AssetImage('images/avatar.png'),
                    radius: 20,
                  ),
                ],
              ),
              SizedBox(height: 10),
              Text(
                'September 2024',
                style: AppStyles.miniText,
              ),
              SizedBox(height: 5),
              Text(
                '\$1,812', // Added centered header
                style: AppStyles.bodyHeadTitle,
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
            ], Icons.receipt_long, AppColors.primaryColor),
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
                  Text('Left to spend', style:AppStyles.miniText),
                  SizedBox(height: 4),
                  Text('\$$leftToSpend', style: AppStyles.miniText),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('Monthly budget', style: AppStyles.bodyMini),
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
              Text(title, style: AppStyles.bodyTitle),
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
          Text(name, style: TextStyle(fontSize: 16, color: AppColors.textPrimaryLight)),
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
