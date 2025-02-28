import 'package:finance/utils/colors.dart';
import 'package:flutter/material.dart';

class ProfileIcon extends StatelessWidget {
  final String userName;

  ProfileIcon({required this.userName});

  String getInitials(String name) {
    List<String> nameParts = name.split(' ');
    String initials = '';
    if (nameParts.length > 1) {
      initials = nameParts[0][0] + nameParts[1][0];
    } else if (nameParts.length == 1) {
      initials = nameParts[0][0];
    }
    return initials.toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      child: Text(
        getInitials(userName),
        style: TextStyle(color: Colors.white),
      ),
      backgroundColor: AppColors.primaryColor,
    );
  }
}