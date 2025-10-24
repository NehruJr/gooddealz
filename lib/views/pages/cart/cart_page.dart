import 'package:flutter/material.dart';
import 'package:goodealz/core/constants/app_colors.dart';
import 'package:goodealz/core/constants/app_routes.dart';
import 'package:goodealz/core/helper/extensions/assetss_widgets.dart';
import 'package:goodealz/core/helper/extensions/context_size.dart';
import 'package:goodealz/core/ys_localizations/ys_localizations.dart';
import 'package:goodealz/providers/cart/cart_provider.dart';
import 'package:goodealz/views/pages/cart/widgets/cart_item_card.dart';
import 'package:goodealz/views/pages/checkout/checkout_page.dart';
import 'package:goodealz/views/widgets/main_page.dart';
import 'package:goodealz/views/widgets/main_text.dart';
import '../../../core/ys_localizations/ys_localizations_provider.dart';
import '../../../providers/discount/discount_provider.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final _couponController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<CartProvider>(context, listen: false)
          .getCartProducts(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MainPage(
      isAppBar: false,
      subAppBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: SafeArea(
          child: Container(
            width: context.width,
            decoration: const BoxDecoration(
                color: AppColors.yWhiteColor,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                )),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: MainText(
              'my_cart'.tr,
              fontSize: 24,
              color: AppColors.yBlackColor,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
      bottomNavigationBarIndex: 2,
      body: Consumer<CartProvider>(
        builder: (context, cartProvider, _) {
          if (cartProvider.cartLoader) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(
                    color: AppColors.yPrimaryColor,
                    strokeWidth: 3,
                  ),
                  16.sSize,
                  MainText(
                    'loading_cart'.tr,
                    fontSize: 16,
                    color: AppColors.yGreyColor,
                  ),
                ],
              ),
            );
          } else if (cartProvider.carts.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(40),
                    decoration: const BoxDecoration(
                      color: AppColors.yLightGreyColor,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.shopping_cart_outlined,
                      size: 80,
                      color: AppColors.yGreyColor.withValues(alpha: .5),
                    ),
                  ),
                  24.sSize,
                  MainText(
                    'empty_cart'.tr,
                    fontSize: 22,
                    color: AppColors.yBlackColor,
                    fontWeight: FontWeight.w700,
                  ),
                  8.sSize,
                  MainText(
                    'empty_cart_message'.tr,
                    fontSize: 14,
                    color: AppColors.yGreyColor,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          return Stack(
            children: [
              Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: const EdgeInsets.all(20),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 8),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    controller: _couponController,
                                    decoration: InputDecoration(
                                      hintText: 'Promo Code',
                                      hintStyle: const TextStyle(
                                        color: Colors.black54,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                      ),
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(24),
                                          borderSide: BorderSide(
                                              width: 0.5,
                                              color: AppColors.yBlackColor
                                                  .withValues(alpha: 0.5))),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 20, vertical: 14),
                                    ),
                                  ),
                                ),
                                Consumer<DiscountProvider>(
                                  builder: (context, discountProvider, _) {
                                    if (discountProvider.couponLoader) {
                                      return const Padding(
                                        padding: EdgeInsets.all(16),
                                        child: SizedBox(
                                          width: 24,
                                          height: 24,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                              Colors.white,
                                            ),
                                          ),
                                        ),
                                      );
                                    }

                                    return Container(
                                      margin: const EdgeInsetsDirectional.only(
                                          start: 8),
                                      decoration: BoxDecoration(
                                        color: AppColors.yPrimaryColor,
                                        borderRadius: BorderRadius.circular(26),
                                      ),
                                      child: Material(
                                        color: Colors.transparent,
                                        child: InkWell(
                                          onTap: () {
                                            FocusScope.of(context).unfocus();
                                            if (_couponController
                                                .text.isNotEmpty) {
                                              discountProvider
                                                  .applyCoupon(
                                                      _couponController.text)
                                                  .then((value) {
                                                Provider.of<CartProvider>(
                                                        context,
                                                        listen: false)
                                                    .setCoupon(discountProvider
                                                        .discountCoupon);
                                              });
                                            }
                                          },
                                          borderRadius:
                                              BorderRadius.circular(26),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 32, vertical: 14),
                                            child: MainText(
                                              'apply'.tr,
                                              color: Colors.white,
                                              fontSize: 15,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: cartProvider.carts.length,
                              itemBuilder: (context, index) {
                                return CartItemCard(
                                  cart: cartProvider.carts[index],
                                  index: index,
                                );
                              },
                            ),
                          ),
                          120.sSize,
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 20,
                        offset: const Offset(0, -4),
                      ),
                    ],
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                  child: SafeArea(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                cartProvider.updateLoader
                                    ? const SizedBox(
                                        height: 24,
                                        width: 24,
                                        child: Center(
                                          child: CircularProgressIndicator(
                                            color: AppColors.yPrimaryColor,
                                          ),
                                        ),
                                      )
                                    : MainText(
                                        '${"total".tr}: \$${cartProvider.totalPrice.toStringAsFixed(2)}',
                                        fontSize: 20,
                                        color: AppColors.yBlackColor,
                                        fontWeight: FontWeight.w700,
                                        textDirection: TextDirection.ltr,
                                      ),
                                4.sSize,
                                MainText(
                                  '${"tickets".tr}: ${cartProvider.carts.length}',
                                  fontSize: 14,
                                  color: AppColors.yGreyColor,
                                  fontWeight: FontWeight.w400,
                                ),
                              ],
                            ),
                            Container(
                              height: 60,
                              width: 140,
                              decoration: BoxDecoration(
                                color: AppColors.yPrimaryColor,
                                borderRadius: BorderRadius.circular(30),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.yPrimaryColor
                                        .withValues(alpha: .2),
                                    blurRadius: 8,
                                    offset: const Offset(0, 6),
                                  ),
                                ],
                              ),
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: cartProvider.carts.isEmpty
                                      ? null
                                      : () {
                                          AppRoutes.routeTo(
                                              context, const CheckoutPage());
                                        },
                                  borderRadius: BorderRadius.circular(30),
                                  child:  Center(
                                    child: MainText(
                                      'checkout'.tr,
                                      fontSize: 17,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
