import 'package:flutter/material.dart';

class AppColors {
  static Brightness theme = Brightness.dark;
  static Color primaryColor = Colors.lime;

  static Color textColor =
      AppColors.theme == Brightness.dark ? Colors.white : Colors.black;

  static Color boxDecorationColor =
      AppColors.theme == Brightness.dark ? Colors.black : Colors.white;
}
