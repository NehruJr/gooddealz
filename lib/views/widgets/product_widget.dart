import 'dart:io';

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
import 'package:goodealz/views/widgets/sales_progress.dart';
import 'package:path_provider/path_provider.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

import '../../providers/cart/cart_provider.dart';

class ProductWidget extends StatefulWidget {
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
  State<ProductWidget> createState() => _ProductWidgetState();
}

class _ProductWidgetState extends State<ProductWidget> {
  final ScreenshotController screenshotController = ScreenshotController();

  bool _isSharing = false;

  Future<void> _shareCard(BuildContext context) async {
    try {
      setState(() => _isSharing = true); // 👈 اخفي الزر مؤقتًا

      // خُد لقطة بدون الزرار
      final image = await screenshotController.capture();
      if (image == null) {
        setState(() => _isSharing = false);
        return;
      }

      final directory = await getTemporaryDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final imagePath = '${directory.path}/shared_card_$timestamp.png';
      final file = File(imagePath);
      await file.writeAsBytes(image);

      final isArabic =
          YsLocalizationsProvider.listenFalse(context).languageCode == 'ar';

      final productName = widget.productDetails.title ?? '';
      final prizeName = widget.productDetails.prize?.title ?? '';
      final price = double.tryParse(widget.productDetails.price.toString())?.toStringAsFixed(2) ?? '0.00';
      final remaining = (widget.productDetails.quantity ?? 0) -
          (widget.productDetails.quantitySold ?? 0);

      final message = isArabic
          ? '🛍️ من تطبيق جود ديلز! اشتري "$productName" بسعر $price ج.م فقط للحصول على فرصة للفوز بـ "$prizeName" 🎁 الكمية المتبقية: $remaining 🎯 اكتشف المزيد على تطبيق جود ديلز!'
          : '🛍️ From GooDealz App! Buy "$productName" for just \$${price} to get a chance to win "$prizeName" 🎁 Remaining quantity: $remaining 🎯 Discover more on GooDealz!';

      await Future.delayed(const Duration(milliseconds: 300));

      await Share.shareXFiles([XFile(imagePath)], text: message);

    } catch (e) {
      debugPrint('Error sharing card: $e');
    } finally {
      setState(() => _isSharing = false); // 👈 رجع الزر بعد المشاركة
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        AppRoutes.routeTo(
            context,
            ProductDetailsPage(
              productDetails: widget.productDetails,
            ));
      },
      child: Screenshot(
        controller: screenshotController,
        child: Column(
          children: [
            Container(
              height: 575,
              width: context.width,
              padding: const EdgeInsetsDirectional.only(top: 12, bottom: 9),
              margin: 16.vEdge,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(52),
                color: AppColors.yWhiteColor,
                boxShadow: [
                  BoxShadow(
                    offset: const Offset(-2, 2),
                    color: AppColors.yBlackColor.withOpacity(0.2),
                    blurRadius: 5,
                    spreadRadius: 0,
                  )
                ],
              ),
              child: Column(
                children: [
                  Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: Padding(
                      padding:
                          const EdgeInsetsDirectional.only(start: 24, end: 24, top: 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SalesProgress(
                            sold: widget.productDetails.quantitySold ?? 0,
                            total: widget.productDetails.quantity ?? 0,
                          ),

                          if (!_isSharing)
                          IconButton(
                            onPressed: () async => await _shareCard(context),
                            padding: EdgeInsets.zero,
                            icon: const Icon(
                              Icons.share_rounded,
                              color: AppColors.yDarkColor,
                              size: 30,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  4.sSize,
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(40),

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
                    width: context.width,
                    height: 250,
                    child: Stack(
                      alignment: AlignmentDirectional.bottomStart,
                      children: [
                        FancyShimmerImage(
                          boxDecoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(40),
                          ),
                          imageUrl: widget.productDetails.prize!.image!,
                          boxFit: BoxFit.fill,
                          width: context.width,
                          errorWidget: Image.asset(
                            getPngAsset('product'),
                            fit: BoxFit.cover,
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(40),
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
                          padding: 12.aEdge,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ShaderMask(
                                shaderCallback: (bounds) => const LinearGradient(
                                  colors: [
                                    Color(0xFFFFD54F),
                                    Color(0xFFFF9800),
                                    Color(0xFFEF040D),
                                    Color(0xFFE91E63)
                                  ],
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                ).createShader(bounds),
                                child: Text(
                                  'win'.tr,
                                  style: const TextStyle(
                                    fontSize: 48,
                                    fontWeight: FontWeight.w900,
                                    color: Colors.white,
                                    height: 1,
                                  ),
                                ),
                              ),
                              Text(
                                widget.productDetails.prize!.title!,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                                style: const TextStyle(
                                  fontSize: 24,
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
                        if (!_isSharing)
                        Padding(
                          padding: 8.aEdge,
                          child: Align(
                            alignment: AlignmentDirectional.topEnd,
                            child: Consumer<ProductProvider>(
                                builder: (context, productProvider, _) {
                              return productProvider.toggleLoader &&
                                      productProvider.toggleId ==
                                          widget.productDetails.id
                                  ? const SizedBox(
                                      width: 30,
                                      child: CircularProgressIndicator())
                                  : InkWell(
                                      onTap: () {
                                        productProvider.toggleFavorite(
                                            context, widget.productDetails);
                                      },
                                      child: CircleAvatar(
                                        backgroundColor: Colors.white,
                                        child: SvgPicture.asset(
                                          productProvider
                                                  .isInFavorite(widget.productDetails)
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
                    padding: const EdgeInsetsDirectional.only(
                        start: 16.0, end: 4, top: 12.0, bottom: 12),
                    child: Row(
                      children: [
                        Expanded(
                          child: RichText(
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            text: TextSpan(
                              style: const TextStyle(
                                  color: AppColors.yBlackColor, fontSize: 20),
                              children: [
                                TextSpan(text: "${'Buy'.tr}: "),
                                TextSpan(
                                  text: widget.productDetails.title,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                                TextSpan(
                                  text: " ${"for".tr} ",
                                ),
                                TextSpan(
                                  text: "\$${widget.productDetails.price}",
                                  style: const TextStyle(
                                      color: AppColors.yPrimaryColor,
                                      fontWeight: FontWeight.bold),
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
                                  color: AppColors.yBlackColor, width: 0.5)),
                          child: Container(
                            width: 70,
                            height: 70,
                            clipBehavior: Clip.antiAlias,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: FancyShimmerImage(
                              imageUrl: widget.productDetails.image ?? '',
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
                  widget.isDone
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
                                backgroundColor:
                                    MaterialStateProperty.all(Colors.transparent),
                                shadowColor:
                                    MaterialStateProperty.all(Colors.transparent),
                              ),
                              onPressed: cartProvider.addProductLoader &&
                                      cartProvider.addProductId ==
                                          widget.productDetails.id
                                  ? () {}
                                  : () {
                                      cartProvider.addProduct(
                                        context,
                                        prizeId: widget.productDetails.prizeId!,
                                        productId: widget.productDetails.id!,
                                      );
                                    },
                              child: Ink(
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color(0xFFFFD54F),
                                      Color(0xFFFF9800),
                                      Color(0xFFEF040D),
                                      Color(0xFFE91E63)
                                    ],
                                    begin: Alignment.centerRight,
                                    end: Alignment.centerLeft,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Container(
                                  alignment: Alignment.center,
                                  height: 50,
                                  child: Text(
                                    cartProvider.addProductLoader &&
                                            cartProvider.addProductId ==
                                                widget.productDetails.id
                                        ? 'wait'.tr
                                        : 'add_cart'.tr,
                                    style: const TextStyle(
                                        fontSize: 20, color: AppColors.yBGColor),
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
      ),
    );
  }
}
