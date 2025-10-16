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
      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .08),
            blurRadius: 16,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Consumer<CartProvider>(
        builder: (context, cartProvider, _) {
          final currency = cart.product?.currency ?? 'EGP';
          final price = double.tryParse(cart.price ?? '0') ?? 0;
          final totalPrice = price * (cart.quantity ?? 1);

          return Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 120,
                          width: 120,
                          decoration: BoxDecoration(
                            color: AppColors.yLightGreyColor,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: AppColors.yGreyColor.withValues(alpha: .1),
                              width: 1,
                            ),
                          ),
                          padding: const EdgeInsets.all(8),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: FancyShimmerImage(
                              imageUrl: cart.product?.image ?? '',
                              height: 120,
                              width: 120,
                              boxFit: BoxFit.cover,
                              errorWidget: Image.asset(
                                getPngAsset('product'),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        16.wSize,
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              MainText(
                                cart.product?.title ?? '',
                                color: AppColors.yBlackColor,
                                fontSize: 16,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                fontWeight: FontWeight.w700,
                              ),
                              10.sSize,
                              Row(
                                children: [
                                  MainText(
                                    '${price.toStringAsFixed(2)}',
                                    color: AppColors.yPrimaryColor,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w800,
                                    textDirection: TextDirection.ltr,
                                  ),
                                  6.wSize,
                                  MainText(
                                    currency,
                                    color: AppColors.yPrimaryColor,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    textDirection: TextDirection.ltr,
                                  ),
                                ],
                              ),
                              12.sSize,
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.yPrimaryColor
                                      .withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: MainText(
                                  '${'total'.tr}: ${totalPrice.toStringAsFixed(2)} $currency',
                                  color: AppColors.yPrimaryColor,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  textDirection: TextDirection.ltr,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    20.sSize,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          height: 44,
                          decoration: BoxDecoration(
                            color: AppColors.yLightGreyColor,
                            borderRadius: BorderRadius.circular(12),
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
                                  borderRadius: BorderRadius.circular(12),
                                  child: Container(
                                    width: 44,
                                    height: 44,
                                    decoration: BoxDecoration(
                                      color: cartProvider.updateType ==
                                                  UpdateType.minus &&
                                              cartProvider.updateLoader &&
                                              cartProvider.updateCartId ==
                                                  cart.id
                                          ? AppColors.yGreyColor
                                              .withOpacity(0.2)
                                          : Colors.transparent,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Icon(
                                      Icons.remove_rounded,
                                      size: 22,
                                      color: cart.quantity! > 1
                                          ? AppColors.yPrimaryColor
                                          : AppColors.yGreyColor,
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                constraints: const BoxConstraints(minWidth: 50),
                                alignment: Alignment.center,
                                child: MainText(
                                  '${cart.quantity}',
                                  color: AppColors.yBlackColor,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
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
                                  borderRadius: BorderRadius.circular(12),
                                  child: Container(
                                    width: 44,
                                    height: 44,
                                    decoration: BoxDecoration(
                                      color: cartProvider.updateType ==
                                                  UpdateType.plus &&
                                              cartProvider.updateLoader &&
                                              cartProvider.updateCartId ==
                                                  cart.id
                                          ? AppColors.yGreyColor
                                              .withValues(alpha: .2)
                                          : Colors.transparent,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: const Icon(
                                      Icons.add_rounded,
                                      size: 22,
                                      color: AppColors.yPrimaryColor,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (context) => ConfirmationDialog(
                                  icon: 'black_logo',
                                  description: 'delete_question'.tr,
                                  onYesPressed: () =>
                                      cartProvider.deleteCart(
                                    context,
                                    cartId: cart.id!,
                                    index: index,
                                  ),
                                ),
                              );
                            },
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 10,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.red.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                CupertinoIcons.trash,
                                color: Colors.red.withValues(alpha: 0.7),
                                size: 22,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}