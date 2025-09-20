import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:goodealz/core/constants/app_routes.dart';
import 'package:goodealz/core/helper/extensions/assetss_widgets.dart';
import 'package:goodealz/core/helper/functions/get_asset.dart';
import 'package:goodealz/views/pages/live_draws/live_draws_page.dart';
import 'package:goodealz/views/widgets/rounded_square.dart';
import 'package:goodealz/views/widgets/sub_widgets/notification_icon.dart';

import '../../notification/notification_page.dart';

class HomeAppBar extends StatelessWidget {
  const HomeAppBar({

    super.key, required this.isGuest,
  });

  final bool isGuest;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: 8.aEdge,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          RoundedSquare(
            icon: 'menu',
            bgColor: Colors.white,
            size: 45,
            padding: 14.aEdge,
            onTap: () {
              if (Scaffold.of(context).isDrawerOpen) {
                Scaffold.of(context).closeDrawer();
              } else {
                Scaffold.of(context).openDrawer();
              }
            },
          ),
          // 8.sSize,
          GestureDetector(
            onTap: () {
              AppRoutes.routeTo(context, const LiveDrawsPage());
            },
            child: SizedBox(
              height: 30,
              width: 110,
              child: SvgPicture.asset(
                getSvgAsset('logo'),
              ),
            ),
          ),
          // const Spacer(),
          if(!isGuest)GestureDetector(
              onTap: () {
                AppRoutes.routeTo(context, const NotificationPage());
              },
              child: const NotificationIcon()),
        ],
      ),
    );
  }
}
