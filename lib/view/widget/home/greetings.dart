import 'package:flutter/material.dart';

class Greeting extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String greeting = getGreeting();
    return Text(
      greeting,
      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    );
  }

  String getGreeting() {
    DateTime now = DateTime.now();
    int hour = now.hour;

    if (hour >= 0 && hour < 12) {
      return "صباح الخير 🌞";
    } else {
      return "مساء الخير 🌙";
    }
  }
}
