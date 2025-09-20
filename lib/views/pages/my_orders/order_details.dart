import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';

import 'package:goodealz/core/helper/extensions/assetss_widgets.dart';
import 'package:goodealz/core/helper/functions/get_asset.dart';
import 'package:goodealz/core/ys_localizations/ys_localizations.dart';
import 'package:goodealz/data/models/order/order_model.dart';
import 'package:goodealz/providers/checkout/checkout_provider.dart';
import 'package:goodealz/views/widgets/main_page.dart';
import 'package:goodealz/views/widgets/main_text.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/ys_localizations/ys_localizations_provider.dart';
import '../../../providers/payment/payment_provider.dart';
import '../../widgets/main_button.dart';

class OrderDetailsPage extends StatefulWidget {
  const OrderDetailsPage({super.key, required this.order});
  final Orders order;

  @override
  State<OrderDetailsPage> createState() => _OrderDetailsPageState();
}

class _OrderDetailsPageState extends State<OrderDetailsPage> {

  String paymentMethod = 'card';

  @override
  Widget build(BuildContext context) {
    print(widget.order.status);
    return MainPage(
      title: 'order_details'.tr,
      body: SingleChildScrollView(
        padding: 16.aEdge,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _orderInfo(),
            25.sSize,
            _itemInfo(),
            25.sSize,
            _deliveryInfo(),
            25.sSize,
        _orderSummary(),
            16.sSize,
            if(widget.order.status == 'Pending payment')Column(
              children: [
                MainText(
                  'payment_method'.tr,
                  color: Colors.black.withOpacity(0.9),
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
                RadioListTile(
                  value: 'card',
                  groupValue: paymentMethod,
                  fillColor: const WidgetStatePropertyAll(Colors.red),
                  contentPadding: EdgeInsets.zero,
                  onChanged: (value) {
                    setState(() {
                      paymentMethod = value??'';
                    });
                  },
                  title: MainText(
                    'digital_payment'.tr,
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: Colors.black.withOpacity(0.5),
                  ),
                ),
                RadioListTile(
                  value: 'wallet',
                  groupValue: paymentMethod,
                  fillColor: const WidgetStatePropertyAll(Colors.red),
                  contentPadding: EdgeInsets.zero,
                  onChanged: (value) {
                    setState(() {
                      paymentMethod = value??'';
                    });
                  },
                  title: MainText(
                    'wallet'.tr,
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: Colors.black.withOpacity(0.5),
                  ),
                ),
                RadioListTile(
                  value: 'cash',
                  groupValue: paymentMethod,
                  fillColor: const WidgetStatePropertyAll(Colors.red),
                  contentPadding: EdgeInsets.zero,
                  onChanged: (value) {
                    setState(() {
                      paymentMethod = value??'';
                    });
                  },
                  title: MainText(
                    'cash'.tr,
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: Colors.black.withOpacity(0.5),
                  ),
                ),

                Center(
                  child: Consumer<PaymentProvider>(
                      builder: (context, paymentProvider, _) {
                        final repayLoader = Provider.of<CheckoutProvider>(context,)
                            .repayLoader;
                        return MainButton(
                          onPressed: paymentProvider.payLoader || repayLoader ? (){} : () {
                            if(paymentMethod == 'card'){
                                  Provider.of<PaymentProvider>(context,
                                          listen: false)
                                      .checkoutPay(context,
                                          order: widget.order);
                                }
                            else{
                              Provider.of<CheckoutProvider>(context,
                                  listen: false)
                                  .repayOrder(context, paymentMethod: paymentMethod,
                                  order: widget.order);
                            }
                              },

                          color: paymentProvider.payLoader || repayLoader ? AppColors.ySecondryColor :   AppColors.yPrimaryColor,
                          width: 150,
                          verticalPadding: 8,
                          radius: 8,
                          child: FittedBox(
                            child: MainText(
                              paymentProvider.payLoader || repayLoader ? 'wait'.tr : 'pay'.tr,
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        );
                      }
                  ),
                ),
                16.sSize,
                SizedBox(
                  width: 220,
                  child: Row(
                    children: [
                      Expanded(
                          child: Divider(
                            color: Colors.black.withOpacity(0.6),
                          )),
                      Padding(
                        padding: 12.aEdge,
                        child: MainText(
                          'or'.tr,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                      Expanded(
                          child: Divider(
                            color: Colors.black.withOpacity(0.6),
                          )),
                    ],
                  ),
                ),
                16.sSize,
                Center(
                  child: Consumer<CheckoutProvider>(
                      builder: (context, checkoutProvider, _) {
                        return MainButton(
                          onPressed: checkoutProvider.cancelLoader ? (){} : () {
                            checkoutProvider.cancelOrder(context, orderNumber: widget.order.orderNumber??'');
                          },
                          color: checkoutProvider.cancelLoader ? AppColors.ySecondryColor :  AppColors.yPrimaryColor,
                          width: 150,
                          verticalPadding: 12,
                          radius: 8,
                          child: FittedBox(
                            child: MainText(
                              checkoutProvider.cancelLoader ? 'wait'.tr : 'cancel_order'.tr,
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        );
                      }
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _orderInfo(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MainText('general_info'.tr, fontWeight: FontWeight.bold),
        16.sSize,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            MainText('order_number'.tr),
            MainText('#${widget.order.orderNumber}', fontWeight: FontWeight.w500,),
          ],
        ),
        8.sSize,
        // const Divider(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            MainText('order_status'.tr),
            MainText('${widget.order.status}'),
          ],
        ),
        8.sSize,
        if(widget.order.status == 'Paid')Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            MainText('payment_method'.tr),
            MainText('${widget.order.paymentMethod}'),
          ],
        ),
      ],
    );
  }

  Widget _itemInfo(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MainText('item_info'.tr, fontWeight: FontWeight.bold),
        16.sSize,
        ListView.separated(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: widget.order.products!.length,
          separatorBuilder: (context, index)=> 16.sSize,
          itemBuilder:  (context, index)=> Row(
            children: [
          FancyShimmerImage(
          imageUrl: widget.order.products?[index].image ?? '',
            width: 50,
            height: 50,
            boxFit: BoxFit.cover,
            errorWidget: Image.asset(
              getPngAsset('product'),
              fit: BoxFit.cover,
            ),
          ),
              8.wSize,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
              SizedBox(
                  width: MediaQuery.of(context).size.width * 0.4,
                  child: MainText(widget.order.products?[index].title??'', overflow: TextOverflow.ellipsis,)),
                  8.sSize,
                  MainText(
                    '${widget.order.products?[index].price ?? ''} ${widget.order.products?[index].currency ?? ''}',
                    color: Colors.black,
                    fontWeight: FontWeight.w400,
                  ),

                ],
              ),
              const Spacer(),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.2,
                child: MainText(
                  '${'quantity'.tr}: ${widget.order.products?[index].quantityInOrder ?? ''}',
                  color: Colors.black,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget _deliveryInfo(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MainText('delivery_details'.tr, fontWeight: FontWeight.bold),
        16.sSize,
        Row(
          children: [
            const Icon(Icons.location_city, color: Colors.blueAccent,),
            8.wSize,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MainText('city'.tr, fontWeight: FontWeight.w400),
                MainText(widget.order.city?.name??'',),
              ],
            )
          ],
        ),
        8.sSize,
        Row(
          children: [
            const Icon(Icons.location_on_rounded, color: Colors.green,),
            8.wSize,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MainText('address'.tr, fontWeight: FontWeight.w400),
                SizedBox(
                  width: MediaQuery.of(context).size.width - 100,
                    child: MainText(widget.order.address??'', overflow: TextOverflow.ellipsis, maxLines: 2,)),
              ],
            )
          ],
        ),
      ],
    );
  }

  Widget _orderSummary(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MainText('order_summary'.tr, fontWeight: FontWeight.bold),
        16.sSize,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            MainText(
              'sub_total'.tr,
              color: Colors.black.withOpacity(0.5),
              fontSize: 14,
            ),
            MainText(
              '${widget.order.subTotal} ${widget.order.products![0].currency}',
              color: Colors.black.withOpacity(0.5),
              fontSize: 14,
            ),
          ],
        ),
        8.sSize,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            MainText(
              'delivery_charge'.tr,
              color: Colors.black.withOpacity(0.5),
              fontSize: 14,
            ),
            MainText(
              '${widget.order.shippingFee ??0} ${widget.order.products![0].currency}',
              color: Colors.black.withOpacity(0.5),
              fontSize: 14,
            ),
          ],
        ),
        8.sSize,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            MainText(
              'discount'.tr,
              color: Colors.black.withOpacity(0.5),
              fontSize: 14,
            ),
            MainText(
              '${widget.order.discountAmount??0} ${widget.order.products![0].currency}',
              color: Colors.black.withOpacity(0.5),
              fontSize: 14,
            ),
          ],
        ),
        16.sSize,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            MainText(
              'total'.tr,
              color: Colors.black.withOpacity(0.5),
              fontWeight: FontWeight.w600,
              fontSize: 18,
            ),
            MainText(
              '${widget.order.total} ${widget.order.products![0].currency}',
              color: Colors.black.withOpacity(0.5),
              fontWeight: FontWeight.w600,
              fontSize: 18,
            ),
          ],
        ),
      ],
    );
  }
}
