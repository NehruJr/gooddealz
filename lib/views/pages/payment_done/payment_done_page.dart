import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:goodealz/core/constants/app_colors.dart';
import 'package:goodealz/core/constants/app_routes.dart';
import 'package:goodealz/core/helper/extensions/assetss_widgets.dart';
import 'package:goodealz/core/helper/extensions/context_size.dart';
import 'package:goodealz/core/helper/functions/get_asset.dart';
import 'package:goodealz/core/ys_localizations/ys_localizations.dart';
import 'package:goodealz/views/pages/home/home_page.dart';
import 'package:goodealz/views/widgets/main_button.dart';
import 'package:goodealz/views/widgets/main_page.dart';
import 'package:goodealz/views/widgets/main_text.dart';

import '../../../data/models/purchase_code_model.dart';

class PaymentDonePage extends StatelessWidget {
  const PaymentDonePage({super.key, required this.orderNumber, required this.purchaseCodes});

  final String orderNumber;
  final List<PurchaseCode> purchaseCodes;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async{
          
            return false;
          
        },
      child: MainPage(
        isAppBar: false,
        body: Center(
          child: ListView(
            padding: 16.aEdge,
            // crossAxisAlignment: CrossAxisAlignment.center,
            // // mainAxisAlignment: MainAxisAlignment.spaceAround,
            // mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                height: context.width / 2,
                width: context.width / 2,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: AppColors.yPrimaryColor,
                    width: 12,
                  ),
                  shape: BoxShape.circle,
                ),
                child: Padding(
                  padding: 35.aEdge,
                  child: SvgPicture.asset(getSvgAsset('check')),
                ),
              ),
              64.sSize,
              MainText(
                'congratulation'.tr,
                textAlign: TextAlign.center,
                color: Colors.black,
                fontSize: 24,
                fontWeight: FontWeight.w500,
              ),
              12.sSize,
              MainText(
                // 'Payment is the transfer of money \nPull a number # $orderNumber',
                '${'order_created'.tr} # $orderNumber',
                textAlign: TextAlign.center,
                color: Colors.black.withOpacity(0.5),
                fontSize: 14,
              ),
              12.sSize,
              MainText(
                // 'Payment is the transfer of money \nPull a number # $orderNumber',
                'purchase_codes'.tr,
                textAlign: TextAlign.center,
                color: Colors.black,
                fontSize: 14,
              ),
      
              ...List.generate(
                purchaseCodes.length,
                    (i) {
                      return Padding(
                         padding: const EdgeInsets.symmetric(vertical: 16),
                        child: MainText(
                                      purchaseCodes[i].code??'',
                                      textAlign: TextAlign.center,
                                      color: Colors.black.withOpacity(0.5),
                                      fontSize: 14,
                                    ),
                      );
                    }
              ),
              16.sSize,
              // MainButton(
              //   onPressed: () {
              //     AppRoutes.routeTo(context, const MyOrdersPage(fromPayment : true));
              //   },
              //   color: AppColors.yPrimaryColor,
              //   width: 175,
              //   radius: 28,
              //   child: MainText(
              //     'get_receipt'.tr,
              //     fontSize: 15,
              //     color: Colors.white,
              //     fontWeight: FontWeight.w500,
              //   ),
              // ),
              // 12.sSize,
              MainButton(
                onPressed: () {
                  AppRoutes.routeRemoveAllTo(context, const HomePage());
                },
                color: const Color(0xFFFFE8E1),
                width: 175,
                radius: 28,
                child: MainText(
                  'back_home'.tr,
                  fontSize: 15,
                  color: AppColors.yPrimaryColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
