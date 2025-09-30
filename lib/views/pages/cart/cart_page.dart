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
      subAppBar: Padding(
        padding: 32.hvEdge,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            MainText(
              'my_cart'.tr,
              fontSize: 26,
              color: Colors.black,
              fontWeight: FontWeight.w600,
            ),
          ],
        ),
      ),
      bottomNavigationBarIndex: 2,
      body: Column(
        children: [
          Expanded(
            child: ListView(
              shrinkWrap: true,
              padding: 16.aEdge,
              // crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                8.sSize,
                Consumer<CartProvider>(builder: (context, cartProvider, _) {
                  if (cartProvider.cartLoader) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    return cartProvider.carts.isEmpty
                        ? Center(
                            child: MainText('no_product'.tr),
                          )
                        : ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: cartProvider.carts.length,
                            itemBuilder: (context, index) {
                              return CartItemCard(
                                cart: cartProvider.carts[index],
                                index: index,
                              );
                            },
                          );
                  }
                }),

              ],
            ),
          ),
          8.sSize,
              Selector<CartProvider, int>(
                selector: (context, cartProvider)=> cartProvider.carts.length,
                builder: (context, cartCount, _) {
                  return MainButton(
                    onPressed: cartCount <= 0 ? (){} : () {
                      AppRoutes.routeTo(context, const CheckoutPage());
                    },
                    color: cartCount <= 0 ? AppColors.yGreyColor : AppColors.yPrimaryColor,
                    width: 150,
                    radius: 28,
                    child: MainText(
                      'checkout'.tr,
                      fontSize: 15,
                      color: cartCount <= 0 ? AppColors.yBlackColor : Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  );
                }
              ),

        ],
      ),
    );
  }
}
