import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:goodealz/core/constants/app_colors.dart';
import 'package:goodealz/core/helper/extensions/assetss_widgets.dart';
import 'package:goodealz/core/helper/functions/get_asset.dart';
import 'package:goodealz/views/widgets/rounded_square.dart';

import '../../../core/ys_localizations/ys_localizations_provider.dart';
import '../../../providers/notification/notification_provider.dart';

class NotificationIcon extends StatelessWidget {
  const NotificationIcon({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return RoundedSquare(
      bgColor: Colors.white,
      size: 45,
      padding: 12.aEdge,
      child: Stack(
        alignment: Alignment.topRight,
        children: [
          SvgPicture.asset(
            getSvgAsset('Notification'),
          ),
          if(Provider.of<NotificationProvider>(context)
              .isUnRead) const CircleAvatar(
            radius: 5,
            backgroundColor: Colors.white,
            child: CircleAvatar(
              radius: 3.5,
              backgroundColor: AppColors.yOrangeColor,
            ),
          ),
        ],
      ),
    );
  }
}
