import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:goodealz/core/helper/functions/get_asset.dart';
import 'package:goodealz/core/ys_localizations/ys_localizations.dart';
import 'package:goodealz/views/widgets/main_text.dart';
class NoConnectionWidget extends StatelessWidget {
  const NoConnectionWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              getSvgAsset('wifi-solid'),
              // color: black.withOpacity(.6),
              width: 50,
              height: 50,
            ),
            MainText(
              'noInternet'.tr,
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
            // Text(
            //   'makeSureConnected'.tr,
            //   style: TextStyle(
            //     fontSize: 14.sp,
            //     fontFamily: 'TajawalBold',
            //     color: black.withOpacity(.6),
            //   ),
            //   textAlign: TextAlign.center,
            // ),
          ],
        ),
      ),
    );
  }
}
