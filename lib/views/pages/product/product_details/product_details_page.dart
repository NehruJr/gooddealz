import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:goodealz/core/constants/app_colors.dart';
import 'package:goodealz/core/helper/extensions/assetss_widgets.dart';
import 'package:goodealz/core/helper/extensions/context_size.dart';
import 'package:goodealz/core/helper/extensions/string_to_from.dart';
import 'package:goodealz/core/helper/functions/date_converter.dart';
import 'package:goodealz/core/helper/functions/get_asset.dart';
import 'package:goodealz/core/ys_localizations/ys_localizations.dart';
import 'package:goodealz/data/models/product_model.dart';
import 'package:goodealz/views/widgets/main_button.dart';
import 'package:goodealz/views/widgets/main_page.dart';
import 'package:goodealz/views/widgets/main_text.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:slide_countdown/slide_countdown.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/helper/functions/navigation_service.dart';
import '../../../../core/ys_localizations/ys_localizations_provider.dart';
import '../../../../providers/cart/cart_provider.dart';
import '../../../../providers/product/product_provider.dart';
import '../../../widgets/carousal_widget.dart';
import '../../../widgets/sales_progress.dart';

class ProductDetailsPage extends StatefulWidget {
  const ProductDetailsPage({super.key, required this.productDetails});

  final ProductDetails productDetails;

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  int status = 0;

  bool showMore = false;

  final List<String> _productImages = [];

  @override
  void initState() {
    super.initState();

    if(widget.productDetails.productImages != null) {
      _productImages.addAll(widget.productDetails.productImages!) ;
      _productImages.add(widget.productDetails.image??'') ;
    }
  }

