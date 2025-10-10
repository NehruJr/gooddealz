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
      child: Column(
        children: [
          Container(
            height: 540,
            width: context.width,
            padding: const EdgeInsetsDirectional.only(start: 12, end: 12, top: 12, bottom: 9),
            margin: 16.vEdge,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: AppColors.yWhiteColor,
              boxShadow: [
                BoxShadow(
                  offset: const Offset(-2, 2),
                  color: AppColors.yBlackColor.withOpacity(0.5),
                  blurRadius: 5,
                  spreadRadius: 0,
                )
              ],
            ),
            child: Column(
              children: [
                Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  alignment: AlignmentDirectional.topStart,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "${productDetails.quantitySold!} ${'SOLD'.tr}",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                      const SizedBox(width: 6),
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            width: 70,
                            height: 10,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade300,
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          Container(
                            width: 70 * (productDetails.salesPercentage.toDoubleNum <= 100 ? productDetails.salesPercentage.toDoubleNum  : 100) / 100,
                            height: 10,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [
                                  Color(0xFFE91E63),
                                  Color(0xFFEF040D),
                                  Color(0xFFFF9800),
                                  Color(0xFFFFD54F),
                                  Color(0xFFFF9800),
                                  Color(0xFFEF040D),
                                  Color(0xFFE91E63),
                                ],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 6),
                      Text(
                        "${'OUT OF'.tr} ${productDetails.quantity}",
                        style: const TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ),
                8.sSize,
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    // boxShadow: [
                    //   BoxShadow(
                    //     offset: const Offset(-2, 2),
                    //     color: AppColors.yBlackColor.withOpacity(0.5),
                    //     blurRadius: 5,
                    //     spreadRadius: 0,
                    //   )
                    // ],
                  ),
                  clipBehavior: Clip.antiAlias,
                  width: context.width - 60,
                  height: 250,
                  child: Stack(
                    alignment: AlignmentDirectional.bottomStart,
                    children: [
                      FancyShimmerImage(
                        imageUrl: productDetails.prize!.image!,
                        boxFit: BoxFit.fill,
                        width: context.width - 60,
                        errorWidget: Image.asset(
                          getPngAsset('product'),
                          fit: BoxFit.cover,
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              AppColors.yBlackColor.withOpacity(0.0),
                              AppColors.yBlackColor.withOpacity(0.1),
                              AppColors.yBlackColor.withOpacity(0.3),
                              AppColors.yBlackColor.withOpacity(0.5),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: 8.aEdge,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ShaderMask(
                              shaderCallback: (bounds) => const LinearGradient(
                                colors: [Color(0xFFFFD54F), Color(0xFFFF9800), Color(0xFFEF040D), Color(0xFFE91E63)],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ).createShader(bounds),
                              child: Text(
                                  'win'.tr,
                                style: const TextStyle(
                                  fontSize: 55,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white,
                                  height: 1,
                                ),
                              ),
                            ),
                            Text(
                                productDetails.prize!.title!,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style: const TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                color: AppColors.yBGColor,
                                shadows: [
                                  Shadow(
                                      color: Colors.black54,
                                      offset: Offset(1, 1),
                                      blurRadius: 2)
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: 8.aEdge,
                        child: Align(
                          alignment: AlignmentDirectional.topEnd,
                          child: Consumer<ProductProvider>(
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
                              }),
                        ),
                      )
                    ],
                  ),
                ),
                8.sSize,
                Padding(
                  padding: const EdgeInsetsDirectional.only(start: 16.0, end: 4, top: 12.0, bottom: 12),
                  child: Row(
                    children: [
                      Expanded(
                        child: RichText(
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          text: TextSpan(
                            style: const TextStyle(color: AppColors.yBlackColor, fontSize: 20),
                            children: [
                              TextSpan(text: "${'Buy'.tr}: "),
                              TextSpan(
                                text: productDetails.title,
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              TextSpan(
                                text: " ${"for".tr} ",
                              ),
                              TextSpan(
                                text: "\$${productDetails.price}",
                                style: const TextStyle(
                                    color: AppColors.yPrimaryColor, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ),
                      6.sSize,
                      Container(
                        padding: 6.aEdge,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: AppColors.yBlackColor,
                            width: 0.5
                          )
                        ),
                        child: Container(
                          width: 70,
                          height: 70,
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: FancyShimmerImage(
                            imageUrl: productDetails.image ?? '',
                            boxFit: BoxFit.cover,
                            width: 70,
                            height: 70,
                            errorWidget: Image.asset(
                              getPngAsset('product'),
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                isDone
                    ? 0.sSize
                    : Consumer<CartProvider>(
                    builder: (context, cartProvider, _) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.only(top: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ).copyWith(
                            backgroundColor: MaterialStateProperty.all(Colors.transparent),
                            shadowColor: MaterialStateProperty.all(Colors.transparent),
                          ),
                          onPressed: cartProvider.addProductLoader && cartProvider.addProductId == productDetails.id
                              ? () {}
                              : () {
                            cartProvider.addProduct(context,
                              prizeId: productDetails.prizeId!,
                              productId: productDetails.id!,
                            );
                          },
                          child: Ink(
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFFFFD54F), Color(0xFFFF9800), Color(0xFFEF040D), Color(0xFFE91E63)],
                                begin: Alignment.centerRight,
                                end: Alignment.centerLeft,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Container(
                              alignment: Alignment.center,
                              height: 50,
                              child: Text(
                                cartProvider.addProductLoader && cartProvider.addProductId == productDetails.id
                                    ? 'wait'.tr
                                    : 'add_cart'.tr,
                                style: const TextStyle(fontSize: 20, color: AppColors.yBGColor),
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Center(
                    child: Text(
                      "Draw will take place once entries are filled.".tr,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}