import 'package:finance/screens/budget/budget_screen.dart';
import 'package:finance/screens/home/add_expences.dart';
import 'package:finance/screens/home/home_screen.dart';
import 'package:finance/screens/login/login_screen.dart';
import 'package:finance/screens/profile/profile_screen.dart';
import 'package:finance/screens/splash/get_start_screen_one.dart';
import 'package:finance/screens/splash/splash_screen.dart';
import 'package:finance/screens/transactional/transactional_screen.dart';
import 'package:flutter/material.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}