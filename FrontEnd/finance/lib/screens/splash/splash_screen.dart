import 'package:finance/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:finance/screens/splash/get_start_screen_one.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const ScreenOne()),
      );
    });

    return const Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: Center(
        child: Icon(
          Icons.ac_unit,
          size: 100.0,
          color: AppColors.secondaryColor,
        ),
      ),
    );
  }
}