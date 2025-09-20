import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:goodealz/core/helper/extensions/assetss_widgets.dart';
import 'package:goodealz/core/helper/extensions/context_size.dart';
import 'package:goodealz/core/ys_localizations/ys_localizations.dart';
import 'package:goodealz/data/remote/remote_data.dart';
import 'package:goodealz/views/widgets/main_page.dart';
import 'package:goodealz/views/widgets/main_text.dart';

import '../../../core/ys_localizations/ys_localizations_provider.dart';
import '../../../data/models/discount/coupon_model.dart';
import '../../../providers/purchase_code_provider.dart';
import '../../widgets/no_data_widget.dart';
import 'widgets/purchase_widget.dart';

class PurchaseCodePage extends StatefulWidget {
  const PurchaseCodePage({super.key});

  @override
  State<PurchaseCodePage> createState() => PurchaseCodePageState();
}

class PurchaseCodePageState extends State<PurchaseCodePage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<PurchaseProvider>(context, listen: false)
          .getPurchaseCodes(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MainPage(
      title: 'purchase_codes'.tr,
      body: SingleChildScrollView(
        padding: 16.aEdge,
        child: Column(
          children: [
            Consumer<PurchaseProvider>(builder: (context, purchaseProvider, _) {
              if (purchaseProvider.PurchaseLoader) {
                return const Center(
                      child: CircularProgressIndicator(),
                    );
              } else {
                return purchaseProvider.purchaseCodes.isNotEmpty ? ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: purchaseProvider.purchaseCodes.length,
                      itemBuilder: (context, i) {
                        return PurchaseWidget(
                          productDetails: purchaseProvider.purchaseCodes[i].productDetails!,
                          code:  purchaseProvider.purchaseCodes[i].code!,
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
        surfaceTintColor: Colors.white,
        elevation: 2,
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
