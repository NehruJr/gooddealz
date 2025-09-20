import 'package:flutter/material.dart';
import 'package:goodealz/core/helper/functions/navigation_service.dart';
import 'package:goodealz/core/ys_localizations/ys_localizations_provider.dart';

showSnackbar(String message, {bool error = false}) {
  closeSnackbar();
  final locale =
      YsLocalizationsProvider.listenFalse(NavigationService.currentContext);
  ScaffoldMessenger.of(NavigationService.currentContext).showSnackBar(
    SnackBar(
      content: Text(
        message,
        textDirection:
            locale.languageCode == 'ar' ? TextDirection.rtl : TextDirection.ltr,
      ),
      // backgroundColor: error ? AppColors.yRedColor : AppColors.yGreenColor,
    ),
  );
}

closeSnackbar() {
  ScaffoldMessenger.of(NavigationService.currentContext).clearSnackBars();
}
