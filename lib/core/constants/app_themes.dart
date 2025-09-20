import 'package:flutter/material.dart';
import 'package:goodealz/core/constants/app_colors.dart';

class AppThemes {
  static ThemeData get theme {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: AppColors.yPrimaryColor),
      useMaterial3: true,
    );
  }
}
