import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:goodealz/core/constants/app_colors.dart';
import 'package:goodealz/core/helper/extensions/assetss_widgets.dart';
import 'package:goodealz/core/helper/extensions/context_size.dart';
import 'package:goodealz/core/ys_localizations/ys_localizations.dart';
import 'package:goodealz/data/remote/remote_data.dart';
import 'package:goodealz/providers/discount/discount_provider.dart';
import 'package:goodealz/views/widgets/main_page.dart';
import 'package:goodealz/views/widgets/main_text.dart';

import '../../../core/ys_localizations/ys_localizations_provider.dart';
import '../../../data/models/discount/coupon_model.dart';
import '../../widgets/no_data_widget.dart';

class CouponsPage extends StatefulWidget {
  const CouponsPage({super.key, this.fromProfile = false});

  final bool fromProfile;

  @override
  State<CouponsPage> createState() => CouponsPageState();
}

class CouponsPageState extends State<CouponsPage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {

      if(widget.fromProfile){
        Provider.of<DiscountProvider>(context, listen: false)
            .getUserCoupons(context);
      }
      else {
        Provider.of<DiscountProvider>(context, listen: false)
            .getActiveCoupons(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MainPage(
      title: 'coupons'.tr,
      body: SingleChildScrollView(
        padding: 16.aEdge,
        child: Column(
          children: [
            Consumer<DiscountProvider>(builder: (context, discountProvider, _) {
              final coupons = widget.fromProfile ? discountProvider.userCoupons : discountProvider.activeCoupons;
              if (discountProvider.getCouponLoader) {
                return const Center(
                      child: CircularProgressIndicator(),
                    );
              } else {
                return coupons.isNotEmpty ? ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: coupons.length,
                      itemBuilder: (context, i) {
                        return CouponCard(
                          coupon: coupons[i],
                        );
                      },
                    ) : const NoDataWidget();
              }
            })
          ],
        ),
      ),
    );
  }
}

class CouponCard extends StatelessWidget {
  const CouponCard({
    super.key,
    required this.coupon,
  });

  final Coupon coupon;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: (){
        Clipboard.setData(ClipboardData(text: coupon.code!));
      },
      child: Card(
        color: AppColors.yBGColor,
        elevation: 4,
        shadowColor: AppColors.yBlackColor,
        child: Padding(
          padding: 16.aEdge,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: context.width * 0.4,
                    child: MainText(
                      '${coupon.code}',
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      maxLines: 2,
                    ),
                  ),
                  8.sSize,
                  MainText(
                    '${coupon.numberOfUse} ${'item'.tr}',
                    color: Colors.black.withOpacity(0.5),
                    fontSize: 14,
                  ),
                ],
              ),
              MainText(
                coupon.discountType == 'percentage'
                    ? '${'offer'.tr} ${coupon.percent} %'
                    : '${'offer'.tr} ${coupon.amount} ${coupon.currency??''}',
                color: Colors.black.withOpacity(0.5),
                fontSize: 14,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
