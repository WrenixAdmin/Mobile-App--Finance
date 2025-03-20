import 'package:finance/utils/colors.dart';
import 'package:finance/utils/icons.dart';
import 'package:flutter/material.dart';
import 'package:finance/screens/home/home_screen.dart';
import 'package:finance/screens/summery/summery_screen.dart';

import '../screens/budget/budget_screen.dart';
import '../screens/transactional/transactional_screen.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: AppColors.white,
      items: [
        BottomNavigationBarItem(
          icon: Icon(
            AppIcons.home,
            color: currentIndex == 0 ? AppColors.primaryColor : AppColors.black,
          ),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            AppIcons.spending,
            color: currentIndex == 1 ? AppColors.primaryColor : AppColors.black,
          ),
          label: 'Spending',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            AppIcons.transaction,
            color: currentIndex == 2 ? AppColors.primaryColor : AppColors.black,
          ),
          label: 'Transaction',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            AppIcons.budget,
            color: currentIndex == 3 ? AppColors.primaryColor : AppColors.black,
          ),
          label: 'Budget',
        ),
      ],
      currentIndex: currentIndex,
      selectedItemColor: AppColors.primaryColor,
      onTap: (index) {
        switch (index) {
          case 0:
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen()),
            );
            break;
          case 1:
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SpendingScreen()),
            );
            break;
          case 2:
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => TransactionHistoryScreen()),
            );
            break;
          case 3:
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => BudgetScreen()),
            );
        // Add cases for other indices if needed
        }
        onTap(index);
      },
    );
  }
}