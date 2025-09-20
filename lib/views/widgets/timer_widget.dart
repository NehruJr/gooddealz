import 'package:flutter/material.dart';
import 'package:goodealz/core/constants/app_colors.dart';
import 'package:goodealz/core/ys_localizations/ys_localizations.dart';
import 'package:goodealz/views/widgets/main_text.dart';

class TimerWidget extends StatelessWidget {
  final void Function()? onEnd;

  const TimerWidget({Key? key, this.onEnd}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<Duration>(

      duration: const Duration(minutes: 1),
      tween: Tween(begin: const Duration(minutes: 1), end: Duration.zero),
      onEnd: onEnd,
      builder: (BuildContext context, Duration value, Widget? child) {
        final minutes = value.inMinutes;
        final seconds = value.inSeconds % 60;
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              MainText(
                'resend_in'.tr,
                    color: AppColors.yBlackColor.withOpacity(.6),
                    fontSize: 15,
              ),
              const SizedBox(width: 5),
              MainText(
                '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}',
                    color: AppColors.yPrimaryColor,
                    fontSize: 15,
              ),
              // SizedBox(width: 5),
              // MainText(
              //   'second'.tr,
              //       color: AppColors.yBlackColor.withOpacity(.6),
              //       fontSize: 15,
              // ),
            ],
          ),
        );
      },
    );
  }
}
