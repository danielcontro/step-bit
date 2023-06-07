import 'package:flutter/material.dart';

import '../utils/app_colors.dart';

class UserGreeting extends StatelessWidget {
  final String name;

  const UserGreeting({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    return Text(
      "Hello $name!",
      style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 30,
          color: AppColors.primaryColor),
    );
  }
}
