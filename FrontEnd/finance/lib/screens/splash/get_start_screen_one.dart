import 'package:flutter/material.dart';
import '../../components/custom_clip_path.dart';
import '../../utils/colors.dart';
import '../../utils/icons.dart';


class ScreenOne extends StatelessWidget {
  const ScreenOne({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          ClipPath(
            clipper: CustomClipPath(),
            child: Container(
              height: 500,
              color: AppColors.lightPurpleColor, // No corresponding color in AppColors
            ),
          ),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 40, right: 20),
                child: Align(
                  alignment: Alignment.topRight,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      backgroundColor: AppColors.primaryColor,
                    ),
                    child: const Text('Skip'),
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('assets/screen_one.png', height: 200),
                    const SizedBox(height: 20),
                    const Text(
                      'Smart Expense Tracker',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        'Lorem Ipsum is simply dummy text of the printing and typesetting industry.',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16, color: AppColors.textSecondary),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(AppIcons.inactiveIndicator, size: 10, color: AppColors.indicatorInactive),
                        Icon(AppIcons.activeIndicator, size: 10, color: AppColors.indicatorActive),
                        Icon(AppIcons.inactiveIndicator, size: 10, color: AppColors.indicatorInactive),
                      ],

                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}