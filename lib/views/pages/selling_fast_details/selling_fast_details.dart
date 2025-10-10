import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:goodealz/core/constants/app_colors.dart';
import 'package:goodealz/core/helper/extensions/assetss_widgets.dart';
import 'package:goodealz/core/helper/extensions/context_size.dart';
import 'package:goodealz/core/helper/functions/get_asset.dart';
import 'package:goodealz/core/ys_localizations/ys_localizations.dart';
import 'package:goodealz/data/models/product_model.dart';
import 'package:goodealz/views/widgets/main_button.dart';
import 'package:goodealz/views/widgets/main_page.dart';
import 'package:goodealz/views/widgets/main_text.dart';

import '../../../../core/ys_localizations/ys_localizations_provider.dart';
import '../../../../providers/cart/cart_provider.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/app_routes.dart';
import '../../../providers/prizes/prizes_provider.dart';
import '../product/product_details/product_details_page.dart';

class SellingFastDetailsPage extends StatefulWidget {
  SellingFastDetailsPage({super.key, required this.prizeSlug});

  String prizeSlug;

  @override
  State<SellingFastDetailsPage> createState() => _SellingFastDetailsPageState();
}

class _SellingFastDetailsPageState extends State<SellingFastDetailsPage> {
  int status = 0;
  bool showMore = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<PrizesProvider>(context, listen: false)
          .getPrizeDetails(context, widget.prizeSlug);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MainPage(
      body: Consumer<PrizesProvider>(builder: (context, prizesProvider, _) {
        final prizeDetails = prizesProvider.prizeDetails;
        if (prizesProvider.sellingDetailsLoader) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return Stack(
            alignment: Alignment.topCenter,
            children: [
              ClipRRect(
                // borderRadius: const BorderRadius.only(
                //   topLeft: Radius.circular(45),
                //   topRight: Radius.circular(45),
                // ),
                child: FancyShimmerImage(
                  imageUrl: prizeDetails?.cover ?? '',
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
                            fontSize: 55,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            height: 1,
                          ),
                        ),
                      ),
                      Text(
                        prizeDetails?.title ?? '',
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
                      8.sSize,
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  padding: 32.hvEdge,
                  height: context.height - context.width,
                  width: context.width,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(45),
                      topRight: Radius.circular(45),
                    ),
                  ),
                  child: ListView(
                    children: [
                      16.sSize,
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
                            if (prizeDetails?.description != null)
                              MainText(
                                prizeDetails?.description ?? '',
                                maxLines: prizeDetails!.description!.length >
                                            AppConstants.descriptionMaxLength &&
                                        !showMore
                                    ? 3
                                    : null,
                                overflow: prizeDetails.description!.length >
                                            AppConstants.descriptionMaxLength &&
                                        !showMore
                                    ? TextOverflow.ellipsis
                                    : null,
                                fontSize: 14,
                                color: Colors.black.withOpacity(0.5),
                              ),
                            2.sSize,
                            if (prizeDetails?.description != null &&
                                prizeDetails!.description!.length >
                                    AppConstants.descriptionMaxLength)
                              GestureDetector(
                                onTap: () {
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
                      32.sSize,

                      SizedBox(
                        height: 240,
                        child: ListView.separated(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          // physics: const NeverScrollableScrollPhysics(),
                          separatorBuilder: (context, index) => const SizedBox(
                            width: 5,
                          ),
                          itemCount: prizeDetails?.products?.length ?? 0,
                          itemBuilder: (context, index) {
                            return productPrizeWidget(context,
                                productDetails: prizeDetails!.products![index]);
                          },
                        ),
                      ),
                      if (prizeDetails!.tags!.isNotEmpty) 8.sSize,
                      if (prizeDetails.tags!.isNotEmpty)
                        MainText(
                          'tags'.tr,
                          overflow: TextOverflow.ellipsis,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.black.withOpacity(0.7),
                        ),
                      8.sSize,
                      SizedBox(
                        height: 100,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: prizeDetails.tags?.length ?? 0,
                          separatorBuilder: (context, index) => const SizedBox(
                            width: 20,
                          ),
                          itemBuilder: (context, index) => FancyShimmerImage(
                            imageUrl: prizeDetails.tags?[index].image ?? '',
                            width: 100,
                            height: context.width,
                            boxFit: BoxFit.contain,
                            errorWidget: Image.asset(
                              getPngAsset('product'),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),

                      // 32.sSize,
                    ],
                  ),
                ),
              ),
            ],
          );
        }
      }),
    );
  }

  Widget productPrizeWidget(context, {required ProductDetails productDetails}) {
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
        child: SizedBox(
          height: 240,
          width: 300,
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: 22.cBorder,
                child: FancyShimmerImage(
                  imageUrl: productDetails.image ?? '',
                  height: 240,
                  // width: 100 - 32,
                  boxFit: BoxFit.contain,
                  errorWidget: Image.asset(
                    getPngAsset('product'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: 22.cBorder,
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      AppColors.yBlackColor.withOpacity(0.0),
                      AppColors.yBlackColor.withOpacity(0.1),
                      AppColors.yBlackColor.withOpacity(0.4),
                      AppColors.yBlackColor.withOpacity(0.6),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: 24.aEdge,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 3,
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.3,
                            child: MainText(
                              productDetails.title ?? '',
                              fontSize: 18,
                              color: AppColors.yBGColor,
                              fontWeight: FontWeight.w700,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        MainText(
                          '${productDetails.price ?? ''} ${productDetails.currency ?? ''}',
                          fontSize: 16,
                          color: AppColors.yBGColor,
                          fontWeight: FontWeight.w400,
                        ),
                      ],
                    ),
                    Consumer<CartProvider>(builder: (context, cartProvider, _) {
                      if (productDetails.salesPercentage != "100") {
                        return MainButton(
                          onPressed: cartProvider.addProductLoader &&
                                  cartProvider.addProductId == productDetails.id
                              ? () {}
                              : () {
                                  cartProvider.addProduct(
                                    context,
                                    prizeId: productDetails.prizeId!,
                                    productId: productDetails.id!,
                                  );
                                },
                          color: cartProvider.addProductLoader &&
                                  cartProvider.addProductId == productDetails.id
                              ? AppColors.ySecondryColor
                              : AppColors.yPrimaryColor,
                          width: 150,
                          radius: 28,
                          child: MainText(
                            cartProvider.addProductLoader &&
                                    cartProvider.addProductId ==
                                        productDetails.id
                                ? 'wait'.tr
                                : 'add_cart'.tr,
                            fontSize: 16,
                            color: AppColors.yBGColor,
                            fontWeight: FontWeight.w500,
                          ),
                        );
                      } else {
                        return MainButton(
                          onPressed: () {},
                          color: AppColors.yGreyColor,
                          width: 150,
                          radius: 28,
                          child: MainText(
                            'sold_out'.tr,
                            fontSize: 15,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        );
                      }
                    }),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
