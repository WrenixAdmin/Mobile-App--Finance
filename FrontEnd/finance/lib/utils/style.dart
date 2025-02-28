import 'package:flutter/material.dart';
import 'colors.dart';

class AppStyles {
  static const TextStyle title = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
    fontFamily: 'Poppins',
  );

  static const TextStyle subtitle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: AppColors.textSecondary,
    fontFamily: 'Poppins',
  );

  static const TextStyle button = TextStyle(
    fontSize: 16,
    color: AppColors.secondaryColor,
    fontFamily: 'Poppins',
  );

  static const TextStyle body = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: AppColors.textPrimary,
    fontFamily: 'Poppins',
  );
}