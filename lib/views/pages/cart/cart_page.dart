import 'package:flutter/material.dart';
import 'package:goodealz/core/constants/app_colors.dart';
import 'package:goodealz/core/constants/app_routes.dart';
import 'package:goodealz/core/helper/extensions/assetss_widgets.dart';
import 'package:goodealz/core/ys_localizations/ys_localizations.dart';
import 'package:goodealz/data/remote/remote_data.dart';
import 'package:goodealz/providers/cart/cart_provider.dart';
import 'package:goodealz/views/pages/cart/widgets/cart_item_card.dart';
import 'package:goodealz/views/pages/checkout/checkout_page.dart';
import 'package:goodealz/views/widgets/main_button.dart';
import 'package:goodealz/views/widgets/main_page.dart';
import 'package:goodealz/views/widgets/main_text.dart';

import '../../../core/ys_localizations/ys_localizations_provider.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
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
              color: Colors.black.withValues(alpha: .05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: 32.hvEdge,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MainText(
                    'my_cart'.tr,
                    fontSize: 28,
                    color: AppColors.yBlackColor,
                    fontWeight: FontWeight.w700,
                  ),
                  Consumer<CartProvider>(
                    builder: (context, cartProvider, _) {
                      return MainText(
                        '${cartProvider.carts.length} ${'items'.tr}',
                        fontSize: 14,
                        color: AppColors.yGreyColor,
                        fontWeight: FontWeight.w400,
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBarIndex: 2,
      body: Column(
        children: [
          Expanded(
            child: Consumer<CartProvider>(
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
                          padding: 40.aEdge,
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
                          fontWeight: FontWeight.w600,
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
                } else {
                  return ListView(
                    shrinkWrap: true,
                    padding: 16.aEdge,
                    children: [
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: cartProvider.carts.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: CartItemCard(
                              cart: cartProvider.carts[index],
                              index: index,
                            ),
                          );
                        },
                      ),
                    ],
                  );
                }
              },
            ),
          ),
          Consumer<CartProvider>(
            builder: (context, cartProvider, _) {
              if (cartProvider.carts.isEmpty) return const SizedBox.shrink();

              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: .08),
                      blurRadius: 20,
                      offset: const Offset(0, -4),
                    ),
                  ],
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                child: SafeArea(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          MainText(
                            'total'.tr,
                            fontSize: 16,
                            color: AppColors.yGreyColor,
                            fontWeight: FontWeight.w500,
                          ),
                          MainText(
                            '${cartProvider.totalPrice.toStringAsFixed(2)} EGP',
                            fontSize: 22,
                            color: AppColors.yBlackColor,
                            fontWeight: FontWeight.w700,
                          ),
                        ],
                      ),
                      16.sSize,
                      Selector<CartProvider, int>(
                        selector: (context, cartProvider) =>
                            cartProvider.carts.length,
                        builder: (context, cartCount, _) {
                          return MainButton(
                            onPressed: cartCount <= 0
                                ? () {}
                                : () {
                                    AppRoutes.routeTo(
                                        context, const CheckoutPage());
                                  },
                            color: cartCount <= 0
                                ? AppColors.yGreyColor.withValues(alpha: 0.3)
                                : AppColors.yPrimaryColor,
                            width: double.infinity,
                            radius: 16,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                MainText(
                                  'proceed_to_checkout'.tr,
                                  fontSize: 16,
                                  color: cartCount <= 0
                                      ? AppColors.yGreyColor
                                      : Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                                8.wSize,
                                Icon(
                                  Icons.arrow_forward_rounded,
                                  color: cartCount <= 0
                                      ? AppColors.yGreyColor
                                      : Colors.white,
                                  size: 20,
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
