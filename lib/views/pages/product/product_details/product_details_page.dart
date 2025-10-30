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
  bool showMore = false;
  final List<String> _productImages = [];

  @override
  void initState() {
    super.initState();
    if (widget.productDetails.productImages != null) {
      _productImages.addAll(widget.productDetails.productImages!);
      _productImages.add(widget.productDetails.image ?? '');
    }
  }

  @override
  Widget build(BuildContext context) {
    final date =
        DateTime.tryParse(widget.productDetails.withdrawalStartTime ?? '')
            ?.difference(DateTime.now());
    final drawDate =
        DateTime.tryParse(widget.productDetails.withdrawalStartTime ?? '')?.add(
            Duration(days: widget.productDetails.withdrawalStartDays ?? 0));

    final isSoldOut =
        widget.productDetails.quantity == widget.productDetails.quantitySold;
    final isDrawActive = widget.productDetails.salesPercentage != "100" &&
        date != null &&
        !date.isNegative;

    return Scaffold(
      backgroundColor: AppColors.yBGColor,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: context.width * 0.8,
            pinned: true,
            floating: false,
            elevation: 0,
            backgroundColor: AppColors.yPrimaryColor.withAlpha(5),
            leading: Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 8,
                    spreadRadius: 0,
                  )
                ],
              ),
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            centerTitle: true,
            // title: Container(
            //   width: 130,
            //   height: 56,
            //   decoration: BoxDecoration(
            //       color: AppColors.yWhiteColor.withAlpha(160),
            //       borderRadius: BorderRadius.circular(30)),
            //   child: SalesProgress(
            //     sold: widget.productDetails.quantitySold ?? 0,
            //     total: widget.productDetails.quantity ?? 0,
            //   ),
            // ),
            actions: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Consumer<ProductProvider>(
                  builder: (context, productProvider, _) {
                    return Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              blurRadius: 8,
                              spreadRadius: 0,
                            )
                          ],
                        ),
                        child: productProvider.toggleLoader &&
                                productProvider.toggleId ==
                                    widget.productDetails.id
                            ? const Padding(
                                padding: EdgeInsets.all(12.0),
                                child: SizedBox(
                                  width: 24,
                                  height: 24,
                                  child:
                                      CircularProgressIndicator(strokeWidth: 2),
                                ),
                              )
                            : IconButton(
                                onPressed: () {
                                  productProvider.toggleFavorite(
                                      context, widget.productDetails);
                                },
                                icon: SvgPicture.asset(
                                  productProvider
                                          .isInFavorite(widget.productDetails)
                                      ? getSvgAsset('Heart')
                                      : getSvgAsset('Heart-selected'),
                                  width: 24,
                                ),
                              ));
                  },
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                children: [
                  FancyShimmerImage(
                    imageUrl: widget.productDetails.prize?.cover ?? '',
                    width: context.width,
                    height: context.width * 0.9,
                    boxFit: BoxFit.cover,
                    errorWidget: Image.asset(
                      getPngAsset('product'),
                      fit: BoxFit.cover,
                    ),
                  ),
                  Container(
                    width: context.width,
                    height: context.width * 0.9,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.transparent,
                          AppColors.yBlackColor.withValues(alpha: 0.4),
                          AppColors.yBlackColor.withValues(alpha: 0.7),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 16,
                    left: 16,
                    right: 16,
                    child: Column(
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
                              height: 0.9,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        MainText(
                          widget.productDetails.prize?.title ?? '',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                  // if (!isSoldOut &&
                  //     widget.productDetails.salesPercentage != "100")
                  //   Positioned(
                  //     top: 16,
                  //     right: 16,
                  //     child: Container(
                  //       padding: const EdgeInsets.symmetric(
                  //         horizontal: 12,
                  //         vertical: 8,
                  //       ),
                  //       decoration: BoxDecoration(
                  //         color: Colors.black.withValues(alpha: .7),
                  //         borderRadius: BorderRadius.circular(24),
                  //         border: Border.all(
                  //           color: Colors.white.withAlpha(3),
                  //         ),
                  //       ),
                  //       child: MainText(
                  //         '${widget.productDetails.salesPercentage}% ${'sold'.tr}',
                  //         fontSize: 12,
                  //         fontWeight: FontWeight.w600,
                  //         color: Colors.white,
                  //       ),
                  //     ),
                  //   ),
                ],
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Container(
              width: context.width,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(5),
                    blurRadius: 4,
                  ),
                ],
              ),
              child: widget.productDetails.salesPercentage != "100" &&
                      (date == null || (date.isNegative))
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        MainText(
                          'offers_sold'.tr,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.black.withAlpha(70),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            MainText(
                              '${widget.productDetails.quantitySold}/${widget.productDetails.quantity} ${'sold'.tr}',
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Colors.black..withValues(alpha: 0.5),
                            ),
                            MainText(
                              '${widget.productDetails.salesPercentage}% ${'complete'.tr}',
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppColors.yPrimaryColor,
                            ),
                          ],
                        ),
                      ],
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (date != null && !date.isNegative)
                          MainText(
                            'Winner_announced'.tr,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        if (date != null && !date.isNegative)
                          const SizedBox(height: 12),
                        if (date != null && !date.isNegative)
                          Directionality(
                            textDirection: TextDirection.ltr,
                            child: SlideCountdownSeparated(
                              duration: date,
                              style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: AppColors.yPrimaryColor,
                                  width: 2,
                                ),
                                color: Colors.transparent,
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                      ],
                    ),
            ),
          ),
       
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 3,
                        child: MainText(
                          widget.productDetails.title ?? '',
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 2,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.yPrimaryColor
                              ..withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color:
                                  AppColors.yPrimaryColor.withValues(alpha: 0.3),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              FittedBox(
                                child: Row(
                                  children: [
                                    MainText(
                                      YsLocalizationsProvider.listenFalse(
                                                      NavigationService
                                                          .currentContext)
                                                  .languageCode ==
                                              'en'
                                          ? widget.productDetails.price ?? ''
                                          : widget.productDetails.currency ?? '',
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.yWhiteColor,
                                    ),
                                    const SizedBox(width: 4),
                                    MainText(
                                      YsLocalizationsProvider.listenFalse(
                                                      NavigationService
                                                          .currentContext)
                                                  .languageCode ==
                                              'en'
                                          ? widget.productDetails.currency ?? ''
                                          : widget.productDetails.price ?? '',
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  MainText(
                    'description'.tr,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Colors.black..withValues(alpha: 0.8),
                  ),
                  const SizedBox(height: 8),
                  if (widget.productDetails.description != null)
                    Container(
                      width: MediaQuery.sizeOf(context).width,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Colors.grey[200]!,
                        ),
                      ),
                      child: MainText(
                        widget.productDetails.description ?? '',
                        maxLines: !showMore &&
                                widget.productDetails.description!.length >
                                    AppConstants.descriptionMaxLength
                            ? 3
                            : null,
                        overflow: !showMore &&
                                widget.productDetails.description!.length >
                                    AppConstants.descriptionMaxLength
                            ? TextOverflow.ellipsis
                            : null,
                        fontSize: 13,
                        color: Colors.black.withValues(alpha: 0.6),
                      ),
                    ),
                  if (widget.productDetails.description != null &&
                      widget.productDetails.description!.length >
                          AppConstants.descriptionMaxLength)
                    GestureDetector(
                      onTap: () {
                        setState(() => showMore = !showMore);
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(top: 12),
                        child: MainText(
                          showMore ? 'show_less'.tr : 'show_more'.tr,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.ySecondry2Color,
                        ),
                      ),
                    ),
                  const SizedBox(height: 24),
    
                  if (isDrawActive)
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppColors.yPrimaryColor.withValues(alpha: 0.1),
                            AppColors.ySecondry2Color.withValues(alpha: 0.05),
                          ],
                        ),
                        border: Border.all(
                          color: AppColors.yPrimaryColor.withValues(alpha: 0.3),
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: AppColors.yPrimaryColor
                                      .withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: const Icon(
                                  Icons.calendar_today,
                                  size: 16,
                                  color: AppColors.yPrimaryColor,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: MainText(
                                  widget.productDetails.title ?? '',
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          if (drawDate != null)
                            MainText(
                              '${'draw_date'.tr} ${DateConverter.containTAndZToUTCFormat(drawDate.toString())}',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              fontSize: 12,
                              color: Colors.black.withValues(alpha: 0.6),
                            ),
                        ],
                      ),
                    ),
                  const SizedBox(height: 24),
      
                  if (_productImages.isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        MainText(
                          'product_images'.tr,
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Colors.black.withValues(alpha: 0.8),
                        ),
                        const SizedBox(height: 12),
                        Center(
                          child: Container(
                            height: 140,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.grey[300]!,
                              ),
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.05),
                                  blurRadius: 4,
                                ),
                              ],
                            ),
                            child: CarousalWidget(images: _productImages),
                          ),
                        ),
                      ],
                    ),
                  const SizedBox(height: 24),
    
                  if (widget.productDetails.prize?.winner != null) ...[
                    MainText(
                      'winner'.tr,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                    const SizedBox(height: 12),
                    Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          gradient: LinearGradient(
                            colors: [
                              Colors.white,
                              Colors.grey[50]!,
                            ],
                          ),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(12),
                          leading: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: AppColors.yPrimaryColor,
                                width: 2,
                              ),
                            ),
                            child: CircleAvatar(
                              radius: 28,
                              child: FancyShimmerImage(
                                imageUrl: widget
                                        .productDetails.prize?.winner?.avatar ??
                                    '',
                                boxFit: BoxFit.cover,
                                errorWidget: Image.asset(
                                  getPngAsset('person'),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          title: MainText(
                            '${widget.productDetails.prize?.winner?.firstName} ${widget.productDetails.prize?.winner?.lastName}',
                            overflow: TextOverflow.ellipsis,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                          subtitle: MainText(
                            '${'winner'.tr}: #${widget.productDetails.prize?.winner?.id}',
                            overflow: TextOverflow.ellipsis,
                            fontSize: 12,
                            color: Colors.black.withValues(alpha: 0.5),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
       
                  if (!isSoldOut)
                    Consumer<CartProvider>(
                      builder: (context, cartProvider, _) {
                        return MainButton(
                          onPressed: cartProvider.addProductLoader &&
                                  cartProvider.addProductId ==
                                      widget.productDetails.prizeId
                              ? () {}
                              : () {
                                  cartProvider.addProduct(
                                    context,
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
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        );
                      },
                    )
                  else
                    Container(
                      width: context.width,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: MainText(
                          'sold_out'.tr,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Colors.black.withValues(alpha: 0.5),
                        ),
                      ),
                    ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
