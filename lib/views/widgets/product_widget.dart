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
          36.sSize,
          Container(
            height: 555,
            width: context.width,
            padding: 12.aEdge,
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
                        "${productDetails.quantitySold!} SOLD",
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
                              color: AppColors.yPrimaryColor,
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 6),
                      Text(
                        "OUT OF ${productDetails.quantity}",
                        style: TextStyle(fontSize: 12),
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
                      Image.network(
                        productDetails.prize!.image!,
                        fit: BoxFit.fill,
                        width: context.width - 60,
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
                                begin: Alignment.centerRight,
                                end: Alignment.centerLeft,
                              ).createShader(bounds),
                              child: Text(
                                  'win'.tr,
                                style: const TextStyle(
                                  fontSize: 65,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white,
                                  height: 1,
                                ),
                              ),
                            ),
                            Text(
                                productDetails.prize!.title!,
                              style: const TextStyle(
                                fontSize: 35,
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
                    ],
                  ),
                ),
                8.sSize,
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: RichText(
                          text: TextSpan(
                            style: TextStyle(color: AppColors.yBlackColor, fontSize: 22),
                            children: [
                              TextSpan(text: "Buy: "),
                              TextSpan(
                                text: productDetails.title,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              TextSpan(
                                text: " for ",
                              ),
                              TextSpan(
                                text: "\$${productDetails.price}",
                                style: TextStyle(
                                    color: AppColors.yPrimaryColor, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        padding: 8.aEdge,
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
                          child: Image(
                            image: NetworkImage(
                              productDetails.image ?? '',
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
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
                    onPressed: () {},
                    child: Ink(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
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
                          "Add to Cart",
                          style: TextStyle(fontSize: 20, color: AppColors.yBGColor),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          36.sSize,
          Container(
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
        ],
      ),
    );
  }
}


class GiveawayWidget extends StatelessWidget {
  const GiveawayWidget({
    super.key,
  this.isDone = false,
    this.isLive = false,
    required this.productDetails,});
  final bool isDone;
  final bool isLive;
  final ProductDetails productDetails;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          /// Progress + Image + Title
          Stack(
            children: [
              ClipRRect(
                borderRadius:
                const BorderRadius.vertical(top: Radius.circular(20)),
                child: Image.network(
                  productDetails.prize?.cover ?? '', // حط لينك الصورة اللي عندك
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),

              /// Progress Bar
              Positioned(
                top: 12,
                left: 12,
                child: Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        "285 SOLD",
                        style: TextStyle(
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
                            width: 70 * (285 / 1200),
                            height: 10,
                            decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 6),
                      const Text(
                        "OUT OF 1200",
                        style: TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ),

              /// Title
              Positioned(
                bottom: 16,
                left: 16,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      "Win",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.pink,
                      ),
                    ),
                    Text(
                      "Rolex Submariner \"Starbucks\"",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
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
            ],
          ),

          const SizedBox(height: 12),

          /// Buy Text
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                Expanded(
                  child: RichText(
                    text: const TextSpan(
                      style: TextStyle(color: Colors.black, fontSize: 16),
                      children: [
                        TextSpan(text: "Buy: "),
                        TextSpan(
                          text: "The Black Notebook Set ",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(
                          text: "for ",
                        ),
                        TextSpan(
                          text: "\$30.00",
                          style: TextStyle(
                              color: Colors.red, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: 40,
                  child: Image(
                    image: NetworkImage(
                      productDetails.prize?.cover ?? '',), // صورة النوت بوك
                  ),
                )
              ],
            ),
          ),

          const SizedBox(height: 20),

          /// Button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                // backgroundColor: const LinearGradient(
                //   colors: [Colors.blue, Colors.purple],
                // ).createShader(const Rect.fromLTWH(0, 0, 200, 50)),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ).copyWith(
                backgroundColor: MaterialStateProperty.all(Colors.transparent),
                shadowColor: MaterialStateProperty.all(Colors.transparent),
              ),
              onPressed: () {},
              child: Ink(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Colors.blue, Colors.purple],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Container(
                  alignment: Alignment.center,
                  height: 50,
                  child: const Text(
                    "Add to Cart",
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 12),

          /// Draw Date
          const Padding(
            padding: EdgeInsets.only(bottom: 16),
            child: Center(
              child: Text(
                "Draw Date: 20 November, 2025 or earlier based on the time passed.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
