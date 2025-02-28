import 'package:flutter/material.dart';
import '../../components/custom_clip_path.dart';
import '../../utils/colors.dart';
import '../../utils/icons.dart';
import '../../utils/style.dart';

class ScreenThree extends StatelessWidget {
  const ScreenThree({super.key});

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
                    child: const Text('Skip',
                      style: AppStyles.button,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 100), // Increased space above the image
                    Image.asset('assets/screen_one.png', height: 200),
                    const Column(
                      // Increased space between the two texts
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 200),
                        Text(
                          'Subscription & SMS',
                          style: AppStyles.title,
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 10), // Space between the two texts
                        Text(
                          'Tracker',
                          style: AppStyles.title,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                    const SizedBox(height: 40), // Increased space below the texts
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: const Text(
                  'Lorem Ipsum is simply dummy text of the printing and typesetting industry.',
                  textAlign: TextAlign.center,
                  style: AppStyles.subtitle,
                ),
              ),
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(AppIcons.inactiveIndicator, size: 10, color: AppColors.indicatorInactive),
                  Icon(AppIcons.activeIndicator, size: 10, color: AppColors.indicatorInactive),
                  Icon(AppIcons.inactiveIndicator, size: 10, color: AppColors.indicatorActive),
                ],
              ),
              const SizedBox(height: 40), // Add some space at the bottom
            ],
          ),
        ],
      ),
    );
  }
}