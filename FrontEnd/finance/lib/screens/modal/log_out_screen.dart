import 'package:finance/screens/login/login_screen.dart';
import 'package:finance/utils/colors.dart';
import 'package:flutter/material.dart';

class LogoutDialog extends StatelessWidget {
  final VoidCallback onConfirm;

  const LogoutDialog({super.key, required this.onConfirm});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      contentPadding: const EdgeInsets.all(20),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.error_outline, color: AppColors.statusRed, size: 60),
          const SizedBox(height: 16),
          const Text(
            "Confirm the Logout.",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            "Are you sure you want to log out?\nAny unsaved changes will be lost.",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: Colors.black54),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancel", style: TextStyle(color: Colors.grey, fontSize: 16)),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Close dialog
                  onConfirm();
                  Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()));


                },
                child: const Text("Confirm", style: TextStyle(color: AppColors.primaryColor, fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
