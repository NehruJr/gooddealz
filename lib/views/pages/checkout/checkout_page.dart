import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:goodealz/core/constants/app_colors.dart';
import 'package:goodealz/core/constants/app_routes.dart';
import 'package:goodealz/core/helper/extensions/assetss_widgets.dart';
import 'package:goodealz/core/helper/functions/get_asset.dart';
import 'package:goodealz/core/helper/functions/show_snackbar.dart';
import 'package:goodealz/core/ys_localizations/ys_localizations.dart';
import 'package:goodealz/providers/checkout/checkout_provider.dart';
import 'package:goodealz/views/widgets/main_button.dart';
import 'package:goodealz/views/widgets/main_page.dart';
import 'package:goodealz/views/widgets/main_text.dart';
import 'package:goodealz/views/widgets/main_textfield.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../core/helper/functions/navigation_service.dart';
import '../../../core/ys_localizations/ys_localizations_provider.dart';
import '../../../providers/cart/cart_provider.dart';
import '../../../providers/discount/discount_provider.dart';
import '../../widgets/dropdown/custom_dropdown.dart';
import '../../widgets/location_permission_dialog.dart';
import '../location_screen/location_screen.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final _couponController = TextEditingController();
  final _addressController = TextEditingController();

  double? lat;
  double? lng;

  String? city;
  String paymentMethod = 'card';
  final Completer<GoogleMapController> _controller = Completer();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<CheckoutProvider>(context, listen: false).getCities();
      Provider.of<CartProvider>(context, listen: false).clearData();
      Provider.of<CheckoutProvider>(context, listen: false).clearData();
      Provider.of<DiscountProvider>(context, listen: false).clearCoupon();
      _determinePosition();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _determinePosition() async {
    _checkPermission(() {
      Provider.of<CheckoutProvider>(context, listen: false)
          .getCurrentLocation(context, _controller);
    });
  }

  bool digitalMethod = false;

  @override
  Widget build(BuildContext context) {
    return MainPage(
      actionWidgets: [
        SizedBox(
          height: 90,
          width: 110,
          child: Padding(
            padding: const EdgeInsets.only(top: 6.0),
            child: Image.asset(
              getPngAsset('black_logo'),
              fit: BoxFit.cover,
            ),
          ),
        )
      ],
      subAppBar: Padding(
        padding: 16.vhEdge,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            MainText(
              'checkout'.tr,
              fontSize: 22,
              color: Colors.black,
              fontWeight: FontWeight.w500,
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: 16.aEdge,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            8.sSize,
            MainText(
              'delivery_address'.tr,
              color: Colors.black.withOpacity(0.9),
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
            16.sSize,
            Consumer<CheckoutProvider>(builder: (context, checkoutProvider, _) {
              print('position ==============================');
              print(
                  '${checkoutProvider.myPosition?.latitude}, ${checkoutProvider.myPosition?.longitude}');
              return Container(
                width: 680,
                height: 250,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                      width: 2, color: Theme.of(context).primaryColor),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Stack(clipBehavior: Clip.none, children: [
                    GoogleMap(
                      initialCameraPosition: CameraPosition(
                          target: checkoutProvider.myPosition != null
                              ? LatLng(checkoutProvider.myPosition!.latitude,
                                  checkoutProvider.myPosition!.longitude)
                              : const LatLng(23, 89),
                          zoom: 12),
                      minMaxZoomPreference: const MinMaxZoomPreference(0, 16),
                      onTap: (latLng) {
                        AppRoutes.routeTo(
                            context,
                            LocationScreen(
                              latLng: checkoutProvider.myPosition != null
                                  ? LatLng(
                                      checkoutProvider.myPosition!.latitude,
                                      checkoutProvider.myPosition!.longitude)
                                  : const LatLng(23, 89),
                            ), then: (value) {
                          if (value != null && value.isNotEmpty) {
                            print('00000000000000000000000');
                            // checkoutProvider
                            //     .getDeliveryCost(context)
                            //     .then((value) {
                            //   Provider.of<CartProvider>(context,
                            //       listen: false)
                            //       .setDeliveryCost(checkoutProvider.deliveryCost??0);
                            // });
                            _addressController.text = value['address'];
                            lat = value['lat'];
                            lng = value['lng'];
                          }
                        });
                      },
                      zoomControlsEnabled: false,
                      compassEnabled: false,
                      indoorViewEnabled: true,
                      mapToolbarEnabled: false,
                      // onCameraIdle: () {
                      //   locationController.updatePosition(_cameraPosition, true);
                      // },
                      // onCameraMove: ((position) => _cameraPosition = position),
                      // onMapCreated: (GoogleMapController controller) {
                      //   locationController.setMapController(controller);
                      //   if(widget.address == null) {
                      //     locationController.getCurrentLocation(true, mapController: controller);
                      //   }
                      // },
                      onMapCreated: (GoogleMapController controller) {
                        _controller.complete(controller);
                      },
                    ),
                    // locationController.loading ? const Center(child: CircularProgressIndicator()) : const SizedBox(),
                    // Center(child: !locationController.loading ? Image.asset(Images.pickMarker, height: 50, width: 50)
                    //     : const CircularProgressIndicator()),
                    // Positioned(
                    //   bottom: 10,
                    //   right: 0,
                    //   child: InkWell(
                    //     // onTap: () => _checkPermission(() {
                    //     //   locationController.getCurrentLocation(true, mapController: locationController.mapController);
                    //     // }),
                    //     child: Container(
                    //       width: 30,
                    //       height: 30,
                    //       margin: const EdgeInsets.only(right: 10),
                    //       decoration: BoxDecoration(
                    //           borderRadius: BorderRadius.circular(15),
                    //           color: Colors.white),
                    //       child: const Icon(Icons.my_location,
                    //           color: AppColors.yPrimaryColor, size: 20),
                    //     ),
                    //   ),
                    // ),
                    Positioned(
                      top: 10,
                      right: 0,
                      child: InkWell(
                        onTap: () {
                          AppRoutes.routeTo(
                              context,
                              LocationScreen(
                                latLng: checkoutProvider.myPosition != null
                                    ? LatLng(
                                        checkoutProvider.myPosition!.longitude,
                                        checkoutProvider.myPosition!.longitude)
                                    : const LatLng(23, 89),
                              ), then: (value) {
                            if (value != null && value.isNotEmpty) {
                              // checkoutProvider
                              //     .getDeliveryCost(context)
                              //     .then((value) {
                              //   Provider.of<CartProvider>(context,
                              //           listen: false)
                              //       .setDeliveryCost(checkoutProvider.deliveryCost??0);
                              // });
                              _addressController.text = value['address'];
                              lat = value['lat'];
                              lng = value['lng'];
                            }
                          });
                        },
                        child: Container(
                          width: 30,
                          height: 30,
                          margin: const EdgeInsets.only(right: 10),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: Colors.white),
                          child: Icon(Icons.fullscreen,
                              color: Theme.of(context).primaryColor, size: 20),
                        ),
                      ),
                    ),
                  ]),
                ),
              );
            }),
            // ClipRRect(
            //   borderRadius: BorderRadius.circular(15),
            //   child: GoogleMap(
            //     initialCameraPosition: CameraPosition(target: _currentPosition),
            //     onTap: (latLng){
            //       AppRoutes.routeTo(context, const LocationScreen());
            //     },
            //       // child: Image.asset(getPngAsset('map'))
            //   ),
            // ),
            16.sSize,

            Consumer<CheckoutProvider>(builder: (context, checkoutProvider, _) {
              return CustomDropDown(
                list: checkoutProvider.cities.map((e) => e.name!).toList(),
                borderColor: AppColors.ySecondryColor,
                hint: 'select_city'.tr,
                item: city,
                enabled: checkoutProvider.cityLoader ? false : true,
                onChange: (val) {
                  city = val;
                  checkoutProvider
                      .getDeliveryCost(context, city: city!)
                      .then((value) {
                    Provider.of<CartProvider>(context, listen: false)
                        .setDeliveryCost(checkoutProvider.deliveryCost ?? 0);
                  });
                },
                validator: (val) {
                  return null;
                },
                // enable: false,
              );
            }),
            16.sSize,
            Selector<CheckoutProvider, String?>(
                selector: (context, checkoutProvider) =>
                    checkoutProvider.address,
                builder: (context, address, _) {
                  return MainMultiLinesTextField(
                    maxLines: null,
                    borderColor: AppColors.ySecondryColor,
                    hint: 'enter_address'.tr,
                    controller: _addressController,
                    // enable: false,
                  );
                }),
            16.sSize,
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
                  paymentMethod = value ?? '';
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
                  paymentMethod = value ?? '';
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
                  paymentMethod = value ?? '';
                });
              },
              title: MainText(
                'cash'.tr,
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: Colors.black.withOpacity(0.5),
              ),
            ),
            16.sSize,
            // MainMultiLinesTextField(
            //   maxLines: 5,
            //   hint: 'additional_note'.tr,
            //   unfocusWhenTapOutside: true,
            //   borderColor: Colors.black12,
            // ),
            // 16.sSize,

            Container(
              height: 50,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                      width: .5,
                      color: Theme.of(context).primaryColor.withOpacity(.9))),
              child: Row(children: [
                Expanded(
                  child: SizedBox(
                    height: 50,
                    child: Padding(
                      padding:
                          const EdgeInsets.only(left: 5, bottom: 5, top: 5),
                      child: Center(
                        child: MainTextField(
                          controller: _couponController,
                          hint: 'have_coupon'.tr,
                        ),
                      ),
                    ),
                  ),
                ),
                8.sSize,
                Consumer<DiscountProvider>(
                    builder: (context, discountProvider, _) {
                  if (discountProvider.couponLoader) {
                    return Padding(
                      padding: 16.aEdge,
                      child: SizedBox(
                          width: 30,
                          height: 30,
                          child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  Theme.of(context).primaryColor))),
                    );
                  } else {
                    return InkWell(
                      onTap: () {
                        FocusScope.of(context).unfocus();
                        if (_couponController.text.isNotEmpty) {
                          discountProvider
                              .applyCoupon(_couponController.text)
                              .then((value) {
                            print('--=-==-=--');
                            print(discountProvider.discountCoupon);
                            Provider.of<CartProvider>(context, listen: false)
                                .setCoupon(discountProvider.discountCoupon);
                          });
                        }
                      },
                      child: Container(
                          width: 100,
                          height: 60,
                          decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              borderRadius: YsLocalizationsProvider.listenFalse(
                                              NavigationService.currentContext)
                                          .languageCode ==
                                      'en'
                                  ? const BorderRadius.only(
                                      bottomRight: Radius.circular(10),
                                      topRight: Radius.circular(10))
                                  : const BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                      bottomLeft: Radius.circular(10))),
                          child: Center(
                              child: MainText(
                            'apply'.tr,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ))),
                    );
                  }
                })
              ]),
            ),

            16.sSize,
            Consumer<CartProvider>(builder: (context, cartProvider, _) {
              return Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      MainText(
                        'sub_total'.tr,
                        color: Colors.black.withOpacity(0.5),
                        fontSize: 14,
                      ),
                      MainText(
                        '${cartProvider.subTotalPrice} ${cartProvider.currency}',
                        color: Colors.black.withOpacity(0.5),
                        fontSize: 14,
                        textDirection: TextDirection.ltr,
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
                        '${cartProvider.deliveryCost} ${cartProvider.currency}',
                        color: Colors.black.withOpacity(0.5),
                        fontSize: 14,
                        textDirection: TextDirection.ltr,
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
                        '${cartProvider.discount.toStringAsFixed(2)} ${cartProvider.currency}',
                        color: Colors.black.withOpacity(0.5),
                        fontSize: 14,
                        textDirection: TextDirection.ltr,
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
                        '${cartProvider.totalPrice} ${cartProvider.currency}',
                        color: Colors.black.withOpacity(0.5),
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                        textDirection: TextDirection.ltr,
                      ),
                    ],
                  ),
                ],
              );
            }),
            16.sSize,
            Center(
              child: Consumer<CheckoutProvider>(
                  builder: (context, checkoutProvider, _) {
                return MainButton(
                  onPressed: checkoutProvider.checkoutLoader
                      ? () {}
                      : () {
                          if (city == null) {
                            showSnackbar('please_select_city'.tr);
                          } else if (_addressController.text.isEmpty) {
                            showSnackbar('please_select_address'.tr);
                          } else if (lat == null || lng == null) {
                            showSnackbar('please_pick_location'.tr);
                          } else {
                            checkoutProvider.checkout(context,
                                city: city!,
                                address: _addressController.text,
                                paymentMethod: paymentMethod,
                                lat: lat!,
                                lng: lng!);
                          }
                        },
                  color: checkoutProvider.checkoutLoader
                      ? AppColors.ySecondryColor
                      : AppColors.yPrimaryColor,
                  width: 150,
                  radius: 28,
                  child: MainText(
                    checkoutProvider.checkoutLoader
                        ? 'wait'.tr
                        : 'place_order'.tr,
                    fontSize: 15,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  void _checkPermission(Function onTap) async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.denied) {
      showSnackbar('you_have_to_allow'.tr);
    } else if (permission == LocationPermission.deniedForever) {
      showDialog(
          context: context, builder: (context) => const PermissionDialog());
    } else {
      onTap();
    }
  }
}