  @override
  Widget build(BuildContext context) {
    print('widget.productDetails.productImages');
    print(widget.productDetails.productImages);
    final date = DateTime.tryParse(widget.productDetails.withdrawalStartTime ?? '')
        ?.difference(DateTime.now());
    final drawDate = DateTime.tryParse(widget.productDetails.withdrawalStartTime ?? '')?.
    add(Duration(days: widget.productDetails.withdrawalStartDays??0));
        print(drawDate);

    return MainPage(
      appBarHeight: 125,
      titleWidget: widget.productDetails.salesPercentage != "100" && date == null || date!.isNegative
          ? SalesProgress(
        sold: widget.productDetails.quantitySold ?? 0,
        total: widget.productDetails.quantity ?? 0,
      )
          : Column(
              children: [
               if(!date.isNegative) Text('Winner_announced'.tr),
                const SizedBox(
                  height: 5,
                ),
                Directionality(
            textDirection: TextDirection.ltr,
                  child: SlideCountdownSeparated(
                    duration: date,
                    style: const TextStyle(color: Colors.black),
                    decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.red,
                        ),
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(7)),
                  ),
                ),
              ],
            ),
      actionWidgets: [
        Consumer<ProductProvider>(builder: (context, productProvider, _) {
          return productProvider.toggleLoader &&
                  productProvider.toggleId == widget.productDetails.id
              ? const SizedBox(width: 30, child: CircularProgressIndicator())
              : InkWell(
                  onTap: () {
                    productProvider.toggleFavorite(context, widget.productDetails);
                  },
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    child: SvgPicture.asset(
                      productProvider.isInFavorite(widget.productDetails)
                          ? getSvgAsset('Heart')
                          : getSvgAsset('Heart-selected'),
                      height: 22,
                    ),
                  ),
                );
        })
      ],
      body: Stack(
        children: [
          ClipRRect(
            // borderRadius: const BorderRadius.only(
            //   topLeft: Radius.circular(45),
            //   topRight: Radius.circular(45),
            // ),
            child: FancyShimmerImage(
              imageUrl: widget.productDetails.prize?.cover ?? '',
              width: context.width,
              height: context.width,
              boxFit: BoxFit.cover,
              errorWidget: Image.asset(
                getPngAsset('product'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            width: context.width,
            height: context.width,
            decoration: BoxDecoration(
              borderRadius: 22.cBorder,
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
            child: Padding(
              padding: 8.aEdge,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
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
                    widget.productDetails.prize?.title ?? '',
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
                  8.sSize
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: 24.hvEdge,
              height: context.height - context.width - 30,
              width: context.width,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(45),
                  topRight: Radius.circular(45),
                ),
              ),
              child: Column(
                children: [
                  Expanded(
                    child: ListView(
                      padding: 16.vEdge,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: MainText(
                                widget.productDetails.title ?? '',
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                                fontSize: 20,
                                color: AppColors.yBlackColor,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            16.sSize,
                            Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Row(
                                children: [
                                  MainText(
                                    YsLocalizationsProvider.listenFalse(NavigationService.currentContext)
                                        .languageCode == 'en' ? '${widget.productDetails.price ?? ''} ' : '${widget.productDetails.currency ?? ''} ',
                                    fontSize: 16,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w700,
                                  ),
                                  MainText(
                                    YsLocalizationsProvider.listenFalse(NavigationService.currentContext)
                                        .languageCode == 'en' ?  widget.productDetails.currency ?? '' : widget.productDetails.price ?? '' ,
                                    fontSize: 16,
                                    color: AppColors.ySecondry2Color,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        // 8.sSize,
                        // Row(
                        //   children: [
                        //     MainText(
                        //       'by ',
                        //       overflow: TextOverflow.ellipsis,
                        //       fontSize: 12,
                        //       color: Colors.black.withOpacity(0.4),
                        //     ),
                        //     const MainText(
                        //       'James Ruth',
                        //       fontSize: 12,
                        //       color: AppColors.yPrimaryColor,
                        //     ),
                        //   ],
                        // ),
                        24.sSize,
                        SizedBox(
                          width: context.width - 32,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              MainText(
                                'description'.tr,
                                overflow: TextOverflow.ellipsis,
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Colors.black.withOpacity(0.7),
                              ),
                              8.sSize,
                              if(widget.productDetails.description != null)
                              MainText(
                                widget.productDetails.description ?? '',
                                maxLines: widget.productDetails.description!.length > AppConstants.descriptionMaxLength && !showMore ? 3 : null,
                                overflow: widget.productDetails.description!.length > AppConstants.descriptionMaxLength && !showMore ? TextOverflow.ellipsis : null,
                                fontSize: 14,
                                color: Colors.black.withOpacity(0.5),
                              ),
                              2.sSize,
                              if(widget.productDetails.description != null && widget.productDetails.description!.length > AppConstants.descriptionMaxLength)
                            GestureDetector(

                              onTap: (){
                                  showMore = !showMore;
                                  setState(() {});
                                },
                                child: MainText(
                                  showMore ? 'show_less'.tr : 'show_more'.tr,

                                  fontSize: 12,
                                  color: AppColors.ySecondry2Color,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsetsDirectional.only(start: 8.0, end: 4, top: 24.0, bottom: 18),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      widget.productDetails.title ?? '',
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(color: AppColors.yBlackColor, fontSize: 20, fontWeight: FontWeight.bold),
                                    ),
                                    8.sSize,
                                    if(widget.productDetails.withdrawalStartTime != null) MainText(
                                      '${'draw_date'.tr} ${DateConverter.containTAndZToUTCFormat(drawDate.toString())}.',
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                      fontSize: 12,
                                      color: Colors.black.withOpacity(0.5),
                                    ),
                                  ],
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
                                  width: 100,
                                  height: 90,
                                  clipBehavior: Clip.antiAlias,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: CarousalWidget(images: _productImages,),
                                ),
                              )
                            ],
                          ),
                        ),

                        if(widget.productDetails.prize?.winner != null )
                        MainText(
                          'winner'.tr,
                          fontSize: 18,
                          color: Colors.black,
                          fontWeight: FontWeight.w700,
                        ),

                        if(widget.productDetails.prize?.winner != null )
                          Card(
                            surfaceTintColor: Colors.white,
                            elevation: 3,
                            child: ListTile(
                              minVerticalPadding: 16,
                              leading: CircleAvatar(
                                child: FancyShimmerImage(
                                  imageUrl: widget.productDetails.prize?.winner!.avatar??'',
                                  // height: size.width * 0.21,
                                  // width: size.width * 0.2,
                                  boxFit: BoxFit.fill,
                                  errorWidget: Image.asset(
                                    getPngAsset('person'),
                                  ),
                                ),
                              ),
                              title: MainText(
                                '${widget.productDetails.prize?.winner!.lastName} ${widget.productDetails.prize?.winner!.lastName}',
                                overflow: TextOverflow.ellipsis,
                                fontSize: 16,
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                              ),
                              subtitle: MainText(
                                '${'winner'.tr} : # ${widget.productDetails.prize?.winner!.id}',
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                                fontSize: 14,
                                color: Colors.black.withOpacity(0.6),
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          )
                      ],
                    ),
                  ),
                  12.sSize,
                  widget.productDetails.quantity != widget.productDetails.quantitySold
                      ? Consumer<CartProvider>(
                      builder: (context, cartProvider, _) {
                        return MainButton(
                          onPressed: cartProvider.addProductLoader &&
                              cartProvider.addProductId ==
                                  widget.productDetails.prizeId
                              ? () {}
                              : () {
                            cartProvider.addProduct(context,
                              prizeId: widget.productDetails.prizeId!,
                              productId: widget.productDetails.id!,
                            );
                          },
                          color: cartProvider.addProductLoader
                              ? AppColors.ySecondryColor
                              : AppColors.yPrimaryColor,
                          child: MainText(
                            cartProvider.addProductLoader
                                ? 'wait'.tr
                                : 'add_cart'.tr,
                            fontSize: 15,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        );
                      })
                      : 0.sSize,
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
