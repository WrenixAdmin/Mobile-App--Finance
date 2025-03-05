import 'package:flutter/material.dart';

class LogoutDialog extends StatelessWidget {
  final VoidCallback onConfirm;

  const LogoutDialog({Key? key, required this.onConfirm}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      contentPadding: EdgeInsets.all(20),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.error_outline, color: Colors.red, size: 60),
          SizedBox(height: 16),
          Text(
            "Confirm the Logout.",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            "Are you sure you want to log out?\nAny unsaved changes will be lost.",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: Colors.black54),
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text("Cancel", style: TextStyle(color: Colors.grey, fontSize: 16)),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Close dialog
                  onConfirm(); // Execute logout function
                },
                child: Text("Confirm", style: TextStyle(color: Colors.purple, fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
