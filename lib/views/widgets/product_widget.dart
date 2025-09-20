import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:goodealz/core/constants/app_colors.dart';
import 'package:goodealz/core/constants/app_routes.dart';
import 'package:goodealz/core/helper/extensions/assetss_widgets.dart';
import 'package:goodealz/core/helper/extensions/context_size.dart';
import 'package:goodealz/core/helper/extensions/string_to_from.dart';
import 'package:goodealz/core/helper/functions/get_asset.dart';
import 'package:goodealz/core/ys_localizations/ys_localizations.dart';
import 'package:goodealz/core/ys_localizations/ys_localizations_provider.dart';
import 'package:goodealz/data/models/product_model.dart';
import 'package:goodealz/providers/product/product_provider.dart';
import 'package:goodealz/views/pages/product/product_details/product_details_page.dart';
import 'package:goodealz/views/widgets/main_button.dart';
import 'package:goodealz/views/widgets/main_text.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import '../../providers/cart/cart_provider.dart';

class ProductWidget extends StatelessWidget {
  const ProductWidget({
    super.key,
    this.isDone = false,
    this.isLive = false,
    required this.productDetails,
  });

  final bool isDone;
  final bool isLive;
  final ProductDetails productDetails;

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
            isDone
                ? 0.sSize
                : Container(
                    padding: 26.aEdge,
                    alignment: Alignment.centerLeft,
                    child: CircularPercentIndicator(
                      radius: 40,
                      // default: max available space
                      percent:
                          (productDetails.salesPercentage.toDoubleNum <= 100 ? productDetails.salesPercentage.toDoubleNum  : 100) / 100,
                      lineWidth: 5,
                      // default: 15, bar width
                      circularStrokeCap: CircularStrokeCap.round,
                      progressColor: const Color(0xFF17BADA),
                      // default: blue, main bar color
                      backgroundColor: const Color(0xFFE6E6E6),

                      center: Center(
                        child: FittedBox(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              MainText(
                                '${productDetails.quantity ?? ''}',
                                fontSize: 12,
                                color: AppColors.ySecondry2Color,
                                fontWeight: FontWeight.w700,
                              ),
                              2.sSize,
                              MainText(
                                'in_stock'.tr,
                                fontSize: 9,
                                color: Colors.black,
                                fontWeight: FontWeight.w700,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
            // isDone
            //     ? 0.sSize
            //     : Row(
            //         mainAxisAlignment: MainAxisAlignment.start,
            //         children: [
            //           Container(
            //             width: 100,
            //             height: 80,
            //             margin: 16.hEdge,
            //             child: Stack(
            //               children: [
            //                 SvgPicture.asset(
            //                   getSvgAsset('rr-border'),
            //                   width: 100,
            //                   height: 80,
            //                 ),
            //                 Container(
            //                   padding: 26.aEdge,
            //                   alignment: Alignment.center,
            //                   child: FittedBox(
            //                     child: Column(
            //                       crossAxisAlignment: CrossAxisAlignment.center,
            //                       children: [
            //                         const MainText(
            //                           '1,400',
            //                           fontSize: 12,
            //                           color: AppColors.ySecondry2Color,
            //                           fontWeight: FontWeight.w700,
            //                         ),
            //                         2.sSize,
            //                         MainText(
            //                           'in_stock'.tr,
            //                           fontSize: 9,
            //                           color: Colors.black,
            //                           fontWeight: FontWeight.w700,
            //                         ),
            //                       ],
            //                     ),
            //                   ),
            //                 ),
            //               ],
            //             ),
            //           ),
            //         ],
            //       ),
            SizedBox(
              height: 240,
              width: context.width,
              child: Stack(
                children: [
                  
                  ClipRRect(
                    borderRadius: 22.cBorder,
                    child: FancyShimmerImage(
                      imageUrl: productDetails.prize?.cover ?? '',
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
                          Colors.black.withOpacity(0),
                          Colors.black.withOpacity(0.6),
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Consumer<ProductProvider>(
                                builder: (context, productProvider, _) {
                              return productProvider.toggleLoader && productProvider.toggleId == productDetails.id
                                  ? const SizedBox(
                                      width: 30,
                                      child: CircularProgressIndicator())
                                  : InkWell(
                                      onTap: () {
                                        productProvider.toggleFavorite(
                                            context, productDetails);
                                      },
                                      child: CircleAvatar(
                                        backgroundColor: Colors.white,
                                        child: SvgPicture.asset(
                                          productProvider
                                                  .isInFavorite(productDetails)
                                              ? getSvgAsset('Heart')
                                              : getSvgAsset('Heart-selected'),
                                          height: 22,
                                        ),
                                      ),
                                    );
                            })
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            MainText(
                              'win'.tr,
                              fontSize: 32,
                              color: AppColors.yPrimaryColor,
                              fontWeight: FontWeight.w900,
                              fontStyle: FontStyle.italic,
                            ),
                            MainText(
                              productDetails.prize?.coverText ?? '',
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
                  isLive
                      ? Center(
                          child: SvgPicture.asset(getSvgAsset('video_play')),
                        )
                      : 0.sSize,
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
                          child: Column(
                            children: [
                              MainText(
                                // 'Buy Unity tee for: AED351.00',
                                productDetails.title ?? '',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                fontSize: 16,
                                color: Colors.black,
                                fontWeight: FontWeight.w700,
                              ),
                              8.sSize,
                              MainText(
                                // 'Draw date: 13 june, 2023 or earlier based on the time passed.',
                                productDetails.description ?? '',
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                fontSize: 12,
                                color: Colors.black.withOpacity(0.5),
                              ),
                            ],
                          ),
                        ),
                        8.sSize,
                        Expanded(
                          flex: 2,
                          child: FancyShimmerImage(
                            imageUrl: productDetails.image ?? '',
                            height: 100,
                            // width: context.width - 32,
                            boxFit: BoxFit.contain,
                            errorWidget: Image.asset(
                              getPngAsset('product'),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  isDone ? 0.sSize : 32.sSize,
                  isDone
                      ? 0.sSize
                      : Consumer<CartProvider>(
                          builder: (context, cartProvider, _) {
                          return MainButton(
                            onPressed: cartProvider.addProductLoader && cartProvider.addProductId == productDetails.id
                                ? () {}
                                : () {
                                    cartProvider.addProduct(context,
                                        prizeId: productDetails.prizeId!,
                                      productId: productDetails.id!,
                                    );
                                  },
                            color: cartProvider.addProductLoader && cartProvider.addProductId == productDetails.id
                                ? AppColors.ySecondryColor
                                : AppColors.yPrimaryColor,
                            width: 150,
                            radius: 28,
                            child: MainText(
                              cartProvider.addProductLoader && cartProvider.addProductId == productDetails.id
                                  ? 'wait'.tr
                                  : 'add_cart'.tr,
                              fontSize: 15,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          );
                        }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
