import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:goodealz/core/constants/app_colors.dart';
import 'package:goodealz/core/constants/enums.dart';
import 'package:goodealz/core/helper/extensions/assetss_widgets.dart';
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
    return Consumer<CartProvider>(
      builder: (context, cartProvider, _) {
        final price = double.tryParse(cart.price ?? '0') ?? 0;
        final isUpdating =
            cartProvider.updateLoader && cartProvider.updateCartId == cart.id;

        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 12,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.yLightGreyColor,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: FancyShimmerImage(
                    imageUrl: cart.product?.image ?? '',
                    height: 200,
                    width: double.infinity,
                    boxFit: BoxFit.cover,
                    errorWidget: Image.asset(
                      getPngAsset('product'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              16.sSize,
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 60,
                    width: 60,
                    decoration: BoxDecoration(
                      color: AppColors.yLightGreyColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: FancyShimmerImage(
                        imageUrl: cart.product?.image ?? '',
                        height: 60,
                        width: 60,
                        boxFit: BoxFit.cover,
                        errorWidget: Image.asset(
                          getPngAsset('product'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  12.wSize,
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
                          fontWeight: FontWeight.w600,
                        ),
                        8.sSize,
                        MainText(
                          '\$${price.toStringAsFixed(2)}',
                          color: AppColors.yPrimaryColor,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          textDirection: TextDirection.ltr,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        GestureDetector(
                          onTap: cartProvider.updateLoader
                              ? null
                              : () {
                                  if (cart.quantity! <
                                      (cart.product!.quantity! -
                                          cart.product!.quantitySold!)) {
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
                          child: Container(
                            width: 28,
                            height: 28,
                            decoration: const BoxDecoration(
                              color: AppColors.yPrimaryColor,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.add,
                              size: 18,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: isUpdating
                              ? Padding(
                                  padding: 6.vEdge,
                                  child: const SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        AppColors.yPrimaryColor,
                                      ),
                                    ),
                                  ),
                                )
                              : MainText(
                                  '${cart.quantity}',
                                  color: AppColors.yBlackColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                        ),
                        GestureDetector(
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
                          child: Container(
                            width: 28,
                            height: 28,
                            decoration: BoxDecoration(
                              color: cart.quantity! > 1
                                  ? AppColors.yGreyColor
                                  : AppColors.yGreyColor.withOpacity(0.5),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.remove,
                              size: 18,
                              color: cart.quantity! > 1
                                  ? AppColors.yBlackColor
                                  : AppColors.yGreyColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
