import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:goodealz/core/constants/app_colors.dart';
import 'package:goodealz/core/constants/enums.dart';
import 'package:goodealz/core/helper/extensions/assetss_widgets.dart';
import 'package:goodealz/core/helper/extensions/context_size.dart';
import 'package:goodealz/core/helper/functions/show_snackbar.dart';
import 'package:goodealz/core/ys_localizations/ys_localizations.dart';
import 'package:goodealz/core/ys_localizations/ys_localizations_provider.dart';
import 'package:goodealz/providers/cart/cart_provider.dart';
import 'package:goodealz/views/widgets/dialog/confirmation_dialog.dart';
import 'package:goodealz/views/widgets/main_text.dart';
import 'package:goodealz/views/widgets/rounded_square.dart';

import '../../../../core/helper/functions/get_asset.dart';
import '../../../../data/models/cart/cart_model.dart';

class CartItemCard extends StatelessWidget {
  const CartItemCard({
    super.key,
    required this.cart,
    required this.index,
  });

  final int index;
  final Cart cart;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: context.width,
          height: 110,
          margin: 8.aEdge,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: 10.cBorder,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 5,
              )
            ],
          ),
          child: Padding(
            padding: 12.vhEdge,
            child: Consumer<CartProvider>(builder: (context, cartProvider, _) {
              return Row(
                children: [
                  FancyShimmerImage(
                    imageUrl: cart.product?.image ?? '',
                    height: 84,
                    width: 84,
                    boxFit: BoxFit.contain,
                    errorWidget: Image.asset(
                      getPngAsset('product'),
                      fit: BoxFit.cover,
                    ),
                  ),
                  16.wSize,
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: context.width * 0.3,
                        child: MainText(
                          cart.product?.title ?? '',
                          color: Colors.black.withOpacity(0.5),
                          fontSize: 14,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      MainText(
                        '${cart.price ?? ''} ${cart.product?.currency ?? ''}',
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        textDirection: TextDirection.ltr,
                      ),
                    ],
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: cartProvider.updateLoader
                        ? () {}
                        : () {
                            if(cart.quantity! < (cart.product!.quantity! - cart.product!.quantitySold!)){cartProvider.updateCartQuantity(context,
                                index: index,
                                cart: cart,
                                updateType: UpdateType.plus);
                                }else{
                                  showSnackbar('no_quantity'.tr, error: true);
                                }
                          },
                    child: RoundedSquare(
                      size: 30,
                      padding: 0.aEdge,
                      bgColor: cartProvider.updateType == UpdateType.plus &&
                              cartProvider.updateLoader &&
                              cartProvider.updateCartId == cart.id
                          ? AppColors.yGreyColor
                          : null,
                      child: const Icon(
                        Icons.add,
                        size: 18,
                        color: AppColors.yPrimaryColor,
                      ),
                    ),
                  ),
                  MainText(
                    '${cart.quantity}',
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                  GestureDetector(
                    onTap: cartProvider.updateLoader
                        ? () {}
                        : () {
                            if(cart.quantity! > 1){
                              cartProvider.updateCartQuantity(context,
                                index: index,
                                cart: cart,
                                updateType: UpdateType.minus);
                                }else{
                                  showSnackbar('quantity_less_1'.tr, error: true);
                                }
                          },
                    child: RoundedSquare(
                      size: 30,
                      padding: 0.aEdge,
                      bgColor: cartProvider.updateType == UpdateType.minus &&
                              cartProvider.updateLoader &&
                              cartProvider.updateCartId == cart.id
                          ? AppColors.yGreyColor
                          : null,
                      child: const Icon(
                        Icons.remove,
                        size: 18,
                        color: AppColors.yPrimaryColor,
                      ),
                    ),
                  ),
                ],
              );
            }),
          ),
        ),
        Positioned(
            right: 0,
            child: Consumer<CartProvider>(builder: (context, cartProvider, _) {
              return IconButton(
                  highlightColor: Colors.transparent,
                  padding: EdgeInsets.zero,
                  alignment: Alignment.topRight,
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) => ConfirmationDialog(
                            icon: 'black_logo',
                            description: 'delete_question'.tr,
                            onYesPressed:()=>
                              cartProvider.deleteCart(context,
                                  cartId: cart.id!, index: index)
                            ));
                  },
                  icon: const Icon(CupertinoIcons.clear_circled_solid));
            }))
      ],
    );
  }
}
