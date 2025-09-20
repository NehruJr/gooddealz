import 'package:flutter/material.dart';
import 'package:goodealz/core/ys_localizations/ys_localizations.dart';

import '../../core/constants/app_colors.dart';
import 'main_text.dart';

class NoDataWidget extends StatelessWidget {
  const NoDataWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: MainText(
        'no_data'.tr,
        fontSize: 18,
        color: AppColors.yBlackColor.withOpacity(0.7),
        fontWeight: FontWeight.w500,
      ),
    );
  }
}
