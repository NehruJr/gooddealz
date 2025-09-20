import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:goodealz/core/constants/app_routes.dart';
import 'package:goodealz/core/helper/extensions/assetss_widgets.dart';
import 'package:goodealz/core/helper/extensions/context_size.dart';
import 'package:goodealz/core/ys_localizations/ys_localizations_provider.dart';
import 'package:goodealz/data/models/order/order_model.dart';
import 'package:goodealz/providers/cart/cart_provider.dart';
import 'package:goodealz/views/widgets/main_text.dart';

import '../../../../core/helper/functions/get_asset.dart';
import '../../providers/order/order_provider.dart';
import '../pages/my_orders/order_details.dart';

class OrderCard extends StatelessWidget {
  const OrderCard({
    super.key,
    required this.order,
    required this.index,
  });

  final int index;
  final Orders order;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ()=> AppRoutes.routeTo(context, OrderDetailsPage(order: order,), then: (String? val){
        if(val != null){
          if(val == 'cancel'){
            Provider.of<OrderProvider>(context, listen: false)
                .getOrders(context, "pending payment");
          }
        }
      }),
      child: Container(
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
                  imageUrl: order.products![0].image ?? '',
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
                    MainText(
                      order.orderNumber ?? '',
                      color: Colors.black.withOpacity(0.5),
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                    MainText(
                      '${order.total} ${order.products![0].currency}',
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ],
                ),
                // const Spacer(),

              ],
            );
          }),
        ),
      ),
    );
  }
}
