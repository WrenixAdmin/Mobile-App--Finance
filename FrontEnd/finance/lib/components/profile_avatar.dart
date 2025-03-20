// profile_avatar.dart
import 'package:flutter/material.dart';

class ProfileAvatar extends StatelessWidget {
  final String? displayName;
  final double radius;
  final Color backgroundColor;

  const ProfileAvatar({
    Key? key,
    this.displayName,
    required this.radius,
    this.backgroundColor = const Color(0xFFE0E0E0), // Light gray background
  }) : super(key: key);

  String _getInitials() {
    if (displayName == null || displayName!.isEmpty) return '?';
    
    final names = displayName!.trim().split(' ');
    if (names.length >= 2) {
      return '${names[0][0]}${names[1][0]}'.toUpperCase();
    }
    return names[0][0].toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: backgroundColor,
      child: Text(
        _getInitials(),
        style: TextStyle(
          color: Colors.black87,
          fontSize: radius * 0.8,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}