import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:goodealz/core/constants/app_routes.dart';
import 'package:goodealz/core/helper/extensions/assetss_widgets.dart';
import 'package:goodealz/core/helper/extensions/context_size.dart';
import 'package:goodealz/core/helper/functions/get_asset.dart';
import 'package:goodealz/core/ys_localizations/ys_localizations.dart';
import 'package:goodealz/data/models/product_model.dart';
import 'package:goodealz/views/pages/product/product_details/product_details_page.dart';
import 'package:goodealz/views/widgets/main_text.dart';


class PurchaseWidget extends StatelessWidget {
  const PurchaseWidget({
    super.key,
    required this.productDetails,
    required this.code,
  });


  final ProductDetails productDetails;
  final String code;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        AppRoutes.routeTo(
            context,
            ProductDetailsPage(
              productDetails: productDetails,
            ));
      },
      child: Container(
        padding: 4.aEdge,
        margin: 8.vEdge,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: 22.cBorder,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 5,
            ),
          ],
        ),
        child: Column(
          children: [
             SizedBox(
              height: 240,
              width: context.width,
              child: Stack(
                children: [
                  
                  ClipRRect(
                    borderRadius: 22.cBorder,
                    child: FancyShimmerImage(
                      imageUrl: productDetails.image ?? '',
                      height: 240,
                      width: context.width - 32,
                      boxFit: BoxFit.contain,
                      errorWidget: Image.asset(
                        getPngAsset('product'),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: 22.cBorder,
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withOpacity(0.6),
                          Colors.black.withOpacity(0.1),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: 24.aEdge,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            MainText(
                              productDetails.title?? '',
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                            32.sSize,
                          ],
                        ),
                      ],
                    ),
                  ),
                  
                ],
              ),
            ),
            Padding(
              padding: 16.aEdge,
              child: Column(
                children: [
                  16.sSize,
                  SizedBox(
                    width: context.width,
                    child: Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              MainText(
                                // 'Buy Unity tee for: AED351.00',
                                'purchase_code'.tr,
                                 fontSize: 16,
                                color: Colors.black,
                                fontWeight: FontWeight.w700,
                              ),
                              MainText(
                                // 'Buy Unity tee for: AED351.00',
                                code ?? '',
                                 fontSize: 16,
                                color: Colors.black,
                                fontWeight: FontWeight.w700,
                              ),
                            ],
                          ),
                        ),
                       ],
                    ),
                  ), ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
