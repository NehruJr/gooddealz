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
    return Container(
      width: context.width,
      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .06),
            blurRadius: 12,
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: Consumer<CartProvider>(
                builder: (context, cartProvider, _) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        height: 90,
                        width: 90,
                        decoration: BoxDecoration(
                          color: AppColors.yLightGreyColor,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AppColors.yGreyColor.withValues(alpha: .1),
                            width: 1,
                          ),
                        ),
                        padding: const EdgeInsets.all(8),
                        child: FancyShimmerImage(
                          imageUrl: cart.product?.image ?? '',
                          height: 90,
                          width: 90,
                          boxFit: BoxFit.cover,
                          errorWidget: Image.asset(
                            getPngAsset('product'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      16.wSize,
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                        
                            MainText(
                              cart.product?.title ?? '',
                              color: AppColors.yBlackColor,
                              fontSize: 15,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              fontWeight: FontWeight.w600,
                            ),
                            8.sSize,
                       
                            Row(
                              children: [
                                MainText(
                                  cart.price ?? '',
                                  color: AppColors.yPrimaryColor,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  textDirection: TextDirection.ltr,
                                ),
                                4.wSize,
                                MainText(
                                  cart.product?.currency ?? '',
                                  color: AppColors.yPrimaryColor,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  textDirection: TextDirection.ltr,
                                ),
                              ],
                            ),
                            12.sSize,
                       
                            Container(
                              height: 36,
                              decoration: BoxDecoration(
                                color: AppColors.yLightGreyColor,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                 
                                  Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      onTap: cartProvider.updateLoader
                                          ? null
                                          : () {
                                              if (cart.quantity! > 1) {
                                                cartProvider.updateCartQuantity(
                                                  context,
                                                  index: index,
                                                  cart: cart,
                                                  updateType: UpdateType.minus,
                                                );
                                              } else {
                                                showSnackbar(
                                                  'quantity_less_1'.tr,
                                                  error: true,
                                                );
                                              }
                                            },
                                      borderRadius: BorderRadius.circular(10),
                                      child: Container(
                                        width: 36,
                                        height: 36,
                                        decoration: BoxDecoration(
                                          color: cartProvider.updateType ==
                                                      UpdateType.minus &&
                                                  cartProvider.updateLoader &&
                                                  cartProvider.updateCartId ==
                                                      cart.id
                                              ? AppColors.yGreyColor
                                                  .withOpacity(0.3)
                                              : Colors.transparent,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: Icon(
                                          Icons.remove_rounded,
                                          size: 20,
                                          color: cart.quantity! > 1
                                              ? AppColors.yPrimaryColor
                                              : AppColors.yGreyColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    constraints: const BoxConstraints(minWidth: 32),
                                    alignment: Alignment.center,
                                    child: MainText(
                                      '${cart.quantity}',
                                      color: AppColors.yBlackColor,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                        
                                  Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      onTap: cartProvider.updateLoader
                                          ? null
                                          : () {
                                              if (cart.quantity! <
                                                  (cart.product!.quantity! -
                                                      cart.product!
                                                          .quantitySold!)) {
                                                cartProvider.updateCartQuantity(
                                                  context,
                                                  index: index,
                                                  cart: cart,
                                                  updateType: UpdateType.plus,
                                                );
                                              } else {
                                                showSnackbar(
                                                  'no_quantity'.tr,
                                                  error: true,
                                                );
                                              }
                                            },
                                      borderRadius: BorderRadius.circular(10),
                                      child: Container(
                                        width: 36,
                                        height: 36,
                                        decoration: BoxDecoration(
                                          color: cartProvider.updateType ==
                                                      UpdateType.plus &&
                                                  cartProvider.updateLoader &&
                                                  cartProvider.updateCartId ==
                                                      cart.id
                                              ? AppColors.yGreyColor
                                                  .withValues(alpha: .3)
                                              : Colors.transparent,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: const Icon(
                                          Icons.add_rounded,
                                          size: 20,
                                          color: AppColors.yPrimaryColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            Positioned(
              top: 4,
              right: 4,
              child: Consumer<CartProvider>(
                builder: (context, cartProvider, _) {
                  return Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) => ConfirmationDialog(
                            icon: 'black_logo',
                            description: 'delete_question'.tr,
                            onYesPressed: () => cartProvider.deleteCart(
                              context,
                              cartId: cart.id!,
                              index: index,
                            ),
                          ),
                        );
                      },
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.9),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          CupertinoIcons.xmark_circle_fill,
                          color: AppColors.yGreyColor.withValues(alpha: .8),
                          size: 24,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
