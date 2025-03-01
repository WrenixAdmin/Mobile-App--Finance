import 'package:flutter/material.dart';
import '../../components/custom_clip_path.dart';
import '../../utils/colors.dart';
import '../../utils/icons.dart';
import '../../utils/style.dart';
import 'get_start_screen_three.dart';

class ScreenTwo extends StatelessWidget {
  const ScreenTwo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          ClipPath(
            clipper: CustomClipPath(),
            child: Container(
              height: 450,
              color: AppColors.lightPurpleColor,
            ),
          ),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 40, right: 20),
                child: Align(
                  alignment: Alignment.topRight,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const ScreenThree()),
                      );
                    },

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
                    Image.asset('images/screen_one.png', height: 300),
                    const Column(
                      // Increased space between the two texts
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: 50),
                        Text(
                          'MS Extraction &',
                          style: AppStyles.title,
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Subscription Detection',
                          style: AppStyles.title,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(bottom: 20),
                child: Text(
                  'Lorem Ipsum is simply dummy text of the printing and typesetting industry.',
                  textAlign: TextAlign.center,
                  style: AppStyles.subtitle,
                ),
              ),
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(AppIcons.inactiveIndicator, size: 10, color: AppColors.indicatorInactive),
                  Icon(AppIcons.activeIndicator, size: 10, color: AppColors.indicatorActive),
                  Icon(AppIcons.inactiveIndicator, size: 10, color: AppColors.indicatorInactive),
                ],
              ),
              const SizedBox(height: 40),
            ],
          ),
        ],
      ),
    );
  }
}