import 'package:flutter/material.dart';

class GreetingMessage {
  String getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good morning 😊';
    } else if (hour < 18) {
      return 'Good afternoon 😃';
    } else {
      return 'Good evening 🌙';
    }
  }
}
